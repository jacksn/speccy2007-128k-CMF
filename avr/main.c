#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <avr/eeprom.h>
#include <avr/pgmspace.h>
#include <avr/sleep.h>
#include <string.h>

#include "timeout.h"

#include "types.h"
#include "diskio.h"
#include "ff.h"
#include "betadsk.h"

#include "config.h"
#include "options.h"
#include "pport.h"
#include "pc_keyb.h"

struct CFlags
{
	unsigned int key_parity : 1;
	unsigned int key_ack : 1;
	unsigned int key_aa : 1;
	unsigned int key_ext : 1;
	unsigned int key_release : 1;

	unsigned int key_alt : 1;
	unsigned int key_ctrl : 1;

	unsigned int tape_start : 1;
	unsigned int tape_on : 1;
	unsigned int tape_turbo : 1;
	unsigned int tape_tzx : 1;
	unsigned int tape_pause : 1;
	unsigned int tape_precise : 1;
	unsigned int tape_loop : 1;
	unsigned int tape_ready : 1;

	unsigned int pport_on : 1;
	unsigned int pport_send : 1;
	unsigned int pport_wait : 1;

	unsigned int pport_read : 1;
	unsigned int pport_write : 1;

	unsigned int nowait_mode : 1;
	unsigned int sinclair_mode : 1;
	unsigned int pause_mode : 1;
	unsigned int patchrom_mode : 1;

	unsigned int betadsk_on : 1;	

#if BETADSK_LEDS
	unsigned int motor_status_change : 1;
	unsigned int set_leds :	1;
#endif

};

struct CFlags flags;

word loop_file_pos;
byte loop_buff_pos;
word loop_counter;

byte pport_buff[PP_CMD_SIZE];
byte pport_buff_pos = 0;

word file_pos;

#define BUFF_SIZE 0x40
byte buff[BUFF_SIZE + 1];
byte buff_pos;
byte buff_size;

#define TAPE_SIZE 0x20
byte tape[TAPE_SIZE];
byte tape_size;
byte tape_byte;
byte tape_bit;

word pulse_pilot;
word pulse_sync1;
word pulse_sync2;
word pulse_zero;
word pulse_one;

word tape_pilot = 0;
byte tape_sync  = 0;
word tape_pause = 0;
byte tape_lastbit = 0;

dword block_size = 0;
byte sequence_size = 0;
word skip_size = 0;


byte key_temp = 0;
volatile byte key_tick = 0;
byte key_send = 0;

#define KEYS_SIZE 0x20
byte keys_buff[KEYS_SIZE];
byte keys_buff_put_pos = 0;
byte keys_buff_get_pos = 0;

byte key_port[9];

byte last_req = 0xff;
byte tape_port = 0xff;

char new_snap_name[14] = "snap00.sna";
char cfg_filename[127];


byte snap_header[27];

FATFS fatfs;
DIR dir;
FIL file, fileSrc;

word cfg_flags;

#if BETADSK_LEDS
volatile byte motor_status = 0;
volatile byte motor_new_status = 0;
#endif

extern byte PROGMEM key_matrix[72][6];

//#define P_ROM0	 		(1 << PD0)
//#define P_ROM1	 		(1 << PD1)

#define P_PROM	 		(1 << PD0)
#define P_TRDOS	 		(1 << PD1)

#define P_KCLK	 		(1 << PD2)
#define P_AVR_INT 		(1 << PD3)
#define P_WR		 	(1 << PD4)
#define P_A0		 	(1 << PD5)
#define P_AVR_NOINT 	(1 << PD6)

#define P_TAPE_IN	 	(1 << PD7)

#define P_Z80_RST 		(1 << PB0)
#define P_Z80_NMI 		(1 << PB1)
#define P_KDAT	 		(1 << PB2)
#define P_AVR_WAIT 		(1 << PB3)
#define P_SDC	 		(1 << PB4)


#define ResumeZ80() 	{ \
							PORTB |= P_AVR_WAIT; \
							while( (PIND & P_AVR_INT) == 0 ); \
							DDRA = 0x0; \
							PORTA = 0xff; \
							PORTB &= ~P_AVR_WAIT; \
						}

#define ResumeZ80_1()   { \
                            PORTB |= P_AVR_WAIT; \
                            while( (PIND & P_AVR_INT) == 0 ); \
                            PORTB &= ~P_AVR_WAIT; \
                        }

#define WaitOn() 	PORTB |= P_AVR_WAIT
#define WaitOff() 	PORTB &= ~P_AVR_WAIT

#define KbdIntEnable() 		PORTD |= P_AVR_NOINT
#define KbdIntDisable() 	PORTD &= ~P_AVR_NOINT

void init_inerrupts()
{
	ACSR |= ( 1 << ACD );									// disable analog comparator
	MCUCR = /*(1 << ISC00) |*/ ( 1 << ISC01 ) | ( 1 << ISC11 );	// falling age

	GICR |= ( 1 << INT0 ) | ( 1 << INT1 );
	PORTB &= ~P_AVR_WAIT;						// next wait
}

void init_counters()
{
	TCNT0 = 0;
	OCR0 = 136;

	TCCR0 = ( 1 << WGM01 ) | ( 1 << CS02 ) | ( 1 << CS00 );

	TCNT1H = 0;
	TCNT1L = 0;

	OCR1AH = 0x36;
	OCR1AL = 0xb0;

	TCCR1B = ( 1 << CS10 );
	TIMSK = ( 1 << OCIE1A ) | ( 1 << OCIE0 );
}

void init_ports()
{
	PORTA = 0xff;
	PORTB = P_Z80_NMI | P_KDAT | P_AVR_WAIT;
	PORTC = 0;
	PORTD = P_KCLK | P_AVR_INT;

	DDRA = 0;
	DDRB = P_Z80_RST | P_Z80_NMI | P_AVR_WAIT | P_SDC | ( 1 << PB5 ) | ( 1 << PB7 );
	DDRC = 0;

	DDRD = P_PROM | P_AVR_NOINT | P_TAPE_IN;
}

void ResetKeys()
{
	byte i;
	for ( i = 0; i < 9; i++ ) key_port[i] = 0xff;

	key_temp = 0;
	key_tick = 0;
	key_send = 0;
}

