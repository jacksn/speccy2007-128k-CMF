#include "stdinc.h"
#include "types.h"
#if defined(WIN32_TEST)
#include "sp2007cfg.h"
#else
#include "config.h"
#endif
#include "crc.h"
#include "ff.h"

#define CFG_FILE 			"speccfg.bin"
#define DUMP_CHECK 			0

int get_info( int item, word *offset, byte *type )
{
	int sz;

	*type = TYPE_STRING;
	sz = FILENAME_EEPROM_SIZE;

	switch ( item )
	{
	case CFG_TAPE_FILENAME:
		*offset = 0;
		break;
	case CFG_DRVA_FILENAME:
		*offset = ( FILENAME_EEPROM_SIZE + 2 ) * 1;
		break;
	case CFG_DRVB_FILENAME:
		*offset = ( FILENAME_EEPROM_SIZE + 2 ) * 2;
		break;
	case CFG_DRVC_FILENAME:
		*offset = ( FILENAME_EEPROM_SIZE + 2 ) * 3;
		break;
	case CFG_DRVD_FILENAME:
		*offset = ( FILENAME_EEPROM_SIZE + 2 ) * 4;
		break;
	case CFG_FLAGS:
		*offset = ( FILENAME_EEPROM_SIZE + 2 ) * 5;  // size + data[] + crc
		*type = TYPE_BINARY;
		sz = sizeof( word );
		break;
	default:
		return 0;
	}
	return sz;
}

int sd_read_config( int item, char *dst )
{
	int max_sz;
	word offset, crc;
	UINT nr;
	byte sz_in_file, crc_file, type, i;
	FIL fc;
	const char *cfg_file = CFG_FILE;

	max_sz = get_info( item, &offset, &type );
	if ( max_sz == 0 )
	{
		return ERR_BAD_ITEM;
	}

	if ( f_open( &fc, cfg_file, FA_READ ) != FR_OK )
	{
		return ERR_BAD_IO;
	}

	f_lseek( &fc, offset );
	if ( f_read( &fc, &sz_in_file, 1, &nr ) != FR_OK || nr != 1 )
	{
		f_close( &fc );
		return ERR_BAD_IO;
	}
	if ( sz_in_file > max_sz )
	{
		f_close( &fc );
		return ERR_BAD_IO;
	}

	if ( sz_in_file )
	{
		if ( f_read( &fc, ( byte * )dst, sz_in_file, &nr ) != FR_OK || nr != sz_in_file )
		{
			f_close( &fc );
			return ERR_BAD_IO;
		}
	}
	crc = crc_add( crc_init(), sz_in_file );
	for ( i = 0; i < sz_in_file; i++ )
	{
		crc = crc_add( crc, dst[i] );
	}
	f_lseek( &fc, offset + max_sz + 1 );
	if ( f_read( &fc, &crc_file, 1, &nr ) != FR_OK || nr != 1 )
	{
		f_close( &fc );
		return ERR_BAD_IO;
	}
	f_close( &fc );
	if (((( byte )( crc >> 8 ) ) ^(( byte )( crc & 0xff ) ) ^ crc_file ) != 0 )
	{
		return ERR_BAD_CRC;
	}
	if ( type == TYPE_STRING )
	{
		dst[sz_in_file] = 0;
	}

	return sz_in_file;
}

