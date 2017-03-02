#include <stdio.h>
#include <stdlib.h>

typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned long dword;


int main(  int argc, char* argv[]  )
{
    if( argc != 4 )
    {
        printf("Hello world!\n");
        return 0;
    }

    FILE *file_out = fopen( argv[1], "wb" );
    FILE *file_head = fopen( argv[2], "rb" );
    FILE *file_in = fopen( argv[3], "rb" );

    if( file_in == NULL || file_head == NULL || file_out == NULL )
    {
        printf("Hello world!\n");
        return 0;
    }

    fseek( file_head, 0, SEEK_END );
    dword size_head = ftell( file_head );
    fseek( file_in, 0, SEEK_END );
    dword size_in = ftell( file_in );

    byte *buff_head = new byte[ size_head ];
    byte *buff_body = new byte[ 2 + 1 + size_in + 1 ];

    fseek( file_head, 0, SEEK_SET );
    fread( buff_head, 1, size_head, file_head );

    byte header[] = { 0x13, 0, 0, 3, 'c', 'o', 'd', 'e', ' ', ' ', ' ', ' ', ' ', ' ', 0, 0, 0, 0x80, 0, 0x80, 0 };

    *(word*) &header[ 0x0e ] = (word) size_in;

    for( int i = 2; i < 0x14; i++ )
        header[ 0x14 ] ^= header[ i ];

    *(word*) buff_body = (word) size_in + 2;
    buff_body[2] = 0xff;

    fseek( file_in, 0, SEEK_SET );
    fread( &buff_body[3], 1, size_in, file_in );

    buff_body[ size_in + 3 ] = 0;

    for( int i = 2; i <  size_in + 3; i++ )
        buff_body[ size_in + 3 ] ^= buff_body[ i ];

    fwrite( buff_head, 1, size_head, file_out );
    fwrite( header, 1, sizeof(header), file_out );
    fwrite( buff_body, 1, size_in + 4, file_out );

    delete buff_head;
    delete buff_body;

    fclose( file_head );
    fclose( file_in );
    fclose( file_out );
}