void SendKeyByte( char key )
{
	while ( key_tick != 0 );

	DDRB |= P_KDAT;
	PORTB &= ~P_KDAT;

	flags.key_ack = false;
	flags.key_aa = false;

	key_send = key;
	key_tick = 12;
}

byte WaitKeyAck()
{
	byte i = 200;
	while ( --i != 0 && !flags.key_ack ) delay_ms( 10 );
	return ( flags.key_ack && flags.key_aa );
}

byte ResetKeyboard()
{
	delay_ms( 100 );
	key_tick = 0;
	SendKeyByte( KBD_CMD_RESET );

	byte i = 200;
	while ( --i != 0 && ( !flags.key_ack || !flags.key_aa ) ) delay_ms( 10 );
	return ( flags.key_ack && flags.key_aa );
}

void init_keyboard()
{
	if ( ResetKeyboard() )
	{
		//SendKeyByte( 0xf0 );
		//WaitKeyAck();

		//SendKeyByte( 0x03 );
		//WaitKeyAck();

		//SendKeyByte( 0xf8 );
		//WaitKeyAck();
	}

	ResetKeys();
}

void init_flash()
{
	//if( !flags.flash_ok )
	{
		f_mount( 0, &fatfs );
		//flags.flash_ok = true;
	}
}

//-------------------------------------------------------------------------------------------

ISR( INT1_vect )
{
	if ( flags.tape_precise ) TCCR1B = 0;

	if( ( PIND & P_TRDOS ) != 0 ) flags.betadsk_on = true;
	else flags.betadsk_on = false;

	// чтение, запись порта 1f
	if (( PIND & P_A0 ) != 0 )
	{
		if (( PIND & P_WR ) != 0 && !flags.pport_send )
		{
			// D0-D7 выход
			DDRA = 0xff;
			PORTA = 0x1f & ( ~key_port[8] );
		}
		else flags.pport_wait = true;
	}
	else
	{
		// чтение порта fe
		if ( PINC != last_req )
		{
			tape_port |= 0x1f;
			last_req = PINC;


			if (( last_req | 0xf0 ) != 0xff )
			{
				if (( last_req & 0x01 ) == 0 ) tape_port &= key_port[0];
				if (( last_req & 0x02 ) == 0 ) tape_port &= key_port[1];
				if (( last_req & 0x04 ) == 0 ) tape_port &= key_port[2];
				if (( last_req & 0x08 ) == 0 ) tape_port &= key_port[3];
			}

			if (( last_req | 0x0f ) != 0xff )
			{
				if (( last_req & 0x10 ) == 0 ) tape_port &= key_port[4];
				if (( last_req & 0x20 ) == 0 ) tape_port &= key_port[5];
				if (( last_req & 0x40 ) == 0 ) tape_port &= key_port[6];
				if (( last_req & 0x80 ) == 0 ) tape_port &= key_port[7];
			}
		}

		// D0-D7 выход
		DDRA = 0xff;
		PORTA = tape_port;
	}

	if ( !flags.pport_wait )
	{
		ResumeZ80();
	}

	TCCR1B = ( 1 << CS10 );

	if ( !flags.patchrom_mode )
	{
		PORTD &= ~( P_PROM );
	}
}

//-------------------------------------------------------------------------------------------

ISR( INT0_vect )
{
	byte i = 0x08, kdat = 0;
	while ( i != 0 && ( PIND & P_KCLK ) == 0 ) i--;
	if ( i != 0 ) return;

	kdat = PINB & P_KDAT;

	if ( key_tick == 0 )
	{
		if ( !kdat )
		{
			key_temp = 0;
			key_tick = 1;
			flags.key_parity = 0;
		}
	}
	else if ( key_tick >= 1 && key_tick <= 8 )
	{
		key_temp >>= 1;

		if ( kdat )
		{
			key_temp |= 0x80;
			flags.key_parity++;
		}
		else key_temp &= ~0x80;

		key_tick++;
	}
	else if ( key_tick == 9 )
	{
		if ( !kdat ) flags.key_parity++;
		key_tick++;
	}
	else if ( key_tick == 10 )
	{
		key_tick = 0;

		if ( !flags.key_parity )
		{
			//flags.key_ack = true;
			byte new_buff_put_pos = ( keys_buff_put_pos + 1 ) & ( KEYS_SIZE - 1 );

			if ( key_temp == KBD_REPLY_RESEND ) SendKeyByte( key_send );
			else if ( key_temp == KBD_REPLY_ACK )
			{
				flags.key_ack = true;

#if BETADSK_LEDS
				if ( flags.motor_status_change == true )
				{
					flags.motor_status_change = false;
					SendKeyByte( motor_status );
				}
#endif
			}
			else if ( key_temp == KBD_REPLY_POR ) flags.key_aa = true;
			else if ( new_buff_put_pos != keys_buff_get_pos )
			{
				keys_buff[ keys_buff_put_pos ] = key_temp;
				keys_buff_put_pos = new_buff_put_pos;
			}
		}
		else SendKeyByte( KBD_REPLY_RESEND );
	}
	else if ( key_tick < 12 )
	{
		key_tick++;
	}
	else if ( key_tick < 20 )
	{
		if ( key_tick == 12 )
		{
			key_temp = key_send;
			flags.key_parity = 1;
		}

		if (( key_temp & 1 ) != 0 )
		{
			PORTB |= P_KDAT;
			flags.key_parity++;
		}
		else
		{
			PORTB &= ~P_KDAT;
		}

		key_temp >>= 1;
		key_tick++;
	}
	else if ( key_tick == 20 )
	{
		if ( flags.key_parity ) PORTB |= P_KDAT;
		else PORTB &= ~P_KDAT;

		key_tick++;
	}
	else if ( key_tick == 21 )
	{
		DDRB &= ~P_KDAT;
		PORTB |= P_KDAT;

		key_tick++;
	}
	else if ( key_tick == 22 )
	{
		key_tick = 0;
	}
}

//-------------------------------------------------------------------------------------------

ISR( TIMER0_COMP_vect )
{
	disk_timerproc();	/* Drive timer procedure of low level disk I/O module */
}

