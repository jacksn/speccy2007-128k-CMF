#if !defined(WIN32_TEST)
	#include <avr/io.h>
	#include <avr/pgmspace.h>
	#include <avr/eeprom.h>
	#include <avr/interrupt.h>
#else
	#include <stdio.h>
#endif

#include "types.h"
#include <string.h>
#include <ctype.h>
#include "options.h"

