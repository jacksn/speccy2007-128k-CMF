#ifndef __CONFIG_H
#define __CONFIG_H

#define FILENAME_EEPROM_SIZE 62

#define TYPE_STRING 0
#define TYPE_BINARY 1

#define CFG_TAPE_FILENAME 0
#define CFG_DRVA_FILENAME 1
#define CFG_DRVB_FILENAME 2
#define CFG_DRVC_FILENAME 3
#define CFG_DRVD_FILENAME 4
#define CFG_FLAGS         5
#define CFG_LAST          5

#define ERR_BAD_ITEM -1
#define ERR_BAD_CONFIG -2
#define ERR_BAD_CRC -3
#define ERR_BAD_IO -4

#define CFG_SIZE          5 * (FILENAME_EEPROM_SIZE + 2) + 4

int read_config( int item, char *dst );
int write_config( int item, const char *dst );
int sd_read_config( int item, char *dst );
int sd_write_config( int item, const char *dst );
int sd_new_config();
int sd_check_config();

#endif