byte ParseHeader();
byte GetHeaderSize();

ISR( TIMER1_COMPA_vect )
{
	byte i;

	TCNT1H = 0;
	TCNT1L = 0;

	if ( !flags.tape_on )
	{
		OCR1AH = 0x36;
		OCR1AL = 0xb0;
		return;
	}

	if ( !flags.tape_pause && !( PORTB & P_AVR_WAIT ) )
	{
		PORTD ^= P_TAPE_IN;
		tape_port ^= 0x40;
	}

	TIMSK &= ~( 1 << OCIE1A );
	SREG |= ( 1 << SREG_I );

	while ( buff_pos < buff_size && tape_size < TAPE_SIZE )
	{
		tape[ tape_size++ ] = buff[ buff_pos++ ];
	}

	while ( tape_pilot == 0 && tape_sync == 0 && block_size == 0 && sequence_size == 0 && tape_pause == 0 && skip_size == 0 )
	{
		if ( tape_size > 0 && tape_size >= GetHeaderSize() )
		{
			byte header_size = ParseHeader();
			tape_size -= header_size;
			if ( tape_size ) for ( i = 0; i < tape_size; i++ ) tape[i] = tape[ i + header_size ];
			else WaitOn();
		}
		else
		{
			if ( buff_size != BUFF_SIZE )
			{
				WaitOff();
				flags.tape_on = false;
			}
			else
			{
				WaitOn();
			}

			break;
		}
	}

	if ( skip_size > 0 )
	{
		WaitOn();

		if ( skip_size <= tape_size )
		{
			tape_size -= skip_size;
			if ( tape_size ) for ( i = 0; i < tape_size; i++ ) tape[i] = tape[ i + skip_size ];

			skip_size = 0;
			flags.tape_pause = false;
		}
		else
		{
			skip_size -= tape_size;

			tape_size = 0;
			flags.tape_pause = true;
		}

		if ( buff_pos >= buff_size ) OCR1AH = 0x80;
		else OCR1AH = 0x04;
	}
	else if ( tape_pilot > 0 )
	{
		WaitOff();

		OCR1AH = ( byte )( pulse_pilot >> 8 );
		OCR1AL = ( byte )( pulse_pilot );

		tape_pilot--;
	}
	else if ( tape_sync == 2 )
	{
		WaitOff();

		OCR1AH = ( byte )( pulse_sync1 >> 8 );
		OCR1AL = ( byte )( pulse_sync1 );

		tape_sync--;
	}
	else if ( tape_sync == 1 )
	{
		WaitOff();

		OCR1AH = ( byte )( pulse_sync2 >> 8 );
		OCR1AL = ( byte )( pulse_sync2 );

		tape_sync--;
	}
	else if ( block_size > 0 )
	{
		if ( tape_bit == 0 )
		{
			if ( tape_size > 0 )
			{
				tape_byte = tape[ 0 ];
				tape_bit = 16;

				WaitOff();

				tape_size--;
				if ( tape_size ) for ( i = 0; i < tape_size; i++ ) tape[i] = tape[ i + 1 ];
			}
		}

		if ( tape_bit != 0 )
		{
			if (( tape_byte & 0x80 ) != 0 )
			{
				OCR1AH = ( byte )( pulse_one >> 8 );
				OCR1AL = ( byte )( pulse_one );
			}
			else
			{
				OCR1AH = ( byte )( pulse_zero >> 8 );
				OCR1AL = ( byte )( pulse_zero );
			}

			if ( tape_bit & 1 ) tape_byte <<= 1;
			tape_bit--;

			if ( tape_bit == 0 || ( block_size == 1 && tape_bit == tape_lastbit ) ) block_size--;
		}
		else
		{
			WaitOn();
		}
	}
	else if ( sequence_size > 0 )
	{
		if ( tape_size > 1 )
		{
			WaitOff();
			word next = tape[0] | (( word ) tape[1] << 8 );
			next *= 4;

			tape_size -= 2;
			if ( tape_size ) for ( i = 0; i < tape_size; i++ ) tape[i] = tape[ i + 2 ];

			OCR1AH = ( byte )( next >> 8 );
			OCR1AL = ( byte )( next );

			sequence_size--;
		}
		else
		{
			WaitOn();
		}
	}
	else if ( tape_pause > 0 )
	{
		OCR1AH = 0x36;
		OCR1AL = 0xb0;

		tape_pause--;

		if ( tape_pause == 0 ) flags.tape_pause = false;
		else flags.tape_pause = true;
	}

	if ( PORTB & P_AVR_WAIT )
	{
		OCR1AH = 0x04;
		OCR1AL = 0x00;
	}

	TIMSK |= ( 1 << OCIE1A );
}

//-----------------------------------------------------------------------

byte ReadByte( byte a )
{
	return tape[ a ];
}

word ReadWord( byte a )
{
	return ( word ) tape[ a ] | (( word ) tape[ a + 1] << 8 );
}


dword ReadWord3( byte a )
{
	return ( word ) tape[ a ] | (( word ) tape[ a + 1 ] << 8 ) | (( dword ) tape[ a + 2 ] << 16 );
}

dword ReadDword( byte a )
{
	return ( word ) tape[ a ] | (( word ) tape[ a + 1 ] << 8 ) | (( dword ) tape[ a + 2 ] << 16 ) | (( dword ) tape[ a + 3 ] << 24 );
}

void ResetStandartSpeed()
{
	if ( !flags.tape_turbo )
	{
		pulse_pilot = 2168 * 4;
		pulse_sync1 = 667  * 4;
		pulse_sync2 = 735  * 4;
		pulse_zero  = 855  * 4;
		pulse_one   = 1710 * 4;
	}
	else
	{
		pulse_pilot = 1084 * 4;
		pulse_sync1 = 420  * 4;
		pulse_sync2 = 420  * 4;
		pulse_zero  = 389  * 4;
		pulse_one   = 778  * 4;
	}

	tape_pilot = 6000;
	tape_sync = 2;
}

