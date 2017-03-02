#include "txtcore.h"

/*
byte char_out_mask[16] =
{
	0x03, 0x81, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc, 0xfe,
	0xff, 0xff, 0xff, 0x7f, 0x3f, 0x1f, 0x0f, 0x07,
};*/

void set_attr( byte c, byte col, byte row, byte w )
{
	c;
	col;
	row;
	w;

	__asm
	ld l, 6( ix )
	ld h, #0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld e, 5( ix )
	ld d, #0
	add hl, de
	ld  a, #0x58
	add h
	ld  h, a
	push hl
	pop  de
	inc  de
	ld  a, 4( ix )
	ld( hl ), a
	ld c, 7( ix )
	dec c
	jr z, skip
	ld b, #0
	ldir
skip:
	__endasm;
}

void text_out_pos_8( char *str, byte row, byte col, byte inv_mask, byte max_sz )
{
	str;
	row;
	col;
	inv_mask;
	max_sz;
	__asm
	ld a, 7( ix )
	ld l, a
	and a, #0x18
	ld h, a
	sla l
	sla l
	sla l
	sla l
	sla l
	ld bc, #0x4000
	add hl, bc
	ld c, 6( ix )
	ld b, #0
	add hl, bc

	push hl
	pop  de

	ld l, 4( ix )
	ld h, 5( ix )
text_out_8_loop:
	ld a, 9( ix )
	cp #0xff
	jr z, to8_skip_sz
	or a
	jr z, text_out_8_end
	dec 9( ix )
to8_skip_sz:
	ld a, ( hl )
	or a
	jr z, text_out_8_end

	push hl  // save str pointer

	ld l, a
	ld h, #0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, #0x3c00
	add hl, bc

	ld b, #8
	push de
to_8_tr_l:
	ld a, ( hl )
	xor 8( ix )
	ld( de ), a
	inc hl
	inc d
	djnz to_8_tr_l
	pop de
	inc e
	pop hl
	inc hl
	jr text_out_8_loop
text_out_8_end:
	__endasm;
}


