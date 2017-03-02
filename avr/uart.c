#include <avr/io.h>
#include <avr/interrupt.h>

#include "uart.h"
#include "avr_compat.h"
#include "timeout.h"
#include "types.h"

void uart_init( void )
{
	unsigned int baud = 22; //38400
	//unsigned int baud = 181; 	//4800

	UBRRH = ( unsigned char )( baud >> 8 );
	UBRRL = ( unsigned char )( baud );

	UCSRA = 0;
	UCSRC = ( 1 << URSEL ) | ( 3 << UCSZ0 );

	UCSRB = ( 1 << RXEN ) | ( 1 << TXEN );
	//UCSRB |= ( 1 << RXCIE ) | ( 1 << TXCIE );
}

/* send one character to the rs232 */
void uart_sendchar( char c )
{
	/* wait for empty transmit buffer */
	while ( !( UCSRA & ( 1 << UDRE ) ) )
		;
	UDR = c;
}

void uart_senddig( char c )
{
	if ( c < 10 ) uart_sendchar( '0' + c );
	else  uart_sendchar( 'a' + c - 10 );
}

/* send string to the rs232 */
void uart_sendstr( char *s )
{
	while ( *s )
	{
		uart_sendchar( *s );
		s++;
	}
}

void uart_sendstr_p( const prog_char *progmem_s )
/* print string from program memory on rs232 */
{
	char c;
	while (( c = pgm_read_byte( progmem_s++ ) ) )
	{
		uart_sendchar( c );
	}

}

/* get a byte from rs232
* this function does a blocking read */
unsigned char uart_getchar( unsigned char kickwd )
{
	while ( !( UCSRA & ( 1 << RXC ) ) )
	{
		// we can not aford a watchdog timeout
		// because this is a blocking function
		if ( kickwd )
		{
			wd_kick();
		}
	}
	return ( UDR );
}

/* read and discard any data in the receive buffer */
void uart_flushRXbuf( void )
{
	unsigned char tmp;
	while ( UCSRA & ( 1 << RXC ) )
	{
		tmp = UDR;
	}
}

void uart_send_word( word i )
{
	char str[ 10 ];
	byte p;

	for ( p = 0; p < 10 && i != 0 ; p++ )
	{
		str[ p ] = i % 10;
		i = i / 10;
	}

	if ( p == 0 ) str[ p++ ] = 0;

	do
	{
		uart_senddig( str[ --p ] );
	}
	while ( p > 0 );
}

void uart_send_byte( byte i )
{
	uart_sendstr_P( "0x" );
	uart_senddig( i / 0x10 );
	uart_senddig( i % 0x10 );
}

