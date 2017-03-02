#include <stdio.h>
#include <stdlib.h>

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned long dword;

#define min( a, b ) ( a <? b )

int main(  int argc, char* argv[]  )
{
    if( argc != 4 )
    {
        printf("Hello world!\n");
        return 0;
    }

    FILE *file_out = fopen( argv[1], "wb" );
    FILE *file_rom = fopen( argv[2], "rb" );
    FILE *file_in = fopen( argv[3], "rb" );

    if( file_in == NULL || file_rom == NULL || file_out == NULL )
    {
        printf("Hello world!\n");
        return 0;
    }

    fseek( file_rom, 0, SEEK_END );
    int size_rom = ftell( file_rom );

    fseek( file_in, 0, SEEK_END );
    int size_in = min( ftell( file_in ), size_rom - 0x3b00 );

    byte *buff_rom = new byte[ size_rom ];

    fseek( file_rom, 0, SEEK_SET );
    fread( buff_rom, 1, size_rom, file_rom );

	if( size_in > 0 )
	{
		fseek( file_in, 0, SEEK_SET );
		fread( buff_rom + 0x3870, 1, size_in, file_in );
	}

	*(byte*) &buff_rom[ 0x38 ] = 0xc9;              // ret

	*(word*) &buff_rom[ 0x66 ] = 0xf818;            //jr loc_60
	buff_rom[ 0x60 ] = 0xc3;                        //jp loc_3870
	*(word*) &buff_rom[ 0x61 ] = 0x3870;

	*(word*) &buff_rom[ 0x3eff ] = 0x3f01;          // int vector
	*(byte*) &buff_rom[ 0x3f01 ] = 0x3c;            // inc a
	*(byte*) &buff_rom[ 0x3f02 ] = 0xc9;            // ret


    fwrite( buff_rom, 1, size_rom, file_out );
    delete buff_rom;

    fclose( file_rom );
    fclose( file_in );
    fclose( file_out );
}
