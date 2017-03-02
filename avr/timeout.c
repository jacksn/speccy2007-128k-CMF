#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <avr/pgmspace.h>

#include "avr_compat.h"
#include "timeout.h"

void delay_ms( unsigned int ms )
{
	while ( ms )
	{
		_delay_ms( 0.96 );
		ms--;
	}
}

void wd_init( void )
{
	wdt_enable( WDTO_2S );
}

void wd_kick( void )
{
	wdt_reset();
}


