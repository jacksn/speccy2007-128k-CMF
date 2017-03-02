#include<string.h>
#include "main.h"
#include "pport.h"
#include "txtcore.h"

#define SCR_START_ADDR 0x4000
#define SCR_START   ((void*) SCR_START_ADDR)
#define SCR_SIZE    (0x1b00)
#define SCR_PIX_SIZE 0x1800
#define SCR_ATR_SIZE 0x300

#define FILES_PER_ROW 16

__sfr __at( 0x1f ) PPORT;
__sfr __banked __at( 0x00fe ) KPORT;

__sfr __banked __at( 0xfefe ) KPORT0;
__sfr __banked __at( 0xfdfe ) KPORT1;
__sfr __banked __at( 0xfbfe ) KPORT2;
__sfr __banked __at( 0xf7fe ) KPORT3;
__sfr __banked __at( 0xeffe ) KPORT4;
__sfr __banked __at( 0xdffe ) KPORT5;
__sfr __banked __at( 0xbffe ) KPORT6;
__sfr __banked __at( 0x7ffe ) KPORT7;

__sfr __banked __at( 0x7ffd ) MEMPORT;

#define FILES_SIZE 0x400
struct FRECORD files[FILES_SIZE];
int files_size;
int files_table_start;
int files_sel;
byte selx = 1, sely = 3;

#define CMD_SIZE 0x18
byte cmd[CMD_SIZE+1];
byte cmd_pos;

#define PATH_SIZE 0x40
byte path[PATH_SIZE+1];

word pport_result;
word pport_datasize, pport_pktsize;
byte pport_good = 0;

byte save_scr_buff[SCR_SIZE];

byte code_table[ 0x80 ] = { 0, 'a', 'q', '1', '0', 'p', 0x0d, ' ',
							'z', 's', 'w', '2', '9', 'o', 'l', 0,
							'x', 'd', 'e', '3', '8', 'i', 'k', 'm',
							'c', 'f', 'r', '4', '7', 'u', 'j', 'n',
							'v', 'g', 't', '5', '6', 'y', 'h', 'b',

							0, 0, 0, 0, 0, 0, 0, 0,
							0, 0, 0, 0, 0, 0, 0, 0,
							0, 0, 0, 0, 0, 0, 0, 0,

							0, 'A', 'Q', 0, 0x0c, 'P', 0x0d, ' ',
							'Z', 'S', 'W', 0, 0x87, 'O', 'L', 0,
							'X', 'D', 'E', 0, 0x09, 'I', 'K', 'M',
							'C', 'F', 'R', 0, 0x0b, 'U', 'J', 'N',
							'V', 'G', 'T', 0x08, 0x0a, 'Y', 'H', 'B'
						  };

byte getcode( byte a, byte b )
{
	if ( b & 0x01 ) return 0x80 | ( 0 << 3 ) | a;
	if ( b & 0x02 ) return 0x80 | ( 1 << 3 ) | a;
	if ( b & 0x04 ) return 0x80 | ( 2 << 3 ) | a;
	if ( b & 0x08 ) return 0x80 | ( 3 << 3 ) | a;
	if ( b & 0x10 ) return 0x80 | ( 4 << 3 ) | a;

	return 0;
}

byte sound_bit = 0;

byte readkey()
{
	byte kcode, kdata, k_SS, k_CS;

	kdata = PPORT;
#if 1
	if ( kdata & 0x01 ) return 0x09;
	if ( kdata & 0x02 ) return 0x08;
	if ( kdata & 0x04 ) return 0x0a;
	if ( kdata & 0x08 ) return 0x0b;
	if ( kdata & 0x10 ) return 0x0d;
#endif
	kdata = ~KPORT0;
	k_CS = kdata & 1;
	kdata &= ~1;
	kcode = getcode( 0, kdata );

	kdata = ~KPORT7;
	k_SS = kdata & 2;
	kdata &= ~2;
	if ( !kcode ) kcode = getcode( 7, kdata );

	if ( !kcode ) kcode = getcode( 1, ~KPORT1 );
	if ( !kcode ) kcode = getcode( 2, ~KPORT2 );
	if ( !kcode ) kcode = getcode( 3, ~KPORT3 );
	if ( !kcode ) kcode = getcode( 4, ~KPORT4 );
	if ( !kcode ) kcode = getcode( 5, ~KPORT5 );
	if ( !kcode ) kcode = getcode( 6, ~KPORT6 );

	if ( kcode )
	{
		if ( k_CS ) kcode |= 0x40;
		kcode = code_table[ kcode & 0x7f ];

		if ( k_SS )
		{
			if ( k_CS ) return 0x87;
			else if ( kcode == 'm' ) return '.';
			else if ( kcode == 'v' ) return '/';

			else if ( kcode == 'a' ) return 0x81;
			else if ( kcode == 'b' ) return 0x82;
			else if ( kcode == 'c' ) return 0x83;
			else if ( kcode == 'd' ) return 0x84;

			else if ( kcode == 'u' ) return 0x85;
			else if ( kcode == 'r' ) return 0x86;
			else return 0;
		}
		else return kcode;
	}
	else return 0;
}

