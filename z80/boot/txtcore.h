#ifndef txtcore_h
#define txtcore_h

#include "types.h"

void set_attr( byte c, byte col, byte row, byte w );
void text_out_pos_8( char *str, byte row, byte col, byte inv_mask, byte max_sz );

#endif