byte ParseHeader()
{
	tape_bit = 0;
	tape_lastbit = 0;

	if ( !flags.tape_tzx )
	{
		block_size = ReadWord( 0 );
		ResetStandartSpeed();
		tape_pause = 2000;
		return 2;
	}
	else
	{
		switch ( tape[0] )
		{
		case 0x10:
			tape_pause = ReadWord( 1 );
			block_size = ReadWord( 3 );
			ResetStandartSpeed();
			return 5;

		case 0x11:
			pulse_pilot 	= ReadWord( 1 ) << 2;
			pulse_sync1 = ReadWord( 3 ) << 2;
			pulse_sync2 = ReadWord( 5 ) << 2;
			pulse_zero 	= ReadWord( 7 ) << 2;
			pulse_one 	= ReadWord( 9 ) << 2;
			tape_pilot 	= ReadWord( 11 );
			tape_sync = 2;
			tape_lastbit = ( 8 - tape[ 13 ] ) * 2;
			tape_pause = ReadWord( 14 );
			block_size = ReadWord3( 16 );

			if ( pulse_pilot == 1700 * 4 && pulse_sync1 == 450 * 4 )
			{
				pulse_pilot = 1900 * 4;
				pulse_zero = 250 * 4;
				pulse_one = 500 * 4;
			}
			return 19;

		case 0x12:
			pulse_pilot 	= ReadWord( 1 ) * 4;
			tape_pilot 		= ReadWord( 3 );
			return 5;

		case 0x13:
			sequence_size = tape[1];
			return 2;

		case 0x14:
			pulse_zero 	= ReadWord( 1 ) * 4;
			pulse_one 	= ReadWord( 3 ) * 4;
			tape_lastbit = ( 8 - tape[ 5 ] ) * 2;
			tape_pause = ReadWord( 6 );
			block_size = ReadWord3( 8 );
			return 11;

		case 0x15:
			skip_size = ReadWord3( 6 ) * 2;
			return 9;
		case 0x20:
			tape_pause = ReadWord( 1 );
			if ( tape_pause == 0 ) flags.tape_on = false;
			return 3;

		case 0x30:
		case 0x21:
			skip_size = tape[1];
			return 2;
		case 0x22:
			return 1;
		case 0x23:
			return 3;
		case 0x24:
			loop_counter = ReadWord( 1 );
			if ( tape_size - 3 > buff_pos )
			{
				loop_buff_pos = buff_pos + BUFF_SIZE - ( tape_size - 3 );
				loop_file_pos = file_pos - 1;
			}
			else
			{
				loop_buff_pos = buff_pos - ( tape_size - 3 );
				loop_file_pos = file_pos;
			}
			return 3;
		case 0x25:
			if ( --loop_counter == 0 ) return 1;
			else
			{
				flags.tape_loop = true;
				buff_pos = BUFF_SIZE;
				buff_size = BUFF_SIZE;
				return tape_size;
			}
		case 0x31:
			skip_size = tape[2];
			return 3;
		case 0x32:
			skip_size = ReadWord( 1 );
			return 3;
		case 0x33:
			skip_size = tape[1] * 3;
			return 2;
		case 0x34:
			return 9;
		case 0x35:
			skip_size = ReadDword( 0x11 );
			return 0x15;
		case 0x40:
			skip_size = ReadWord3( 9 );
			return 0x0c;

		case 0x5A:
			return 10;
		default:
			skip_size = ReadDword( 1 );
			return 5;
		}
	}
}

byte tzx_header_size[] =
{
	5, 19, 5, 2, 11, 9, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 3, 2, 1, 3, 3, 1, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 2, 3, 3, 2, 9, 0x15,
};

byte GetHeaderSize()
{

	if ( !flags.tape_tzx ) return 2;
	else
	{
		register byte tape_type = tape[0] - 0x10;
		if ( tape_type <= 0x25 )
		{
			return tzx_header_size[tape_type];
		}
		else if ( tape_type == 0x3a )
		{
			return 0xc;
		}
		else if ( tape_type == 0x4a )
		{
			return 10;
		}
		else
		{
			return 5;
		}
	}
}

//-----------------------------------------------------------------------

void PportCmd()
{
	if ( !flags.pport_on && !flags.betadsk_on )
	{
		if ( pport_buff[0] == PP_CTL && pport_buff[1] == PP_CTL_OPEN && pport_buff[2] == 0x00 && pport_buff[3] == 0x00 )
		{
			flags.tape_on = false;
			flags.pport_on = true;

			tape_size = 0;
			block_size = 0;
		}
		else
		{
			pport_buff[0] = pport_buff[1];
			pport_buff[1] = pport_buff[2];
			pport_buff[2] = pport_buff[3];
			pport_buff_pos = 3;
		}
	}
	else
	{
		buff_size = 0;
		buff_pos = 0;

		if ( pport_buff[0] == PP_IN_EXT || pport_buff[0] == PP_OUT_EXT )
		{
			flags.tape_on = false;
			flags.pport_on = true;

			tape_size = 0;
			block_size = 0;
		}
		else
		{
			block_size = pport_buff[2] | (( word ) pport_buff[3] << 8 );
		}

		if (( pport_buff[0] != PP_FCTL && pport_buff[0] != PP_CTL && pport_buff[0] != PP_IN_EXT && pport_buff[0] != PP_OUT_EXT ) || block_size > 0x40 )
		{
			pport_buff[0] = pport_buff[1];
			pport_buff[1] = pport_buff[2];
			pport_buff[2] = pport_buff[3];
			pport_buff_pos = 3;
		}
	}
}

void PportCmdRead()
{
	UINT read_size;

	if ( block_size > BUFF_SIZE ) f_read( &file, buff, BUFF_SIZE, &read_size );
	else f_read( &file, buff, ( word ) block_size, &read_size );

	buff_size = ( byte ) read_size;
	buff_pos = 0;

	if ( buff_size != BUFF_SIZE ) block_size = buff_size;
}

void PportCmdWrite()
{
	FRESULT r = FR_OK;
	UINT write_size;

	r = f_write( &file, buff, buff_size, &write_size );

	buff_size = 0;
	buff_pos = 0;

	if ( buff_size != write_size && pport_buff[1] == FR_OK )
	{
		pport_buff[1] = ( byte ) r;
	}

	if ( block_size == 0 )
	{
		pport_buff_pos = 0;
		flags.pport_send = true;
	}
}