byte key_last = 0;
byte key_pushed = 0;

byte getkey()
{
	word i;

	if ( key_pushed ) i = 5000;
	else i = 10000;

	while ( i != 0 )
	{
		if (( PPORT & 0x1f ) == 0 && ( KPORT & 0x1f ) == 0x1f )
		{
			key_last = 0;
			break;
		}
		i--;
	}

	while ( true )
	{
		byte kdata = readkey();

		i = 2;
		while ( kdata != 0 && i != 0 )
		{
			if ( kdata != readkey() ) break;

			i--;
		}

		if ( kdata && i == 0 )
		{
			byte i, j;

			for ( i = 0; i < 20; i++ )
			{
				for ( j = 0; j < 2; j++ );

				sound_bit ^= 0x10;
				KPORT = sound_bit;
			}
			if ( kdata == key_last ) key_pushed = true;
			else key_pushed = false;

			key_last = kdata;
			return kdata;
		}
		else key_last = 0;
	}
}

void halt()
{
	__asm
	ld bc, #0x7ffd
	xor a
	out (c), a
	rst #0
loop:
	jr loop
	__endasm;
}

void putdig( byte b, byte col, byte row )
{
	char d[2] = "0";
	if ( b < 0x0a ) d[0] = b + '0';
	else if ( b < 0x10 ) d[0] =  'a' + b - 0x0a;
	else d[0] = '?';
	text_out_pos_8( d, col, row, 0, 0xff );
}

void putbyte( byte b, byte col, byte row )
{
	putdig( b >> 4, col, row );
	putdig( b & 0x0f, col + 1, row );
	text_out_pos_8( " ", col + 2, row, 0, 0xff );
}



//--------------------------------------------------------------------------

void strlwr( byte *name )
{
	while ( *name != 0 )
	{
		if ( *name >= 'A' && *name <= 'Z' ) *name += 'a' - 'A';
		name++;
	}
}

void strupr( byte *name )
{
	while ( *name != 0 )
	{
		if ( *name >= 'a' && *name <= 'z' ) *name += 'A' - 'a';
		name++;
	}
}
//--------------------------------------------------------------------------

void pport_send( word cmd, word size, void *buff )
{
	byte *buff_b = ( byte* ) buff;

	PPORT = cmd >> 8;
	PPORT = ( byte ) cmd;
	PPORT = ( byte ) size;
	PPORT = size >> 8;

	while ( size-- != 0 ) PPORT = *buff_b++;
}

void pport_send_data( void *buff, word size )
{
	byte *buff_b = ( byte* ) buff;
	while ( size-- != 0 ) PPORT = *buff_b++;
}

void pport_receive( void *buff, word size )
{
	byte *buff_b = ( byte* ) buff;

	pport_result = PPORT << 8;
	pport_result |= PPORT;

	pport_datasize = PPORT;
	pport_datasize |= PPORT << 8;

	pport_pktsize = pport_datasize;

	if (( pport_result >> 8 ) == PP_ACK )
	{
		while ( pport_datasize-- != 0 )
		{
			byte c = PPORT;
			if ( buff != 0 && size > 0 )
			{
			    *buff_b++ = c;
			    size--;
			}
		}
	}
}

void pport_open()
{
	pport_send( PP_CMD_CTL( PP_CTL_OPEN ), 0, 0 );
	pport_receive( 0, 0 );

	pport_good = ( pport_result == PP_W_ACK );
}

void pport_close()
{
	pport_send( PP_CMD_CTL( PP_CTL_CLOSE ), 0, 0 );
	pport_receive( 0, 0 );
}

//--------------------------------------------------------------------------