int sd_write_config( int item, const char *dst )
{
	int max_sz;
	word offset, crc;
	UINT nw;
	byte sz_in_file, type, i, crc_file;
	FIL fc;
	const char *cfg_file = CFG_FILE;

	max_sz = get_info( item, &offset, &type );
	if ( max_sz == 0 )
	{
		return ERR_BAD_ITEM;
	}

	if ( type == TYPE_STRING )
	{
		sz_in_file = strlen( dst );
	}
	else
	{
		sz_in_file = max_sz;
	}
	if ( sz_in_file > max_sz )
	{
		return ERR_BAD_CONFIG;
	}

	if ( f_open( &fc, cfg_file, FA_WRITE ) != FR_OK )
	{
		return ERR_BAD_IO;
	}

	crc = crc_add( crc_init(), sz_in_file );
	for ( i = 0; i < sz_in_file; i++ )
	{
		crc = crc_add( crc, dst[i] );
	}
	f_lseek( &fc, offset );
	if ( f_write( &fc, &sz_in_file, 1, &nw ) != FR_OK || nw != 1 )
	{
		f_close( &fc );
		return ERR_BAD_IO;
	}
	if ( sz_in_file )
	{
		if ( f_write( &fc, dst, sz_in_file, &nw ) != FR_OK || nw != sz_in_file )
		{
			f_close( &fc );
			return ERR_BAD_IO;
		}
	}
	f_lseek( &fc, offset + max_sz + 1 );
	crc_file = (( byte )( crc >> 8 ) ) ^(( byte )( crc & 0xff ) );
	if ( f_write( &fc, &crc_file, 1, &nw ) != FR_OK || nw != 1 )
	{
		f_close( &fc );
		return ERR_BAD_IO;
	}
	f_close( &fc );
	return sz_in_file;

	return 1;
}

int sd_new_config()
{
	FIL fc;
	byte i, j, cc, type;
	word crc, offset;
	UINT nw;
	int max_sz;
	const char *cfg_file = CFG_FILE;

	if ( f_open( &fc, cfg_file, FA_WRITE | FA_CREATE_ALWAYS ) != FR_OK )
	{
		return 0;
	}

	for ( i = 0; i <= CFG_LAST; i++ )
	{
		max_sz = get_info( i, &offset, &type );
		cc = 0;
		if ( f_write( &fc, &cc, 1, &nw ) != FR_OK || nw != 1 )
		{
			f_close( &fc );
			f_unlink( cfg_file );
			return 0;
		}
		crc = crc_add( crc_init(), cc );
		for ( j = 0; j < max_sz; j++ )
		{
			if ( f_write( &fc, &cc, 1, &nw ) != FR_OK || nw != 1 )
			{
				f_close( &fc );
				f_unlink( cfg_file );
				return 0;
			}
		}
		cc = (( byte )( crc >> 8 ) ) ^(( byte )( crc & 0xff ) );
		if ( f_write( &fc, &cc, 1, &nw ) != FR_OK || nw != 1 )
		{
			f_close( &fc );
			f_unlink( cfg_file );
			return 0;
		}
	}

	f_close( &fc );

	return 1;
}

int sd_check_config()
{
	FILINFO fi;
	FIL fc;
	word crc, offset;
	UINT nr;
	byte sz_in_file, crc_file, type, i, j, cc;
	int max_sz;
	const char *cfg_file = CFG_FILE;


	if ( f_stat( cfg_file, &fi ) != FR_OK )
	{
		return 0;
	}

	if ( fi.fsize < CFG_SIZE )
	{
		return 0;
	}

	if ( f_open( &fc, cfg_file, FA_READ ) != FR_OK )
	{
		return 0;
	}

	for ( i = 0; i <= CFG_LAST; i++ )
	{
		max_sz = get_info( i, &offset, &type );
		f_lseek( &fc, offset );
		if ( f_read( &fc, &sz_in_file, 1, &nr ) != FR_OK || nr != 1 )
		{
			f_close( &fc );
			return 0;
		}
		if ( sz_in_file > max_sz )
		{
			f_close( &fc );
			return 0;
		}
		crc = crc_add( crc_init(), sz_in_file );
		for ( j = 0; j < sz_in_file; j++ )
		{
			if ( f_read( &fc, &cc, 1, &nr ) != FR_OK || nr != 1 )
			{
				f_close( &fc );
				return 0;
			}
			crc = crc_add( crc, cc );
		}
		f_lseek( &fc, offset + max_sz + 1 );
		if ( f_read( &fc, &crc_file, 1, &nr ) != FR_OK || nr != 1 )
		{
			f_close( &fc );
			return 0;
		}
		if (((( byte )( crc >> 8 ) ) ^(( byte )( crc & 0xff ) ) ^ crc_file ) != 0 )
		{
			f_close( &fc );
			return 0;
		}
	}

	f_close( &fc );

	return 1;
}