void PportCmdCtl()
{
	switch ( pport_buff[1] )
	{
	case PP_CTL_OPEN:
		break;
	case PP_CTL_CLOSE:
		flags.pport_on = false;
		ResetKeys();
		break;
	case PP_CTL_PROM:
		PORTD |= P_PROM;
		flags.patchrom_mode = true;
		break;
	}
}

FRESULT PportCmdFctl()
{
	FRESULT r = FR_OK;

	switch ( pport_buff[1] )
	{
	case PP_FCTL_DIR:
		buff[ buff_size ] = 0;
		r = f_opendir( &dir, ( char* ) buff );
		break;
	case PP_FCTL_RDIR:
		r = f_readdir( &dir, ( FILINFO* ) buff );

		if ( r == FR_OK ) buff_size = sizeof( FILINFO );
		else buff_size = 0;

		block_size = buff_size;
		break;
	case PP_FCTL_OPEN:
	{
		buff[ buff_size ] = 0;

		r = f_open( &file, ( char* ) buff + 1, buff[0] );
		flags.tape_ready = false;

		char *ext = ( char* ) buff + 1;
		ext += strlen( ext ) - 4;
		strlwr( ext );

		if ( strcmp( ext, ".tap" ) == 0 || strcmp( ext, ".tzx" ) == 0 )
			flags.tape_ready = true;

		if ( r == FR_OK )
		{
			if ( flags.tape_ready )
			{
				sd_write_config( CFG_TAPE_FILENAME, ( char * )buff + 1 );
			}
			memcpy( buff, &file, sizeof( FIL ) );
			buff_size = (byte) sizeof( FIL );
		}
		else
		{
			if ( flags.tape_ready )
			{
				sd_write_config( CFG_TAPE_FILENAME, "" );
			}
			buff_size = 0;
		}

		block_size = buff_size;
		break;
	}
	case PP_FCTL_CLOSE:
		r = f_close( &file );
		flags.tape_ready = false;
		break;
	case PP_FCTL_READ:
		block_size = file.fsize - file.fptr;

		if ( block_size > *( dword* ) buff ) block_size = *( dword* ) buff;
		if ( block_size > 0xffff ) block_size = 0xffff;

		flags.pport_read = true;
		if ( block_size != 0 ) PportCmdRead();
		break;
	case PP_FCTL_WRITE:
		block_size = *( dword* ) buff;
		if ( block_size > 0xffff ) block_size = 0xffff;

		flags.pport_write = true;
		buff_size = 0;

		flags.pport_send = false;
		pport_buff_pos = PP_CMD_SIZE;
		break;
	case PP_FCTL_SEEK:
		r = f_lseek( &file, *( dword* ) buff );
		break;
	case PP_FCTL_FLUSH:
		r = f_sync( &file );
		break;
	case PP_FCTL_RENAME:
		{
			buff[ buff_size ] = 0;
			char *new_name = ( char* ) buff + strlen(( char* ) buff ) + 1;

			r = f_rename(( char* ) buff, new_name );
		}
		break;

	case PP_FCTL_COPY:
		{
			buff[ buff_size ] = 0;
			char *new_name = ( char* ) buff + strlen(( char* ) buff ) + 1;

			r = f_rename(( char* ) buff, new_name );
		}
		break;

	case PP_FCTL_DEL:
		buff[ buff_size ] = 0;
		r = f_unlink(( char* ) buff );
		break;

	case PP_FCTL_FINFO:
	{
		FATFS *fs;
		DWORD clust;

		r = f_getfree( "", &clust, &fs );

		if ( r == FR_OK )
		{
			*( dword* )( buff + 0x00 ) = 512;
			*( dword* )( buff + 0x04 ) = fs->csize;
			*( dword* )( buff + 0x08 ) = clust;
			*( dword* )( buff + 0x0c ) = fs->max_clust;

			buff_size = 0x10;
		}
		else buff_size = 0;

		block_size = buff_size;
		break;
	}

	case PP_FCTL_DSK_OPEN:
	{
		buff[ buff_size ] = 0;

		buff_size = 0;
		byte drv = buff[0] & 3;

		if ( open_dsk_image( drv, ( char * )buff + 1 ) )
		{
			r = FR_NOT_READY;
		}
		else
		{
			sd_write_config( CFG_DRVA_FILENAME + drv, ( char * )buff + 1 );
			beta_set_disk_wp( drv, ( cfg_flags & ( 1 << drv ) ) ? 1 : 0 );
		}
		break;
	}
	case PP_FCTL_DSK_CLOSE:
		close_dsk_image( buff[0] & 3 );
		sd_write_config( CFG_DRVA_FILENAME + ( buff[0]&3 ), "" );
		buff_size = 0;
		break;
	case PP_FCTL_DSK_WP:
		if ( buff[0] < BETADSK_NUM_DRIVES )
		{
			beta_set_disk_wp( buff[0], buff[1] ? 1 : 0 );
			if ( buff[1] )
			{
				cfg_flags |= ( 1 << buff[0] );
			}
			else
			{
				cfg_flags &= ~( 1 << buff[0] );
			}
			sd_write_config( CFG_FLAGS, ( char * )&cfg_flags );
		}
		buff_size = 0;
		break;
	case PP_FCTL_DSK_GET:
	{
		int sz = sd_read_config( CFG_DRVA_FILENAME + ( buff[0] & 3 ), ( char * )buff );
		if ( sz >= 0 )
		{
			buff_size = sz + 1;
		}
		else
		{
			r = sz;
			buff_size = 0;
		}
		block_size = buff_size;
		break;
	}
	case PP_FCTL_TAPE_GET:
	{
		int sz = sd_read_config( CFG_TAPE_FILENAME, ( char * )buff );
		if ( sz >= 0 )
		{
			buff_size = sz;
		}
		else
		{
			r = FR_NOT_READY;
			buff_size = 0;
		}
		block_size = buff_size;
		break;
	}
	case PP_FCTL_CFG_CLEAR:
		sd_new_config();
		buff_size = 0;
		break;
	case PP_FCTL_CFG_GFLAGS:
		block_size = sizeof( cfg_flags );
		buff[0] = cfg_flags & 0xff;
		buff[1] = ( cfg_flags >> 8 ) & 0xff;
		buff_size = block_size;
		break;

	case PP_FCTL_CFG_SFLAGS:
	{
		byte i;
		cfg_flags = (( word )buff[0] ) | ((( word )buff[1] ) << 8 );
		sd_write_config( CFG_FLAGS, ( char * )&cfg_flags );

		for ( i = 0; i < BETADSK_NUM_DRIVES; i++ )
		{
			beta_set_disk_wp( i, ( cfg_flags & ( 1 << i ) ) ? 1 : 0 );
		}

		buff_size = 0;
		break;
	}

	}
	return r;
}

