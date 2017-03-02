#ifndef UART_H
#define UART_H

#include <avr/pgmspace.h>
#include "types.h"

extern void uart_init( void );
extern void uart_sendchar( char c );
extern void uart_senddig( char c );

extern void uart_sendstr( char *s );
extern void uart_sendstr_p( const prog_char *progmem_s );
extern unsigned char uart_getchar( unsigned char kickwd );
extern void uart_flushRXbuf( void );
extern void uart_send_word( word i );
extern void uart_send_byte( byte i );

/*
** macros for automatically storing string constant in program memory
*/
#ifndef P
#define P(s) ({static const char c[] __attribute__ ((progmem)) = s;c;})
#endif
#define uart_sendstr_P(__s)         uart_sendstr_p(P(__s))

#endif /* UART_H */
