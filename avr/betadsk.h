#ifndef __BETADSK_H
#define __BETADSK_H

#ifdef __cplusplus
extern "C"
{
#endif

#define BETADSK_NUM_DRIVES 4

	enum
	{
		BETA_IDLE = 0,
		BETA_READ,
		BETA_READ_TRK,
		BETA_READ_ADR,
		BETA_WRITE,
		BETA_WRITE_TRK,
		BETA_SEEK,
	};

#if defined(WIN32_TEST)
	extern unsigned char trdos_curcyl;
#endif

	int open_dsk_image( byte drv_id, const char *filename );
	void close_dsk_image( byte drv_id );
	void beta_write_port( byte port, byte data );
	byte beta_read_port( byte port );
	void beta_init();
	void beta_routine();
	byte beta_get_state();
	byte beta_cur_drv();
	byte beta_is_disk_wp( byte drv );
	void beta_set_disk_wp( byte drv, byte wp );
	byte beta_is_disk_loaded( byte drv );
	void beta_init_drive( byte drv_id );
	void beta_dsk_init();
	void beta_dump_state();
#if 0
	void driveMotorOn( byte dsk );
	void driveMotorOff( byte dsk );
#endif
#ifdef __cplusplus
};
#endif


#endif