void PportCmdProc()
{
	FRESULT r = FR_OK;
	flags.pport_send = true;
	pport_buff_pos = 0;

	block_size = 0;

	switch ( pport_buff[0] )
	{
	case PP_OUT_EXT:
		if ( flags.betadsk_on )
		{
			beta_write_port( pport_buff[1], pport_buff[3] );
		}
		buff_size = 0;
		buff_pos = 0;
		flags.pport_send = false;
		return;

	case PP_IN_EXT:
		if ( flags.betadsk_on )
		{
			pport_buff[3] = beta_read_port( pport_buff[1] );
			buff_size = PP_CMD_SIZE;
			buff_pos = 0;
		}
		else
		{
			buff_size = 0;
			buff_pos = 0;
			flags.pport_send = false;
		}
		return;

	case PP_CTL:
		PportCmdCtl();
		break;
	case PP_FCTL:
		r = PportCmdFctl();
		break;
	}


	buff_pos = 0;

	pport_buff[0] = PP_ACK;
	pport_buff[1] = ( byte ) r;
	pport_buff[2] = block_size & 0xff;
	pport_buff[3] = block_size >> 8;
}

//-----------------------------------------------------------------------

void PrepareSnapName( )
{
	FILINFO info;
	byte i = 0;

	if ( f_opendir( &dir, "/" ) != FR_OK ) return;

	while ( true )
	{
		byte j;

		if ( f_readdir( &dir, &info ) != FR_OK ) break;
		if ( info.fname[0] == 0 ) break;

		strlwr( info.fname );

		if ( info.fname[0] != 's' || info.fname[1] != 'n' || info.fname[2] != 'a' || info.fname[3] != 'p' )
			continue;

		if ( info.fname[6] != '.' || info.fname[7] != 's' || info.fname[8] != 'n' || info.fname[9] != 'a' )
			continue;

//		if( info.fname[10] != 0 )
//			continue;

		if ( info.fname[4] >= '0' && info.fname[4] <= '9' ) j = info.fname[4] - '0';
		else continue;
//        if ((info.fname[4] & 0xf0) == 0x30) j = info.fname[4] - '0';
//		else continue;

		j *= 10;

		if ( info.fname[5] >= '0' && info.fname[5] <= '9' ) j += info.fname[5] - '0';
		else continue;

//		if ((info.fname[5] & 0xf0) == 0x30) j += info.fname[5] - '0';
//		else continue;

		//j *= 10;
		//if( info.fname[6] >= '0' && info.fname[6] <= '9' ) j += info.fname[6] - '0';
		//else continue;

		//j *= 10;
		//if( info.fname[7] >= '0' && info.fname[7] <= '9' ) j += info.fname[7] - '0';
		//else continue;

		if ( j > i ) i = j;
	}

	i++;
	if ( i > 99 ) i = 99;

	//new_name[7] += i % 10; i /= 10;
	//new_name[6] += i % 10; i /= 10;
	new_snap_name[5] = ( i % 10 ) + '0';
	new_snap_name[4] = ( i / 10 ) + '0';
}

void ResetZ80()
{
	PORTB &= ~P_Z80_RST; 		//reset - low

	flags.tape_on = false;

	pport_buff_pos = 0;
	flags.pport_on = false;
	flags.pport_send = false;
	flags.pport_read = false;
	flags.pport_write = false;

	flags.patchrom_mode = false;
	PORTD &= ~P_PROM;

	int i;
	beta_dsk_init();
	for ( i = 0; i < BETADSK_NUM_DRIVES; i++ )
	{
		beta_init_drive( i );
	}
}

