#include <stdio.h>
#include <io.h>
#include <fcntl.h>
#include <string.h>

typedef unsigned short word;

word base[ 0x100 ];
int base_pos = 0;

void GetLine( char *str, int str_size, word opcode )
{
	strcpy( str, "" );

	unsigned char *buf = (unsigned char *) &opcode;
	int i = 0;

	if ( buf[i] == 0xd3 )
	{
		if ( buf[i + 1] == 0x1f || buf[i + 1] == 0x3f || buf[i + 1] == 0x5f || buf[i + 1] == 0x7f || buf[i + 1] == 0xff )
		{
			snprintf( str, str_size, "out (#%x), a", buf[i + 1] );
		}
	}
	if ( buf[i] == 0xdb )
	{
		if ( buf[i + 1] == 0x1f || buf[i + 1] == 0x3f || buf[i + 1] == 0x5f || buf[i + 1] == 0x7f || buf[i + 1] == 0xff )
		{
			snprintf( str, str_size, "in a, (#%x)", buf[i + 1] );
		}
	}
	if ( buf[i] == 0xed )
	{
		if ( buf[i + 1] == 0x40 )
		{
			snprintf( str, str_size, "in b, (c)" );
		}
		if ( buf[i + 1] == 0x41 )
		{
			snprintf( str, str_size, "out (c), b" );
		}
		if ( buf[i + 1] == 0x48 )
		{
			snprintf( str, str_size, "in c, (c)" );
		}
		if ( buf[i + 1] == 0x49 )
		{
			snprintf( str, str_size, "out (c), c" );
		}
		if ( buf[i + 1] == 0x50 )
		{
			snprintf( str, str_size, "in d, (c)" );
		}
		if ( buf[i + 1] == 0x51 )
		{
			snprintf( str, str_size, "out (c), d" );
		}
		if ( buf[i + 1] == 0x58 )
		{
			snprintf( str, str_size, "in e, (c)" );
		}
		if ( buf[i + 1] == 0x59 )
		{
			snprintf( str, str_size, "out (c), e" );
		}
		if ( buf[i + 1] == 0x60 )
		{
			snprintf( str, str_size, "in h, (c)" );
		}
		if ( buf[i + 1] == 0x61 )
		{
			snprintf( str, str_size, "out (c), h" );
		}
		if ( buf[i + 1] == 0x68 )
		{
			snprintf( str, str_size, "in l, (c)" );
		}
		if ( buf[i + 1] == 0x69 )
		{
			snprintf( str, str_size, "out (c), l" );
		}
		if ( buf[i + 1] == 0x70 )
		{
			snprintf( str, str_size, "in (hl), (c)" );
		}
		if ( buf[i + 1] == 0x71 )
		{
			snprintf( str, str_size, "out (c), (hl)" );
		}
		if ( buf[i + 1] == 0x78 )
		{
			snprintf( str, str_size, "in a, (c)" );
		}
		if ( buf[i + 1] == 0x79 )
		{
			snprintf( str, str_size, "out (c), a" );
		}
		if ( buf[i + 1] == 0xa2 )
		{
			snprintf( str, str_size, "ini" );
		}
		if ( buf[i + 1] == 0xa3 )
		{
			snprintf( str, str_size, "outi" );
		}
		if ( buf[i + 1] == 0xaa )
		{
			snprintf( str, str_size, "ind" );
		}
		if ( buf[i + 1] == 0xab )
		{
			snprintf( str, str_size, "outd" );
		}
		if ( buf[i + 1] == 0xb2 )
		{
			snprintf( str, str_size, "inir" );
		}
		if ( buf[i + 1] == 0xb3 )
		{
			snprintf( str, str_size, "otir" );
		}
		if ( buf[i + 1] == 0xba )
		{
			snprintf( str, str_size, "indr" );
		}
		if ( buf[i + 1] == 0xbb )
		{
			snprintf( str, str_size, "otdr" );
		}
	}
}

void SaveLine( const char *str, unsigned char *buf, int pos )
{
	word opcode = *(word*) &buf[pos];
	int i = 0;
	while( i < base_pos && base[ i ] != opcode ) i++;

	if( i >= base_pos )
	{
		base[ base_pos ] = opcode;
		base_pos++;
	}
}

void PrintLine( const char *str, unsigned char *buf, int pos )
{
	word opcode = *(word*) &buf[pos];
	int i = 0;
	while( i < base_pos && base[ i ] != opcode ) i++;

	bool skip = false;
	//if( pos == 0x2a53 ) skip = true;
	if( pos == 0x2b69 - 1 ) skip = true;
	if( pos == 0x2b7b - 1 ) skip = true;
	if( pos == 0x2c1a - 1 ) skip = true;
	if( pos == 0x2c6b - 1 ) skip = true;
	if( pos == 0x2ded - 1 ) skip = true;
	if( pos == 0x2e22 - 1 ) skip = true;
	if( pos == 0x2ef5 - 1 ) skip = true;

	printf( "; 0x%.4X - ( %.2X %.2X ) - %s - io_type_%.4X\n", pos, buf[pos], buf[pos + 1], str, base[i] );

	if( !skip )
	{
		printf( "\torg\t#%.4X\n", pos );
		printf( "\t\tdb\t#CF, #%.2X\n\n", i );
	}
	else
	{
		printf( ";\torg\t#%.4X\n", pos );
		printf( ";\t\tdb\t#CF, #%.2X\n\n", i );
	}
}

int main( int argc, char **argv )
{
	if( argc < 1 )
	{
		return 1;
	}

	unsigned char buf[16386];
	int i;

	int h = open( argv[1], _O_RDONLY );

	if ( h < 0 )
	{
		return 1;
	}

	memset( buf, 0, sizeof( buf ) );

	read( h, buf, 16384 );
	close( h );

	for ( i = 0; i < 16384; i++ )
	{
		char str[40];
		GetLine( str, sizeof( str ), *(word*) &buf[i] );

		if( strlen( str ) > 0 ) SaveLine( str, buf, i );
	}

/*
	for ( i = 0; i < base_pos; i++ )
	{
		char str[40];
		GetLine( str, sizeof( str ), base[i] );

		printf( "io_type_%.4X:\t\t; %s\n", base[i], str );
		printf( "\tpop hl\n" );
		printf( "\tpop af\n" );
		printf( "\t%s\n", str );
		printf( "\tret\n\n" );
	}
*/

	printf( "io_table:\n" );

	for ( i = 0; i < base_pos; i++ )
	{
		printf( "\tdw io_type_%.4X\n", base[ i ] );
	}

	printf( "\n" );

	for ( i = 0; i < 16384; i++ )
	{
		char str[40];
		GetLine( str, sizeof( str ), *(word*) &buf[i] );

		if( strlen( str ) > 0 )
		{
			PrintLine( str, buf, i );
		}
	}

	return 0;
}


