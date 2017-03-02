;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 2.8.0 #5117 (Mar 23 2008) (MINGW32)
; This file was generated Sun Mar 20 21:54:52 2016
;--------------------------------------------------------
	.module txtcore
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_attr
	.globl _text_out_pos_8
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; overlayable items in  ram 
;--------------------------------------------------------
	.area _OVERLAY
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;txtcore.c:10: void set_attr( byte c, byte col, byte row, byte w )
;	genLabel
;	genFunction
;	---------------------------------
; Function set_attr
; ---------------------------------
_set_attr_start::
_set_attr:
	push	ix
	ld	ix,#0
	add	ix,sp
;txtcore.c:42: __endasm;
;	genInline
	
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
		ld a, #0x58
		add h
		ld h, a
		push hl
		pop de
		inc de
		ld a, 4( ix )
		ld( hl ), a
		ld c, 7( ix )
		dec c
		jr z, skip
		ld b, #0
		ldir
	skip:
		
;	genLabel
;	genEndFunction
	pop	ix
	ret
_set_attr_end::
;txtcore.c:45: void text_out_pos_8( char *str, byte row, byte col, byte inv_mask, byte max_sz )
;	genLabel
;	genFunction
;	---------------------------------
; Function text_out_pos_8
; ---------------------------------
_text_out_pos_8_start::
_text_out_pos_8:
	push	ix
	ld	ix,#0
	add	ix,sp
;txtcore.c:110: __endasm;
;	genInline
	
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
		pop de
	
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
	
		push hl
	
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
		
;	genLabel
;	genEndFunction
	pop	ix
	ret
_text_out_pos_8_end::
	.area _CODE
	.area _CABS