void print_pad_8( char *str, byte col, byte row, byte sz )
{
	byte i;
	byte real_sz = strlen( str );
	text_out_pos_8( str, col, row, 0, sz );
	if ( real_sz < sz )
	{
		for ( i = real_sz; i < sz; i++ )
		{
			text_out_pos_8( " ", col + i, row, 0, 1 );
		}
	}
}

void display_path( char *str, int col, int row, int max_sz )
{
	byte path_buff[0x20] = "/";
	byte *path_short = str;

	if ( strlen( str ) > max_sz )
	{
		while ( strlen( path_short ) > ( max_sz - 2 ) )
		{
			path_short++;
			while ( *path_short != '/' ) path_short++;
		}

		strcpy( path_buff, "..." );
	}

	strcat( path_buff, path_short );
	print_pad_8( path_buff, col, row, max_sz );
}


void show_table()
{
	byte i;
	text_out_pos_8( "> ", 0, 1, 0, 0xff );
	display_path( path, 1, 1, 28 );
	for ( i = 0; i < FILES_PER_ROW*2; i++ )
	{
		int col = ( i / FILES_PER_ROW ) * 16 + 2;
		int row = ( i % FILES_PER_ROW ) + 3;
		int pos = i + files_table_start;

		if ( pos < files_size )
		{
			byte len;

			for ( len = 0; files[pos].name[len] && files[pos].name[len] != '.'; len++ );
			if ( files[pos].name[len] && files[pos].name[0] != '.' )
			{
				char fn[9];
				byte fnlen = len > 8 ? 8 : len;
				memcpy( fn, files[pos].name, fnlen );
				fn[fnlen] = 0;
				print_pad_8( fn, col, row, 8 );
				print_pad_8( files[pos].name + len, col + 8, row, 4 );
			}
			else
			{
				print_pad_8( files[pos].name, col, row, 8 );
				print_pad_8( "", col + 8, row, 4 );
			}
		}
		else
		{
			print_pad_8( "", col, row, 12 );
		}
	}
	if ( !files_size )
	{
		if ( !pport_good )
		{
			text_out_pos_8( "SD error !", 10, 4, 0, 0xff );
			set_attr( 0302, 10, 4, 10 );
		}
		else
		{
			text_out_pos_8( "no files !", 10, 4, 0, 0xff );
			set_attr( 0102, 10, 4, 10 );
		}
	}
}

//--------------------------------------------------------------------------

byte comp_name( int a, int b )
{
	if (( files[a].attr & AM_DIR ) && !( files[b].attr & AM_DIR ) ) return true;
	else if ( !( files[a].attr & AM_DIR ) && ( files[b].attr & AM_DIR ) ) return false;
	else return strcmp( files[a].name, files[b].name ) <= 0;
}

void swap_name( int a, int b )
{
	struct FRECORD temp;

	memcpy( &temp, &files[a], sizeof( struct FRECORD ) );
	memcpy( &files[a], &files[b], sizeof( struct FRECORD ) );
	memcpy( &files[b], &temp,  sizeof( struct FRECORD ) );
}

void qsort( int l, int h )
{
	int i = l;
	int j = h;

	int k = ( l + h ) / 2;

	while ( true )
	{
		while ( i < k && comp_name( i, k ) ) i++;
		while ( j > k && comp_name( k, j ) ) j--;

		if ( i == j ) break;
		swap_name( i, j );

		if ( i == k ) k = j;
		else if ( j == k ) k = i;
	}

	if ( l < k - 1 ) qsort( l, k - 1 );
	if ( k + 1 < h ) qsort( k + 1, h );
}

void read_dir()
{
	files_size = 0;
	files_table_start = 0;
	files_sel = 0;

	if ( pport_good )
	{
	    if( strlen( path ) == 0 )
	    {
	        pport_send( PP_CMD_FCTL( PP_FCTL_DIR ), strlen( path ), path );
            pport_receive( 0, 0 );
	    }
	    else
	    {
	        pport_send( PP_CMD_FCTL( PP_FCTL_DIR ), strlen( path ) - 1, path );
            pport_receive( 0, 0 );

			files[ files_size ].attr = AM_DIR;
			strcpy( files[ files_size ].name, ".." );
			files_size++;
	    }

		while ( true )
		{
			struct FILINFO fi;

			pport_send( PP_CMD_FCTL( PP_FCTL_RDIR ), 0, 0 );
			pport_receive( &fi, sizeof( fi ) );

			if ( files_size == FILES_SIZE ) break;
			if ( pport_result != PP_W_ACK ) break;
			if ( fi.fname[0] == 0 ) break;
			if ( fi.fattrib & ( AM_HID | AM_SYS ) ) continue;

			files[ files_size ].attr = fi.fattrib;
			if ( fi.fattrib & ( AM_DIR ) ) strupr( fi.fname );
			else strlwr( fi.fname );
			strcpy( files[ files_size ].name, fi.fname );

			files_size++;
		}
	}
	else
	{
		files_size = 0;
	}

	if ( files_size )
	{
		qsort( 0, files_size - 1 );
	}
}

