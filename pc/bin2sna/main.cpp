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
    FILE *file_sna = fopen( argv[2], "rb" );
    FILE *file_in = fopen( argv[3], "rb" );

    if( file_in == NULL || file_sna == NULL || file_out == NULL )
    {
        printf("Hello world!\n");
        return 0;
    }

    fseek( file_sna, 0, SEEK_END );
    int size_sna = ftell( file_sna );

    fseek( file_in, 0, SEEK_END );
    int size_in = min( ftell( file_in ), 0x8000 );

    byte *buff_sna = new byte[ size_sna ];

    fseek( file_sna, 0, SEEK_SET );
    fread( buff_sna, 1, size_sna, file_sna );

	if( size_in > 0 )
	{
		fseek( file_in, 0, SEEK_SET );
		fread( buff_sna + 0x4000 + 0x1b, 1, size_in, file_in );
	}

    fwrite( buff_sna, 1, size_sna, file_out );
    delete buff_sna;

    fclose( file_sna );
    fclose( file_in );
    fclose( file_out );
}
