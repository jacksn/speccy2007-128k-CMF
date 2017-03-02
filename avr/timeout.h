#ifndef TOUT_H
#define TOUT_H

extern void delay_ms( unsigned int ms );
extern void wd_init( void );
extern void wd_kick( void );

#define F_CPU 14000000UL  // 14 MHz
#include <util/delay.h>

#endif /* TOUT_H */