//--------------------------------------------------------------------------

void clrscr()
{
	__asm
	di
	ld hl, #SCR_START_ADDR
	push hl
	pop de
	inc de
	xor a
	ld( hl ), a
	ld bc, #SCR_PIX_SIZE
	ldir
	inc hl
	inc de
	ld a, #7
	ld( hl ), a
	ld bc, #SCR_ATR_SIZE
	ldir
	xor a
	out( 0xfe ), a
	__endasm;
}

//--------------------------------------------------------------------------

#define WN_W 176
#define WN_8 (WN_W / 8)

int yes_or_no( char *prompt )
{
	byte i, top = 7;
	int res;

	byte sz = strlen( prompt );
	if ( sz & 1 ) sz += 1;
	if ( sz < 18 ) sz = 18;
	sz += 4;

	for ( i = 0; i < 6; i++ )
	{
		set_attr( 050, ( 32 - sz ) / 2, top + i, sz );
		print_pad_8( "", ( 32 - sz ) / 2, top + i, sz );
	}
//  set_attr(0417, (32 - WN_8) / 2 + 1, top+4, WN_8-2);
	text_out_pos_8( "-= Confirmation =-", 7, top, 0, 0xff );
	text_out_pos_8( prompt, ( 32 - strlen( prompt ) ) / 2, top + 2, 0, 0xff );
	set_attr( 052, ( 32 - strlen( prompt ) ) / 2, top + 2, strlen( prompt ) );

	text_out_pos_8( "Yes", 10, top + 4, 0, 0xff );
	set_attr( 017, 9, top + 4, 5 );
	text_out_pos_8( "No", 20, top + 4, 0, 0xff );

	res = 1;

	while ( 1 )
	{
		int new_res = res;
		byte key = getkey();
		if ( key == 9 || key == 8 )
		{
			res = !res;
		}
		else if ( key == 'y' )
		{
			res = 1;
			break;
		}
		else if ( key == 'n' )
		{
			res = 0;
			break;
		}
		else if ( key == 0xd )
		{
			break;
		}
		if ( new_res != res )
		{
			if ( res )
			{
				set_attr( 017, 9, top + 4, 5 );
				set_attr( 050, 19, top + 4, 4 );
			}
			else
			{
				set_attr( 050, 9, top + 4, 5 );
				set_attr( 017, 19, top + 4, 4 );
			}
		}
	}
	for ( i = 0; i < 6; i++ )
	{
		print_pad_8( "", ( 32 - sz ) / 2, top + i, sz );
		set_attr( 007, ( 32 - sz ) / 2, top + i, sz );
	}
	return res;
}