void DecodeKey( byte key_temp )
{
	if ( key_temp == 0xf0 )
	{
		flags.key_release = true;

	}
	else if ( key_temp == 0xe0 || key_temp == 0xe1 ) flags.key_ext = true;
	else
	{
		if ( !flags.key_release )
		{
			if ( key_temp == 0x14 && !flags.key_ext )
			{
				flags.key_ctrl = true;
			}
			if ( key_temp == 0x11 && !flags.key_ext )
			{
				flags.key_alt = true;
			}

#if ALT_KEY_SET
			if ( flags.key_alt && flags.key_ctrl && key_temp == 0x71 )
			{
				ResetZ80();
				PORTB |= P_Z80_RST;
			}
#endif

			if ( !flags.pport_on )
			{
				if ( !flags.tape_on )
				{
#if ALT_KEY_SET
					if ( ( !flags.key_ext && ( key_temp == 0x55 ) ) || ( flags.key_ext && key_temp == 0x38 ) )
#else
					if ( ( !flags.key_ext && ( key_temp == 0x79 || key_temp == 0x55 ) ) )
#endif

					{
						flags.tape_turbo = false;
						flags.tape_start = true;
					}

#if ALT_KEY_SET
					else if ( ( flags.key_ext && ( key_temp == 0x30 ) ) || ( !flags.key_ext && key_temp == 0x5d ) )
#else
					else if ( ( flags.key_ext && ( key_temp == 0x5a ) ) || ( !flags.key_ext && key_temp == 0x5d ) )
#endif
					{
						flags.tape_turbo = true;
						flags.tape_start = true;
					}
				}

#if ALT_KEY_SET
				if ( ( !flags.key_ext && ( key_temp == 0x4e ) ) || ( flags.key_ext && key_temp == 0x20 ) )
#else
				if ( ( !flags.key_ext && ( key_temp == 0x7b || key_temp == 0x4e ) ) )
#endif
				{
					flags.tape_on = !flags.tape_on;
				}
			}

			if ( key_temp == 0x83 )
			{
				beta_dump_state();
			}

			if ( key_temp == 0x09 && !flags.key_ext )
			{
				//F10
				ResetZ80();
				PORTB |= P_Z80_RST;

				f_open( &file, "trdos.sna", FA_OPEN_EXISTING | FA_READ );

				flags.patchrom_mode = true;
				PORTD |= P_PROM;

				PORTB &= ~P_Z80_NMI;
				PORTB |= P_Z80_NMI;
			}

			if ( key_temp == 0x0a && !flags.key_ext )
			{
				//F9
				//volatile byte i;
				PORTB &= ~P_Z80_NMI;
				//for( i = 0; i < 16; i++ );
				PORTB |= P_Z80_NMI;
			}

			if ( key_temp == 0x05 )
			{
				flags.tape_precise = true;
			}

			if ( key_temp == 0x06 )
			{
				flags.tape_precise = false;
			}

			if ( key_temp == 0x04 )
			{
				flags.nowait_mode = true;
			}
			if ( key_temp == 0x0c )
			{
				flags.nowait_mode = false;
			}
			if ( key_temp == 0x03 )
			{
				flags.sinclair_mode = true;
			}
			if ( key_temp == 0x0b )
			{
				flags.sinclair_mode = false;
			}

			if ( flags.tape_on == false && ( key_temp == 0x77 || key_temp == 0x01 ) )
			{
				flags.pause_mode = ~flags.pause_mode;

				if ( flags.pause_mode ) WaitOn();
				else WaitOff();

			}

#if ALT_KEY_SET
			if ( key_temp == 0x37 )
			{
				ResetZ80();
				PORTB |= P_Z80_RST;
			}
			
			if ( flags.key_ext && key_temp == 0x12 )   // switch rom (PRT SCRN)
			{
				//SwitchROM();
			}
#endif

			if ( key_temp == 0x07 )
			{
				ResetZ80();
				PORTB |= P_Z80_RST;

				f_open( &file, "boot.sna", FA_OPEN_EXISTING | FA_READ );

				flags.patchrom_mode = true;
				PORTD |= P_PROM;

				PORTB &= ~P_Z80_NMI;
				PORTB |= P_Z80_NMI;
			}
			else if ( key_temp == 0x78 && flags.pport_on == false && flags.patchrom_mode == false )
			{
				PrepareSnapName();

				f_open( &file, new_snap_name, FA_CREATE_ALWAYS | FA_WRITE );

				flags.patchrom_mode = true;
				PORTD |= P_PROM;

				PORTB &= ~P_Z80_NMI;
				PORTB |= P_Z80_NMI;
			}
		}

#if ALT_KEY_SET
		else
		{
			if ( key_temp == 0x14 && !flags.key_ext )
			{
				flags.key_ctrl = false;
			}
			if ( key_temp == 0x11 && !flags.key_ext )
			{
				flags.key_alt = false;
			}
		}
#endif

		byte matrix_pos;

		if ( flags.sinclair_mode ) matrix_pos = 5;
		else matrix_pos = 0;

		for ( ; ; matrix_pos++ )
		{
			byte e, b, p, x;
			e = pgm_read_byte( &key_matrix[matrix_pos][0] );
			b = pgm_read_byte( &key_matrix[matrix_pos][1] );

			if ( b == 0 ) break;
			if ( b != key_temp || e != flags.key_ext ) continue;

			if ( !flags.key_release )
			{
				p = pgm_read_byte( &key_matrix[matrix_pos][2] );
				x = pgm_read_byte( &key_matrix[matrix_pos][3] );
			}
			else
			{
				p = pgm_read_byte( &key_matrix[matrix_pos][4] );
				x = pgm_read_byte( &key_matrix[matrix_pos][5] );
			}

			if ( p != 0xff )
			{
				if ( flags.key_release ) key_port[p] |= x;
				else key_port[p] &= ~x;
			}

			if ( flags.key_release )
			{
				p = pgm_read_byte( &key_matrix[matrix_pos][2] );
				x = pgm_read_byte( &key_matrix[matrix_pos][3] );
			}
			else
			{
				p = pgm_read_byte( &key_matrix[matrix_pos][4] );
				x = pgm_read_byte( &key_matrix[matrix_pos][5] );
			}

			if ( p != 0xff )
			{
				delay_ms( 2 );

				if ( flags.key_release ) key_port[p] |= x;
				else key_port[p] &= ~x;
			}

			break;
		}

		if (( key_port[8] & 0x70 ) == 0x40 )
		{
			ResetZ80();
		}
		else if (( key_port[8] & 0x70 ) == 0x20 )
		{
			//SwitchROM();
		}
		else PORTB |= P_Z80_RST; 	//reset - high

		last_req = 0xff;
		flags.key_release = false;
		flags.key_ext = false;
	}
}

//-----------------------------------------------------------------------

void KeysRoutine()
{
	if ( keys_buff_put_pos != keys_buff_get_pos )
	{
		DecodeKey( keys_buff[keys_buff_get_pos] );

		SREG &= ~( 1 << SREG_I );
		keys_buff_get_pos = ( keys_buff_get_pos + 1 ) & ( KEYS_SIZE - 1 );
		SREG |= ( 1 << SREG_I );
	}

	if ( flags.nowait_mode && flags.tape_on == false &&
			( key_port[0] & key_port[1] & key_port[2] & key_port[3] &
			  key_port[4] & key_port[5] & key_port[6] & key_port[7] &
			  key_port[8] ) == 0xff ) KbdIntDisable();
	else KbdIntEnable();

}