int input_box( char *head, char *prompt, char *str, int max_sz )
{
	byte i, top = 7;
	byte curs, start, sz;
	int result;

	for ( i = 0; i < 6; i++ )
	{
		set_attr( 050, ( 32 - WN_8 ) / 2, top + i, WN_8 );
		print_pad_8( "", ( 32 - WN_8 ) / 2, top + i, WN_8 );
	}
	set_attr( 0417, ( 32 - WN_8 ) / 2 + 1, top + 4, WN_8 - 2 );
	i = strlen( head );
	text_out_pos_8( "-= ", ( 26 - i ) / 2, top, 0, 0xff );
	text_out_pos_8( head, ( 26 - i ) / 2 + 3, top, 0, 0xff );
	text_out_pos_8( " =-", ( 26 - i ) / 2 + 3 + i, top, 0, 0xff );
	text_out_pos_8( prompt, ( 32 - WN_8 ) / 2 + 1, top + 2, 0, 0xff );

	curs = start = 0;
	str[0] = 0;
	sz = 0;
	set_attr( 0272, ( 32 - WN_8 ) / 2 + 1 + curs, top + 4, 1 );
	while ( 1 )
	{
		byte prev_curs = curs;
		byte prev_start = start;
		byte key;
		byte redraw = 0;

		key = getkey();
		if ( key == 8 )
		{
			if ( curs > 0 )
			{
				curs--;
				if ( curs < start )
				{
					start--;
					redraw = 1;
				}
			}
		}
		else if ( key == 9 )
		{
			if ( curs < sz )
			{
				curs += 1;
			}
			if (( start + ( WN_8 - 3 ) ) < curs )
			{
				start += 1;
				redraw = 1;
			}
		}
		else if ( key == 0xc )
		{
			if ( curs == sz && curs > 0 )
			{
				sz -= 1;
				curs -= 1;
				if ( start > 0 )
				{
					start--;
				}
				str[sz] = 0;
				redraw = 1;
			}
			else if ( curs > 0 )
			{
				for ( i = curs; i < sz; i++ )
				{
					str[i-1] = str[i];
				}
				sz -= 1;
				str[sz] = 0;
				curs -= 1;
				if ( start > 0 )
				{
					start--;
				}
				redraw = 1;
			}
		}
		else if ( key >= 32 && key < 128 && sz < max_sz )
		{
			if ( curs == sz )
			{
				str[curs] = key;
				curs += 1;
				sz += 1;
				redraw = 1;
				if (( start + ( WN_8 - 3 ) ) < curs )
				{
					start += 1;
				}
			}
			else
			{
				for ( i = sz; i > curs; i-- )
				{
					str[i] = str[i-1];
				}
				str[curs] = key;
				sz += 1;
				curs += 1;
				if (( start + ( WN_8 - 3 ) ) < curs )
				{
					start += 1;
				}
				redraw = 1;
			}
			str[sz] = 0;
		}
		else if ( key == 0x81 )
		{
			result = -1;
			break;
		}
		else if ( key == 0x0d )
		{
			result = sz;
			break;
		}
		if ( redraw )
		{
			print_pad_8( str + start, ( 32 - WN_8 ) / 2 + 1, top + 4, WN_8 - 3 );
		}
		set_attr( 0417, ( 32 - WN_8 ) / 2 + 1 + prev_curs - prev_start, top + 4, 1 );
		set_attr( 0272, ( 32 - WN_8 ) / 2 + 1 + curs - start, top + 4, 1 );
	}
	for ( i = 0; i < 6; i++ )
	{
		print_pad_8( "", ( 32 - WN_8 ) / 2, top + i, WN_8 );
		set_attr( 007, ( 32 - WN_8 ) / 2, top + i, WN_8 );
	}
	return result;
}

void load_sna() __naked;

void calc_sel()
{
	if ( files_sel >= files_size ) files_sel = files_size - 1;
	else if ( files_sel < 0 ) files_sel = 0;

	while ( files_sel < files_table_start )
	{
		files_table_start -= FILES_PER_ROW;
		show_table();
	}

	while ( files_sel >= files_table_start + FILES_PER_ROW * 2 )
	{
		files_table_start += FILES_PER_ROW;
		show_table();
	}

	selx = (( files_sel - files_table_start ) / FILES_PER_ROW ) * 16 + 1;
	sely = (( files_sel - files_table_start ) % FILES_PER_ROW ) + 3;
}


void hide_sel()
{
	set_attr( 007, selx, sely, 14 );
}

void show_sel()
{
	if ( files_size <= 0 ) return;
	calc_sel();
	set_attr( 071, selx, sely, 14 );
}

void display_fn( char *fn, int col, int row, int max_sz )
{
	if ( strlen( fn ) == 0 )
	{
		print_pad_8( fn, col, row, max_sz );
	}
	else
	{
		char *p = fn + strlen( fn ) - 1;
		while ( p != fn && *p != '/' ) p--;
		if ( *p == '/' ) p++;
		print_pad_8( p, col, row, max_sz );
	}
}

void get_dsk_name( byte dsk, char *buf, word size )
{
	pport_send( PP_CMD_FCTL( PP_FCTL_DSK_GET ), 1, &dsk );
	pport_receive( buf, size );

//  putbyte(pport_result >> 8, dsk * 5, 0);
//  putbyte(pport_result & 0xff, dsk * 5 + 2, 0);
//  putbyte(pport_savesize >> 8, dsk * 5, 2);
//  putbyte(pport_savesize & 0xff, dsk * 5 + 2, 2);

	if ( pport_result != PP_W_ACK )
	{
		strcpy( buf, "err" );
	}
	else if ( buf[0] == 0 )
	{
		strcpy( buf, "----" );
	}
	else
	{
		buf[pport_pktsize] = 0;
	}
}

word get_flags()
{
	word flags;
	pport_send( PP_CMD_FCTL( PP_FCTL_CFG_GFLAGS ), 0, 0 );
	pport_receive( &flags, sizeof( flags ) );
//  putbyte(pport_result >> 8, 26, 0);
//  putbyte(pport_result & 0xff, 28, 0);
//  putbyte(pport_savesize >> 8, 26, 2);
//  putbyte(pport_savesize & 0xff, 28, 2);
	if ( pport_result != PP_W_ACK )
	{
		flags = 0;
	}
	return flags;
}

void update_disks( byte dsk )
{
	byte dsk_name[0x41];

	char dsk_head[4] = { "A:" };
	if ( dsk > 3 )
	{
		// all disks
		byte i;
		word flags = get_flags();
		for ( i = 0; i < 4; i++ )
		{
			dsk_name[0] = 0;
			get_dsk_name( i, dsk_name, 0x40 );
			dsk_head[0] = 'A' + i;
			text_out_pos_8( dsk_head, 0, 20 + i, 0, 0xff );
			display_fn( dsk_name, 2, 20 + i, 25 );
			if ( flags & ( 1 << i ) )
			{
				set_attr( 0102, 0, 20 + i, 1 );
			}
			else
			{
				set_attr( 0104, 0, 20 + i, 1 );
			}
		}
	}
	else
	{
		word flags = get_flags();
		dsk_name[0] = 0;
		get_dsk_name( dsk, dsk_name, 0x40 );
		dsk_head[0] = 'A' + dsk;
		text_out_pos_8( dsk_head, 0, 20 + dsk, 0, 0xff );
		display_fn( dsk_name, 2, 20 + dsk, 25 );
		if ( flags & ( 1 << dsk ) )
		{
			set_attr( 0102, 0, 20 + dsk, 1 );
		}
		else
		{
			set_attr( 0104, 0, 20 + dsk, 1 );
		}
	}
}

void update_rom()
{
	word flags = get_flags();
	text_out_pos_8( flags & CFG_FLG_STROM1 ? "ROM1" : "ROM0", 28, 23, 0, 0xff );
}

void init_screen()
{
	clrscr();

	set_attr( 0104, 0, 0, 32 );
	text_out_pos_8( "-=Syd's Speccy2007 boot-loader=-", 0, 0, 0, 0xff );

	__asm
	ld hl, #0x4240
	push hl
	pop de
	ld a, #0xff
	ld( hl ), a
	inc de
	ld bc, #0x1f
	ldir
	ld hl, #0x4440
	push hl
	pop de
	ld a, #0xff
	ld( hl ), a
	inc de
	ld bc, #0x1f
	ldir
	ld hl, #0x5260
	push hl
	pop de
	ld a, #0xff
	ld( hl ), a
	inc de
	ld bc, #0x1f
	ldir
	ld hl, #0x5460
	push hl
	pop de
	ld a, #0xff
	ld( hl ), a
	inc de
	ld bc, #0x1f
	ldir
	__endasm;
}