void PportRoutine()
{
	if ( flags.pport_wait )
	{
		if (( PIND & P_WR ) == 0 )
		{
			if ( flags.pport_send )
			{
				pport_buff_pos = 0;
				flags.pport_send = false;
				flags.pport_read = false;
				flags.pport_write = false;
			}

			if ( pport_buff_pos < PP_CMD_SIZE )
			{
				pport_buff[ pport_buff_pos++ ] = PINA;
				if ( pport_buff_pos == PP_CMD_SIZE ) PportCmd();
			}
			else if ( flags.pport_on && block_size > 0 )
			{
				buff[ buff_size++ ] = PINA;
				block_size--;
			}

			if ( flags.pport_on && pport_buff_pos == PP_CMD_SIZE )
			{
				if ( block_size == 0 && !flags.pport_read && !flags.pport_write ) PportCmdProc();
				else if ( buff_size == BUFF_SIZE || block_size == 0 )
				{
					if ( flags.pport_write ) PportCmdWrite();
					else buff_size = 0;
				}
			}
		}
		else
		{
			DDRA = 0xff;

			if ( pport_buff_pos < PP_CMD_SIZE )
			{
				PORTA = pport_buff[ pport_buff_pos++ ];
			}
			else
			{
				if ( block_size != 0 )
				{
					PORTA = buff[ buff_pos++ ];
					block_size--;
				}

				if ( buff_pos == buff_size && block_size > 0 )
				{
					if ( flags.pport_read ) PportCmdRead();
					else buff_pos = 0;
				}
			}

			if ( pport_buff_pos == PP_CMD_SIZE && block_size == 0 )
			{
				pport_buff_pos = 0;

				flags.pport_send = false;
				flags.pport_read = false;
				flags.pport_write = false;

				if ( !flags.pport_on ) flags.patchrom_mode = false;
			}
		}

		flags.pport_wait = false;
		ResumeZ80();
	}
}

void TapeRoutine()
{
	UINT read_size;

	if ( flags.tape_start )
	{
		if ( !flags.tape_ready || f_lseek( &file, 0 ) != FR_OK )
		{
			init_flash();
			f_open( &file, "boot.tap", FA_OPEN_EXISTING | FA_READ );
		}

		if ( f_lseek( &file, 0 ) != FR_OK )
		{
			flags.tape_start = false;
			return;
		}

		flags.tape_start = false;
		flags.tape_pause = false;
		flags.tape_loop = false;

		file_pos = 0;
		buff_pos = 0;

		tape_size = 0;
		tape_pilot = 0;
		tape_sync  = 0;
		tape_pause = 0;

		block_size = 0;
		sequence_size = 0;
		skip_size = 0;

		f_read( &file, buff, BUFF_SIZE, &read_size );
		buff_size = ( byte ) read_size;

		if ( buff_size > 10 && buff[0] == 'Z' && buff[1] == 'X' && buff[2] == 'T' )
		{
			buff_pos += 10;
			flags.tape_tzx = true;
		}
		else flags.tape_tzx = false;

		flags.tape_on = true;
	}

	if ( flags.tape_on && buff_pos == BUFF_SIZE )
	{
		if ( flags.tape_loop )
		{
			f_lseek( &file, ( dword ) loop_file_pos * BUFF_SIZE );
		}

		f_read( &file, buff, BUFF_SIZE, &read_size );

		SREG &= ~( 1 << SREG_I );
		buff_size = ( byte ) read_size;

		if ( flags.tape_loop )
		{
			file_pos = loop_file_pos;
			buff_pos = loop_buff_pos;
			flags.tape_loop = false;
		}
		else
		{
			file_pos++;
			buff_pos = 0;
		}

		SREG |= ( 1 << SREG_I );
	}
}


int main( void )
{
	char filename[FILENAME_EEPROM_SIZE+1];
	byte i;

#if BETADSK_LEDS
	byte beta_state;
	flags.set_leds = false;
#endif

	flags.pport_on = false;
	flags.key_alt = false;
	flags.key_ctrl = false;

	flags.tape_on = false;
	flags.tape_start = false;
	flags.tape_precise = false;
	flags.tape_ready = false;

	flags.betadsk_on = false;

	flags.nowait_mode = true;
	flags.sinclair_mode = false;
	flags.patchrom_mode = false;

	init_ports();
	init_inerrupts();
	init_counters();

	SREG |= ( 1 << SREG_I );
	delay_ms( 500 );

	init_flash();

	delay_ms( 500 );

	init_keyboard();

	if ( !sd_check_config() )
	{
		sd_new_config();
	}

	if ( sd_read_config( CFG_FLAGS, ( char * )&cfg_flags ) <= 0 )
	{
		cfg_flags = 0;
	}

	if ( sd_read_config( CFG_TAPE_FILENAME, filename ) > 0 )
	{
		FRESULT r = f_open( &file, filename, FA_READ | FA_OPEN_EXISTING );
		if ( r == FR_OK )
		{
			flags.tape_ready = true;
		}
	}

	beta_init();

	for ( i = 0; i < BETADSK_NUM_DRIVES; i++ )
	{
		if ( sd_read_config( CFG_DRVA_FILENAME + i, filename ) > 0 )
		{
			open_dsk_image( i, filename );
		}
		if (( cfg_flags & ( CFG_FLG_DRVA_WP << i ) ) != 0 )
		{
			beta_set_disk_wp( i, 1 );
		}
	}


	PORTB |= P_Z80_RST; 						//reset - high

	while ( true )
	{
		KeysRoutine();
		PportRoutine();
		TapeRoutine();

		beta_routine();

#if BETADSK_LEDS
		beta_state = beta_get_state();

		if ( beta_state == BETA_WRITE || beta_state == BETA_WRITE_TRK )
		{
			motor_new_status |= 4;
		}
		else
		{
			motor_new_status &= ~4;
		}

		if ( beta_state == BETA_READ || beta_state == BETA_READ_TRK || beta_state == BETA_READ_ADR || beta_state == BETA_SEEK )
		{
			motor_new_status |= 1;
		}
		else
		{
			motor_new_status &= ~1;
		}

		if ( motor_new_status != motor_status )
		{
			motor_status = motor_new_status;
			flags.motor_status_change = 1;
			SREG &= ~( 1 << SREG_I );
			if ( key_tick == 0 )
			{
				SendKeyByte( KBD_CMD_SET_LEDS );
			}
			else
			{
				flags.set_leds = 1;
			}
			SREG |= ( 1 << SREG_I );
		}
		if ( flags.set_leds )
		{
			SREG &= ~( 1 << SREG_I );
			if ( key_tick == 0 )
			{
				SendKeyByte( KBD_CMD_SET_LEDS );
				flags.set_leds = 0;
			}
			SREG |= ( 1 << SREG_I );
		}
#endif
	}

	return 0;
}