void main()
{
	char tap_path[ 0x50 ];
	strcpy( tap_path, "boot.tap" );

	init_screen();

	pport_open();

	strcpy( path, "" );
	read_dir();

	show_table();
	show_sel();
	update_disks( 4 );
	//update_rom();

	while ( true )
	{
		byte key = getkey();

		byte *name = files[ files_sel ].name;
		byte attr = files[ files_sel ].attr;

		if ( key >= 0x08 && key <= 0x0b && files_size > 0 )
		{
			byte redraw = 0;

			hide_sel();

			if ( key == 0x08 ) files_sel -= FILES_PER_ROW;
			else if ( key == 0x09 ) files_sel += FILES_PER_ROW;
			else if ( key == 0x0a ) files_sel++;
			else if ( key == 0x0b ) files_sel--;

			show_sel();

		}
		else if ( key == 0x0d )
		{
			if (( files[ files_sel ].attr & AM_DIR ) )
			{
				hide_sel();

				if ( strcmp( name, ".." ) == 0 )
				{
					byte i = strlen( path );
					byte dir_name[ 13 ];
					if ( i != 0 )
					{
						i--;
						path[i] = 0;

						while ( i != 0 && path[i - 1] != '/' ) i--;
						strcpy( dir_name, &path[i] );

						path[i] = 0;
						read_dir();

						for ( files_sel = 0; files_sel < files_size; files_sel++ )
							if ( strcmp( files[files_sel].name, dir_name ) == 0 )
								break;
						if (( files_table_start + FILES_PER_ROW * 2 - 1 ) < files_sel )
						{
							files_table_start = files_sel;
						}

						sely = (( files_sel - files_table_start ) % FILES_PER_ROW ) + 3;
						selx = (( files_sel - files_table_start ) / FILES_PER_ROW ) * 16 + 1;

						show_table();
					}
				}
				else if ( strlen( path ) + strlen( name ) + 1 < PATH_SIZE )
				{
					strcat( path, name );
					strcat( path, "/" );
					read_dir();
					sely = (( files_sel - files_table_start ) % FILES_PER_ROW ) + 3;
					selx = (( files_sel - files_table_start ) / FILES_PER_ROW ) * 16 + 1;

					show_table();
				}

				show_sel();
			}
			else
			{
				byte sdata[ 0x50 ], ext[ 0x10 ];
				dword size;
				sdata[0] = FA_OPEN_EXISTING | FA_READ;
				strcpy( &sdata[1], path );
				strcat( &sdata[1], name );

				strcpy( ext, name + strlen( name ) - 3 );

				if ( strcmp( ext, "tap" ) == 0 || strcmp( ext, "tzx" ) == 0 )
				{
					tap_path[0] = sdata[0];
					strcpy( &tap_path[1], &sdata[1] );
					break;
				}
				else if ( strcmp( ext, "scr" ) == 0 )
                {
                    pport_send( PP_CMD_FCTL( PP_FCTL_OPEN ), 0x40, sdata );
                    pport_receive( 0, 0 );

                    size = 0;
                    pport_send( PP_CMD_FCTL( PP_FCTL_SEEK ), 4, &size );
                    pport_receive( 0, 0 );

                    size = SCR_SIZE;
                    pport_send( PP_CMD_FCTL( PP_FCTL_READ ), 4, &size );
                    //pport_receive( SCR_START, SCR_SIZE );
                    pport_receive( (void*)0x4000, SCR_SIZE );

                    getkey();

                    init_screen();
                    show_table();
                    show_sel();
                    update_disks( 4 );
                }
				else if ( strcmp( ext, "sna" ) == 0 )
				{
					byte i = 0xff;

					pport_send( PP_CMD_FCTL( PP_FCTL_OPEN ), 0x40, sdata );
					pport_receive( 0, 0 );

					pport_send( PP_CMD_CTL( PP_CTL_PROM ), 0, 0 );
					pport_receive( 0, 0 );

					while (( KPORT | 0xe0 ) != 0xff ) while ( i-- != 0 );

					__asm jp 0x3870;
					__endasm;
				}
				else if ( strcmp( ext, "trd" ) == 0 || strcmp( ext, "fdi" ) == 0 || strcmp( ext, "scl" ) == 0 )
				{
                    byte ddata[ 0x50 ];
                    ddata[0] = 0; // disk 'a';
                    strcpy( ddata + 1, path );
                    strcat( ddata + 1, name );
                    pport_send( PP_CMD_FCTL( PP_FCTL_DSK_OPEN ), 0x40, ddata );
                    pport_receive( 0, 0 );

                    __asm
                    ld bc, #0x0000
                    push bc
                    jp 0x3d2d;
                    __endasm;
                }

			}
		}
		else if ( key >= 0x81 && key <= 0x84 )
		{
			// reset disk
			byte ddata;
			ddata = key - 0x81;
			pport_send( PP_CMD_FCTL( PP_FCTL_DSK_CLOSE ), 1, &ddata );
			pport_receive( 0, 0 );
			update_disks( ddata );
		}
		else if ( key >= 'a' && key <= 'd' && files_size > 0 )
		{
			byte ddata[ 0x50 ];
			ddata[0] = key - 'a';
			strcpy( ddata + 1, path );
			strcat( ddata + 1, name );
			pport_send( PP_CMD_FCTL( PP_FCTL_DSK_OPEN ), 0x40, ddata );
			pport_receive( 0, 0 );
			update_disks( key - 'a' );
		}
		else if ( key >= 'A' && key <= 'D' )
		{
			// set reset writeprotect
			word flags = get_flags();
			byte ddata[2];
			ddata[0] = key - 'A';
			ddata[1] = flags & ( 1 << ddata[0] ) ? 0 : 1;
			pport_send( PP_CMD_FCTL( PP_FCTL_DSK_WP ), 2, ddata );
			pport_receive( 0, 0 );
			update_disks( key - 'A' );
		}
		else if ( key == 0x85 && files_size > 0 )
		{
			// unlink, e.g. delete
			char prompt[27];
			strcpy( prompt, "Delete \"" );
			strcat( prompt, name );
			strcat( prompt, "\"?" );

			if ( yes_or_no( prompt ) )
			{
				byte ddata[ 0x50 ];
				strcpy( ddata, path );
				strcat( ddata, name );

				if ( strlen( ddata ) <= 0x40 )
				{
					int old_sel = files_sel;
					int old_files_table_start = files_table_start;

                    hide_sel();

					pport_send( PP_CMD_FCTL( PP_FCTL_DEL ), 0x40, ddata );
					pport_receive( 0, 0 );

					if (( byte ) pport_result == FR_DENIED )
					{
						text_out_pos_8( "ACCESS DENIED", 9, 4, 0, 0xff );
						set_attr( 0302, 9, 4, 13 );
//						putstr( "ACCESS DENIED" );
						getkey();
						set_attr( 07, 9, 4, 13 );
					}
					else
					{
						read_dir();

						files_sel = old_sel;
						files_table_start = old_files_table_start;
					}
				}
			}

			show_table();
			show_sel();
		}
		else if ( key == 0x86 && files_size > 0 )
		{
			// rename
			byte ddata[ 0x50 ];
			byte new_name[ 0x20 ];
			hide_sel();

			if ( input_box( "New filename", name, new_name, 30 ) > 0 )
			{
				if ( new_name[0] != 0 && strlen( path ) + strlen( name ) + 2 <= 0x40 && strlen( path ) + strlen( new_name ) + 2 <= 0x40 )
				{
					int old_sel = files_sel;
					int old_files_table_start = files_table_start;

					byte *data_part2;

                    hide_sel();

					strcpy( ddata, path );
					strcat( ddata, name );
					data_part2 = ddata + strlen( ddata ) + 1;
					strcpy( data_part2, "_" );

					pport_send( PP_CMD_FCTL( PP_FCTL_RENAME ), 0x40, ddata );
					pport_receive( 0, 0 );

					//putbyte( (byte) pport_result );
					//getkey();

					strcpy( ddata, "_" );
					data_part2 = ddata + 2;

					if( new_name[0] == '/' )
					{
					    strcpy( data_part2, new_name + 1 );
					}
					else
					{
					    byte path_size = strlen( path );
					    char *new_name_ptr = new_name;

					    while( new_name_ptr[0] == '.' && new_name_ptr[1] == '/' ) new_name_ptr += 2;
					    while( new_name_ptr[0] == '.' && new_name_ptr[1] == '.' && new_name_ptr[2] == '/' )
					    {
					        if( path_size != 0 )
					        {
                                path_size--;
                                while ( path_size != 0 && path[ path_size - 1 ] != '/' ) path_size--;
					        }

                            new_name_ptr += 3;
					    }

                        strncpy( data_part2, path, path_size );
                        strcpy( data_part2 + path_size, new_name_ptr );
					}

					pport_send( PP_CMD_FCTL( PP_FCTL_RENAME ), 0x40, ddata );
					pport_receive( 0, 0 );

					//putbyte( (byte) pport_result );
					//getkey();

					read_dir();

					files_sel = old_sel;
					files_table_start = old_files_table_start;
				}
			}

			show_table();
			show_sel();
		}
		else if ( key == 0x87 )
		{
			word flags = get_flags();
			flags ^= CFG_FLG_STROM1;
			pport_send( PP_CMD_FCTL( PP_FCTL_CFG_SFLAGS ), sizeof( flags ), &flags );
			pport_receive( 0, 0 );
			//update_rom();
			//print_head();
			init_screen();
			update_disks( 4 );
			show_table();
		}
	}

	pport_send( PP_CMD_FCTL( PP_FCTL_OPEN ), 0x40, tap_path );
	pport_receive( 0, 0 );
	pport_close();

	halt();
}
