;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 2.8.0 #5117 (Mar 23 2008) (MINGW32)
; This file was generated Sun Mar 20 21:54:53 2016
;--------------------------------------------------------
	.module main
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _init_screen
	.globl _update_rom
	.globl _update_disks
	.globl _get_flags
	.globl _get_dsk_name
	.globl _display_fn
	.globl _show_sel
	.globl _hide_sel
	.globl _calc_sel
	.globl _input_box
	.globl _yes_or_no
	.globl _clrscr
	.globl _read_dir
	.globl _qsort
	.globl _swap_name
	.globl _comp_name
	.globl _show_table
	.globl _display_path
	.globl _print_pad_8
	.globl _pport_close
	.globl _pport_open
	.globl _pport_receive
	.globl _pport_send_data
	.globl _pport_send
	.globl _strupr
	.globl _strlwr
	.globl _putbyte
	.globl _putdig
	.globl _halt
	.globl _getkey
	.globl _readkey
	.globl _getcode
	.globl _key_pushed
	.globl _key_last
	.globl _sound_bit
	.globl _code_table
	.globl _save_scr_buff
	.globl _pport_good
	.globl _pport_pktsize
	.globl _pport_datasize
	.globl _pport_result
	.globl _path
	.globl _cmd_pos
	.globl _cmd
	.globl _sely
	.globl _selx
	.globl _files_sel
	.globl _files_table_start
	.globl _files_size
	.globl _files
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_PPORT	=	0x001f
_KPORT	=	0x00fe
_KPORT0	=	0xfefe
_KPORT1	=	0xfdfe
_KPORT2	=	0xfbfe
_KPORT3	=	0xf7fe
_KPORT4	=	0xeffe
_KPORT5	=	0xdffe
_KPORT6	=	0xbffe
_KPORT7	=	0x7ffe
_MEMPORT	=	0x7ffd
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_files::
	.ds 14336
_files_size::
	.ds 2
_files_table_start::
	.ds 2
_files_sel::
	.ds 2
_selx::
	.ds 1
_sely::
	.ds 1
_cmd::
	.ds 25
_cmd_pos::
	.ds 1
_path::
	.ds 65
_pport_result::
	.ds 2
_pport_datasize::
	.ds 2
_pport_pktsize::
	.ds 2
_pport_good::
	.ds 1
_save_scr_buff::
	.ds 6912
_code_table::
	.ds 128
_sound_bit::
	.ds 1
_key_last::
	.ds 1
_key_pushed::
	.ds 1
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
;main.c:33: byte selx = 1, sely = 3;
;	genAssign
	ld	iy,#_selx
	ld	0(iy),#0x01
;main.c:33: 
;	genAssign
	ld	iy,#_sely
	ld	0(iy),#0x03
;main.c:44: byte pport_good = 0;
;	genAssign
	ld	iy,#_pport_good
	ld	0(iy),#0x00
;main.c:48: byte code_table[ 0x80 ] = { 0, 'a', 'q', '1', '0', 'p', 0x0d, ' ',
;	genArrayInit
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_code_table
	call	__initrleblock
	.db	40
	.db	0x00, 0x61, 0x71, 0x31, 0x30, 0x70, 0x0D, 0x20
	.db	0x7A, 0x73, 0x77, 0x32, 0x39, 0x6F, 0x6C, 0x00
	.db	0x78, 0x64, 0x65, 0x33, 0x38, 0x69, 0x6B, 0x6D
	.db	0x63, 0x66, 0x72, 0x34, 0x37, 0x75, 0x6A, 0x6E
	.db	0x76, 0x67, 0x74, 0x35, 0x36, 0x79, 0x68, 0x62
	.db	#-25,#0x00
	.db	39
	.db	0x41, 0x51, 0x00, 0x0C, 0x50, 0x0D, 0x20, 0x5A
	.db	0x53, 0x57, 0x00, 0x87, 0x4F, 0x4C, 0x00, 0x58
	.db	0x44, 0x45, 0x00, 0x09, 0x49, 0x4B, 0x4D, 0x43
	.db	0x46, 0x52, 0x00, 0x0B, 0x55, 0x4A, 0x4E, 0x56
	.db	0x47, 0x54, 0x08, 0x0A, 0x59, 0x48, 0x42
	.db	0
;main.c:76: byte sound_bit = 0;
;	genAssign
	ld	iy,#_sound_bit
	ld	0(iy),#0x00
;main.c:132: byte key_last = 0;
;	genAssign
	ld	iy,#_key_last
	ld	0(iy),#0x00
;main.c:133: byte key_pushed = 0;
;	genAssign
	ld	iy,#_key_pushed
	ld	0(iy),#0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;main.c:65: byte getcode( byte a, byte b )
;	genLabel
;	genFunction
;	---------------------------------
; Function getcode
; ---------------------------------
_getcode_start::
_getcode:
	push	ix
	ld	ix,#0
	add	ix,sp
;main.c:67: if ( b & 0x01 ) return 0x80 | ( 0 << 3 ) | a;
;	genAnd
;	AOP_STK for 
	ld	a,5(ix)
	and	a,#0x01
	jr	Z,00102$
;	genOr
;	AOP_STK for 
	ld	a,4(ix)
	or	a,#0x80
	ld	l,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
	jr	00111$
;	genLabel
00102$:
;main.c:68: if ( b & 0x02 ) return 0x80 | ( 1 << 3 ) | a;
;	genAnd
;	AOP_STK for 
	ld	a,5(ix)
	and	a,#0x02
	jr	Z,00104$
;	genOr
;	AOP_STK for 
	ld	a,4(ix)
	or	a,#0x88
	ld	l,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
	jr	00111$
;	genLabel
00104$:
;main.c:69: if ( b & 0x04 ) return 0x80 | ( 2 << 3 ) | a;
;	genAnd
;	AOP_STK for 
	ld	a,5(ix)
	and	a,#0x04
	jr	Z,00106$
;	genOr
;	AOP_STK for 
	ld	a,4(ix)
	or	a,#0x90
	ld	l,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
	jr	00111$
;	genLabel
00106$:
;main.c:70: if ( b & 0x08 ) return 0x80 | ( 3 << 3 ) | a;
;	genAnd
;	AOP_STK for 
	ld	a,5(ix)
	and	a,#0x08
	jr	Z,00108$
;	genOr
;	AOP_STK for 
	ld	a,4(ix)
	or	a,#0x98
	ld	l,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
	jr	00111$
;	genLabel
00108$:
;main.c:71: if ( b & 0x10 ) return 0x80 | ( 4 << 3 ) | a;
;	genAnd
;	AOP_STK for 
	ld	a,5(ix)
	and	a,#0x10
	jr	Z,00110$
;	genOr
;	AOP_STK for 
	ld	a,4(ix)
	or	a,#0xA0
	ld	l,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
	jr	00111$
;	genLabel
00110$:
;main.c:73: return 0;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x00
;	genLabel
00111$:
;	genEndFunction
	pop	ix
	ret
_getcode_end::
;main.c:78: byte readkey()
;	genLabel
;	genFunction
;	---------------------------------
; Function readkey
; ---------------------------------
_readkey_start::
_readkey:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-1
	add	hl,sp
	ld	sp,hl
;main.c:82: kdata = PPORT;
;	genAssign
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:0
	in	a,(_PPORT)
;main.c:84: if ( kdata & 0x01 ) return 0x09;
;	genAnd
	ld	c,a
	and	a,#0x01
	jr	Z,00102$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x09
	jp	00160$
;	genLabel
00102$:
;main.c:85: if ( kdata & 0x02 ) return 0x08;
;	genAnd
	ld	a,c
	and	a,#0x02
	jr	Z,00104$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x08
	jp	00160$
;	genLabel
00104$:
;main.c:86: if ( kdata & 0x04 ) return 0x0a;
;	genAnd
	ld	a,c
	and	a,#0x04
	jr	Z,00106$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x0A
	jp	00160$
;	genLabel
00106$:
;main.c:87: if ( kdata & 0x08 ) return 0x0b;
;	genAnd
	ld	a,c
	and	a,#0x08
	jr	Z,00108$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x0B
	jp	00160$
;	genLabel
00108$:
;main.c:88: if ( kdata & 0x10 ) return 0x0d;
;	genAnd
	ld	a,c
	and	a,#0x10
	jr	Z,00110$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x0D
	jp	00160$
;	genLabel
00110$:
;main.c:90: kdata = ~KPORT0;
;	genCpl
;Z80 AOP_SFR for _KPORT0 banked:1 bc:1 de:0
	ld	a,#>_KPORT0
	in	a,(#<_KPORT0)
	cpl
	ld	b,a
;	genAssign
	ld	c,b
;main.c:91: k_CS = kdata & 1;
;	genAnd
	ld	a,c
	and	a,#0x01
	ld	b,a
;main.c:92: kdata &= ~1;
;	genAnd
	ld	a,c
	and	a,#0xFE
	ld	c,a
;main.c:93: kcode = getcode( 0, kdata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x00
	push	bc
	call	_getcode
	ld	e,l
	pop	af
	pop	bc
;	genAssign
;	(registers are the same)
;main.c:95: kdata = ~KPORT7;
;	genCpl
;Z80 AOP_SFR for _KPORT7 banked:1 bc:1 de:1
	ld	a,#>_KPORT7
	in	a,(#<_KPORT7)
	cpl
	ld	d,a
;	genAssign
	ld	c,d
;main.c:96: k_SS = kdata & 2;
;	genAnd
;	AOP_STK for _readkey_k_SS_1_1
	ld	a,c
	and	a,#0x02
	ld	-1(ix),a
;main.c:97: kdata &= ~2;
;	genAnd
	ld	a,c
	and	a,#0xFD
	ld	c,a
;main.c:98: if ( !kcode ) kcode = getcode( 7, kdata );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00112$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x07
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00112$:
;main.c:100: if ( !kcode ) kcode = getcode( 1, ~KPORT1 );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00114$
;	genCpl
;Z80 AOP_SFR for _KPORT1 banked:1 bc:1 de:0
	ld	a,#>_KPORT1
	in	a,(#<_KPORT1)
	cpl
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x01
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00114$:
;main.c:101: if ( !kcode ) kcode = getcode( 2, ~KPORT2 );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00116$
;	genCpl
;Z80 AOP_SFR for _KPORT2 banked:1 bc:1 de:0
	ld	a,#>_KPORT2
	in	a,(#<_KPORT2)
	cpl
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x02
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00116$:
;main.c:102: if ( !kcode ) kcode = getcode( 3, ~KPORT3 );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00118$
;	genCpl
;Z80 AOP_SFR for _KPORT3 banked:1 bc:1 de:0
	ld	a,#>_KPORT3
	in	a,(#<_KPORT3)
	cpl
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x03
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00118$:
;main.c:103: if ( !kcode ) kcode = getcode( 4, ~KPORT4 );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00120$
;	genCpl
;Z80 AOP_SFR for _KPORT4 banked:1 bc:1 de:0
	ld	a,#>_KPORT4
	in	a,(#<_KPORT4)
	cpl
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x04
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00120$:
;main.c:104: if ( !kcode ) kcode = getcode( 5, ~KPORT5 );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00122$
;	genCpl
;Z80 AOP_SFR for _KPORT5 banked:1 bc:1 de:0
	ld	a,#>_KPORT5
	in	a,(#<_KPORT5)
	cpl
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x05
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00122$:
;main.c:105: if ( !kcode ) kcode = getcode( 6, ~KPORT6 );
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00124$
;	genCpl
;Z80 AOP_SFR for _KPORT6 banked:1 bc:1 de:0
	ld	a,#>_KPORT6
	in	a,(#<_KPORT6)
	cpl
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	genIpush
;	genCall
	ld	b,c
	ld	c,#0x06
	push	bc
	call	_getcode
	ld	c,l
	pop	af
	pop	af
	ld	b,a
;	genAssign
	ld	e,c
;	genLabel
00124$:
;main.c:107: if ( kcode )
;	genIfx
	xor	a,a
	or	a,e
	jp	Z,00158$
;main.c:109: if ( k_CS ) kcode |= 0x40;
;	genIfx
	xor	a,a
	or	a,b
	jr	Z,00126$
;	genOr
	ld	a,e
	or	a,#0x40
	ld	e,a
;	genLabel
00126$:
;main.c:110: kcode = code_table[ kcode & 0x7f ];
;	genAnd
	ld	a,e
	and	a,#0x7F
;	genPlus
	add	a,#<_code_table
	ld	c,a
	ld	a,#>_code_table
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	l,c
	ld	h,d
	ld	c,(hl)
;	genAssign
	ld	e,c
;main.c:112: if ( k_SS )
;	genIfx
;	AOP_STK for _readkey_k_SS_1_1
	xor	a,a
	or	a,-1(ix)
	jp	Z,00155$
;main.c:114: if ( k_CS ) return 0x87;
;	genIfx
	xor	a,a
	or	a,b
	jr	Z,00152$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x87
	jp	00160$
;	genLabel
00152$:
;main.c:115: else if ( kcode == 'm' ) return '.';
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x6D
	jr	Z,00192$
	jr	00149$
00192$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x2E
	jp	00160$
;	genLabel
00149$:
;main.c:116: else if ( kcode == 'v' ) return '/';
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x76
	jr	Z,00194$
	jr	00146$
00194$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x2F
	jr	00160$
;	genLabel
00146$:
;main.c:118: else if ( kcode == 'a' ) return 0x81;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x61
	jr	Z,00196$
	jr	00143$
00196$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x81
	jr	00160$
;	genLabel
00143$:
;main.c:119: else if ( kcode == 'b' ) return 0x82;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x62
	jr	Z,00198$
	jr	00140$
00198$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x82
	jr	00160$
;	genLabel
00140$:
;main.c:120: else if ( kcode == 'c' ) return 0x83;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x63
	jr	Z,00200$
	jr	00137$
00200$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x83
	jr	00160$
;	genLabel
00137$:
;main.c:121: else if ( kcode == 'd' ) return 0x84;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x64
	jr	Z,00202$
	jr	00134$
00202$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x84
	jr	00160$
;	genLabel
00134$:
;main.c:123: else if ( kcode == 'u' ) return 0x85;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x75
	jr	Z,00204$
	jr	00131$
00204$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x85
	jr	00160$
;	genLabel
00131$:
;main.c:124: else if ( kcode == 'r' ) return 0x86;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x72
	jr	Z,00206$
	jr	00128$
00206$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x86
	jr	00160$
;	genLabel
00128$:
;main.c:125: else return 0;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x00
	jr	00160$
;	genLabel
00155$:
;main.c:127: else return kcode;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 1
;	 reg = e
	ld	l,e
	jr	00160$
;	genLabel
00158$:
;main.c:129: else return 0;
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x00
;	genLabel
00160$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_readkey_end::
;main.c:135: byte getkey()
;	genLabel
;	genFunction
;	---------------------------------
; Function getkey
; ---------------------------------
_getkey_start::
_getkey:
;main.c:139: if ( key_pushed ) i = 5000;
;	genIfx
	xor	a,a
	ld	iy,#_key_pushed
	or	a,0(iy)
	jr	Z,00102$
;	genAssign
	ld	bc,#0x1388
;	genGoto
	jr	00139$
;	genLabel
00102$:
;main.c:140: else i = 10000;
;	genAssign
	ld	bc,#0x2710
;main.c:142: while ( i != 0 )
;	genLabel
00139$:
;	genAssign
;	(registers are the same)
;	genLabel
00107$:
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00124$
;main.c:144: if (( PPORT & 0x1f ) == 0 && ( KPORT & 0x1f ) == 0x1f )
;	genAnd
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:0
	in	a,(_PPORT)
	and	a,#0x1F
	jr	Z,00156$
	jr	00105$
00156$:
;	genAnd
;Z80 AOP_SFR for _KPORT banked:1 bc:1 de:1
	ld	a,#>_KPORT
	in	a,(#<_KPORT)
	and	a,#0x1F
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	sub	a,#0x1F
	jr	Z,00158$
	jr	00105$
00158$:
;main.c:146: key_last = 0;
;	genAssign
	ld	iy,#_key_last
	ld	0(iy),#0x00
;main.c:147: break;
;	genGoto
	jr	00124$
;	genLabel
00105$:
;main.c:149: i--;
;	genMinus
	dec	bc
;	genGoto
	jr	00107$
;main.c:152: while ( true )
;	genLabel
00124$:
;main.c:154: byte kdata = readkey();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_readkey
	ld	c,l
;	genAssign
;	(registers are the same)
;main.c:157: while ( kdata != 0 && i != 0 )
;	genAssign
	ld	de,#0x0002
;	genLabel
00113$:
;	genIfx
	xor	a,a
	or	a,c
	jr	Z,00115$
;	genIfx
	ld	a,e
	or	a,d
	jr	Z,00115$
;main.c:159: if ( kdata != readkey() ) break;
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	call	_readkey
	ld	b,l
	pop	de
	ld	a,b
	pop	bc
	ld	b,a
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,c
	sub	b
	jr	Z,00160$
	jr	00115$
00160$:
;main.c:161: i--;
;	genMinus
	dec	de
;	genGoto
	jr	00113$
;	genLabel
00115$:
;main.c:164: if ( kdata && i == 0 )
;	genIfx
	xor	a,a
	or	a,c
	jr	Z,00120$
;	genIfx
	ld	a,e
;main.c:168: for ( i = 0; i < 20; i++ )
;	genAssign
	or	a,d
	jr	NZ,00120$
	ld	b,a
;	genLabel
00129$:
;	genCmpLt
	ld	a,b
	sub	a,#0x14
	jr	NC,00132$
;main.c:170: for ( j = 0; j < 2; j++ );
;	genAssign
	ld	e,#0x02
;	genLabel
00128$:
;	genMinus
	dec	e
;	genIfx
	xor	a,a
	or	a,e
	jr	NZ,00128$
;main.c:172: sound_bit ^= 0x10;
;	genXor
	ld	iy,#_sound_bit
	ld	a,0(iy)
	xor	a,#0x10
	ld	0(iy),a
;main.c:173: KPORT = sound_bit;
;	genAssign
;Z80 AOP_SFR for _KPORT banked:1 bc:1 de:0
	push	bc
	ld	a,0(iy)
	ld	bc,#_KPORT
	out	(c),a
	pop	bc
;main.c:168: for ( i = 0; i < 20; i++ )
;	genPlus
;	genPlusIncr
	inc	b
;	genGoto
	jr	00129$
;	genLabel
00132$:
;main.c:175: if ( kdata == key_last ) key_pushed = true;
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,c
	ld	iy,#_key_last
	sub	0(iy)
	jr	Z,00162$
	jr	00117$
00162$:
;	genAssign
	ld	iy,#_key_pushed
	ld	0(iy),#0x01
;	genGoto
	jr	00118$
;	genLabel
00117$:
;main.c:176: else key_pushed = false;
;	genAssign
	ld	iy,#_key_pushed
	ld	0(iy),#0x00
;	genLabel
00118$:
;main.c:178: key_last = kdata;
;	genAssign
	ld	iy,#_key_last
	ld	0(iy),c
;main.c:179: return kdata;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 1
;	 reg = c
	ld	l,c
	ret
;	genLabel
00120$:
;main.c:181: else key_last = 0;
;	genAssign
	ld	iy,#_key_last
	ld	0(iy),#0x00
;	genGoto
;	genLabel
;	genEndFunction
	jp	00124$
_getkey_end::
;main.c:185: void halt()
;	genLabel
;	genFunction
;	---------------------------------
; Function halt
; ---------------------------------
_halt_start::
_halt:
;main.c:194: __endasm;
;	genInline
	
		ld bc, #0x7ffd
		xor a
		out (c), a
		rst #0
	loop:
		jr loop
		
;	genLabel
;	genEndFunction
	ret
_halt_end::
;main.c:197: void putdig( byte b, byte col, byte row )
;	genLabel
;	genFunction
;	---------------------------------
; Function putdig
; ---------------------------------
_putdig_start::
_putdig:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;main.c:199: char d[2] = "0";
;	genAddrOf
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x30
	ld	(bc),a
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;main.c:200: if ( b < 0x0a ) d[0] = b + '0';
;	genCmpLt
;	AOP_STK for 
	ld	a,4(ix)
	sub	a,#0x0A
	jr	NC,00105$
;	genPlus
;	AOP_STK for 
;	genPlusIncr
	ld	a,4(ix)
	add	a,#0x30
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genGoto
	jr	00106$
;	genLabel
00105$:
;main.c:201: else if ( b < 0x10 ) d[0] =  'a' + b - 0x0a;
;	genCmpLt
;	AOP_STK for 
	ld	a,4(ix)
	sub	a,#0x10
	jr	NC,00102$
;	genPlus
;	AOP_STK for 
;	genPlusIncr
	ld	a,4(ix)
	add	a,#0x57
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genGoto
	jr	00106$
;	genLabel
00102$:
;main.c:202: else d[0] = '?';
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x3F
	ld	(bc),a
;	genLabel
00106$:
;main.c:203: text_out_pos_8( d, col, row, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,5(ix)
	push	af
	inc	sp
;	genIpush
	push	bc
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_putdig_end::
;main.c:206: void putbyte( byte b, byte col, byte row )
;	genLabel
;	genFunction
;	---------------------------------
; Function putbyte
; ---------------------------------
_putbyte_start::
_putbyte:
	push	ix
	ld	ix,#0
	add	ix,sp
;main.c:208: putdig( b >> 4, col, row );
;	genRightShift
;	AOP_STK for 
	ld	c,4(ix)
	srl	c
	srl	c
	srl	c
	srl	c
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,5(ix)
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genCall
	call	_putdig
	pop	af
	inc	sp
;main.c:209: putdig( b & 0x0f, col + 1, row );
;	genPlus
;	AOP_STK for 
;	genPlusIncr
	ld	c,5(ix)
	inc	c
;	genAnd
;	AOP_STK for 
	ld	a,4(ix)
	and	a,#0x0F
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genCall
	call	_putdig
	pop	af
	inc	sp
;main.c:210: text_out_pos_8( " ", col + 2, row, 0, 0xff );
;	genPlus
;	AOP_STK for 
;	genPlusIncr
	ld	c,5(ix)
	inc	c
	inc	c
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	hl,#__str_1
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	pop	ix
	ret
_putbyte_end::
__str_1:
	.ascii " "
	.db 0x00
;main.c:217: void strlwr( byte *name )
;	genLabel
;	genFunction
;	---------------------------------
; Function strlwr
; ---------------------------------
_strlwr_start::
_strlwr:
	push	ix
	ld	ix,#0
	add	ix,sp
;main.c:219: while ( *name != 0 )
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genLabel
00104$:
;	genPointerGet
	ld	a,(bc)
;	genIfx
	ld	e,a
	or	a,a
	jr	Z,00107$
;main.c:221: if ( *name >= 'A' && *name <= 'Z' ) *name += 'a' - 'A';
;	genCmpLt
	ld	a,e
	sub	a,#0x41
	jr	C,00102$
;	genCmpGt
	ld	a,#0x5A
	sub	a,e
	jr	C,00102$
;	genPlus
;	genPlusIncr
	ld	a,e
	add	a,#0x20
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genLabel
00102$:
;main.c:222: name++;
;	genPlus
;	genPlusIncr
	inc	bc
;	genGoto
	jr	00104$
;	genLabel
00107$:
;	genEndFunction
	pop	ix
	ret
_strlwr_end::
;main.c:226: void strupr( byte *name )
;	genLabel
;	genFunction
;	---------------------------------
; Function strupr
; ---------------------------------
_strupr_start::
_strupr:
	push	ix
	ld	ix,#0
	add	ix,sp
;main.c:228: while ( *name != 0 )
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genLabel
00104$:
;	genPointerGet
	ld	a,(bc)
;	genIfx
	ld	e,a
	or	a,a
	jr	Z,00107$
;main.c:230: if ( *name >= 'a' && *name <= 'z' ) *name += 'A' - 'a';
;	genCmpLt
	ld	a,e
	sub	a,#0x61
	jr	C,00102$
;	genCmpGt
	ld	a,#0x7A
	sub	a,e
	jr	C,00102$
;	genPlus
;	genPlusIncr
	ld	a,e
	add	a,#0xE0
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;	genLabel
00102$:
;main.c:231: name++;
;	genPlus
;	genPlusIncr
	inc	bc
;	genGoto
	jr	00104$
;	genLabel
00107$:
;	genEndFunction
	pop	ix
	ret
_strupr_end::
;main.c:236: void pport_send( word cmd, word size, void *buff )
;	genLabel
;	genFunction
;	---------------------------------
; Function pport_send
; ---------------------------------
_pport_send_start::
_pport_send:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;main.c:238: byte *buff_b = ( byte* ) buff;
;	genAssign
;	AOP_STK for 
	ld	c,8(ix)
	ld	b,9(ix)
;main.c:240: PPORT = cmd >> 8;
;	genRightShift
;	AOP_STK for 
	ld	e,5(ix)
	ld	d,#0x00
;	genCast
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:1
	ld	a,e
	out	(_PPORT),a
;main.c:241: PPORT = ( byte ) cmd;
;	genCast
;	AOP_STK for 
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:0
	ld	a,4(ix)
	out	(_PPORT),a
;main.c:242: PPORT = ( byte ) size;
;	genCast
;	AOP_STK for 
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:0
	ld	a,6(ix)
	out	(_PPORT),a
;main.c:243: PPORT = size >> 8;
;	genRightShift
;	AOP_STK for 
	ld	e,7(ix)
	ld	d,#0x00
;	genCast
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:1
	ld	a,e
	out	(_PPORT),a
;main.c:245: while ( size-- != 0 ) PPORT = *buff_b++;
;	genAssign
;	AOP_STK for _pport_send_buff_b_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genLabel
00101$:
;	genAssign
	ld	c,e
	ld	b,d
;	genMinus
	dec	de
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00104$
;	genPointerGet
;	AOP_STK for _pport_send_buff_b_1_1
;Z80 AOP_SFR for _PPORT banked:0 bc:0 de:1
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,(hl)
	out	(_PPORT),a
;	genPlus
;	AOP_STK for _pport_send_buff_b_1_1
;	genPlusIncr
	inc	-2(ix)
	jr	NZ,00109$
	inc	-1(ix)
00109$:
;	genGoto
	jr	00101$
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pport_send_end::
;main.c:248: void pport_send_data( void *buff, word size )
;	genLabel
;	genFunction
;	---------------------------------
; Function pport_send_data
; ---------------------------------
_pport_send_data_start::
_pport_send_data:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;main.c:250: byte *buff_b = ( byte* ) buff;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;main.c:251: while ( size-- != 0 ) PPORT = *buff_b++;
;	genAssign
;	AOP_STK for _pport_send_data_buff_b_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;	genAssign
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
;	genLabel
00101$:
;	genAssign
	ld	c,e
	ld	b,d
;	genMinus
	dec	de
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00104$
;	genPointerGet
;	AOP_STK for _pport_send_data_buff_b_1_1
;Z80 AOP_SFR for _PPORT banked:0 bc:0 de:1
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	a,(hl)
	out	(_PPORT),a
;	genPlus
;	AOP_STK for _pport_send_data_buff_b_1_1
;	genPlusIncr
	inc	-2(ix)
	jr	NZ,00109$
	inc	-1(ix)
00109$:
;	genGoto
	jr	00101$
;	genLabel
00104$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pport_send_data_end::
;main.c:254: void pport_receive( void *buff, word size )
;	genLabel
;	genFunction
;	---------------------------------
; Function pport_receive
; ---------------------------------
_pport_receive_start::
_pport_receive:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;main.c:256: byte *buff_b = ( byte* ) buff;
;	genAssign
;	(operands are equal 3)
;main.c:258: pport_result = PPORT << 8;
;	genCast
;Z80 AOP_SFR for _PPORT banked:0 bc:0 de:1
	in	a,(_PPORT)
	ld	e,a
	ld	d,#0x00
;	genLeftShift
	ld	iy,#_pport_result
	ld	1(iy),e
	ld	0(iy),#0x00
;main.c:259: pport_result |= PPORT;
;	genCast
;Z80 AOP_SFR for _PPORT banked:0 bc:0 de:1
	in	a,(_PPORT)
	ld	e,a
	ld	d,#0x00
;	genOr
	ld	a,0(iy)
	or	a,e
	ld	0(iy),a
	ld	a,1(iy)
	or	a,d
	ld	1(iy),a
;main.c:261: pport_datasize = PPORT;
;	genCast
;Z80 AOP_SFR for _PPORT banked:0 bc:0 de:0
	in	a,(_PPORT)
	ld	iy,#_pport_datasize
	ld	0(iy),a
	ld	1(iy),#0x00
;main.c:262: pport_datasize |= PPORT << 8;
;	genCast
;Z80 AOP_SFR for _PPORT banked:0 bc:0 de:1
	in	a,(_PPORT)
	ld	e,a
;	genLeftShift
	ld	d,e
	ld	e,#0x00
;	genOr
	ld	a,0(iy)
	or	a,e
	ld	0(iy),a
	ld	a,1(iy)
	or	a,d
	ld	1(iy),a
;main.c:264: pport_pktsize = pport_datasize;
;	genAssign
	ld	hl,(_pport_datasize)
	ld	iy,#_pport_pktsize
	ld	0(iy),l
	ld	1(iy),h
;main.c:266: if (( pport_result >> 8 ) == PP_ACK )
;	genRightShift
	ld	iy,#_pport_result
	ld	e,1(iy)
	ld	d,#0x00
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	a,e
	sub	a,#0x73
	jr	NZ,00116$
	or	a,d
	jr	Z,00117$
00116$:
	jr	00109$
00117$:
;main.c:268: while ( pport_datasize-- != 0 )
;	genAssign
;	AOP_STK for 
;	AOP_STK for _pport_receive_buff_b_1_1
	ld	a,4(ix)
	ld	-2(ix),a
	ld	a,5(ix)
	ld	-1(ix),a
;	genAssign
;	AOP_STK for 
	ld	c,6(ix)
	ld	b,7(ix)
;	genLabel
00104$:
;	genAssign
	ld	de,(_pport_datasize)
;	genMinus
	ld	hl,(_pport_datasize)
	dec	hl
	ld	(_pport_datasize),hl
;	genIfx
	ld	a,e
	or	a,d
	jr	Z,00109$
;main.c:270: byte c = PPORT;
;	genAssign
;Z80 AOP_SFR for _PPORT banked:0 bc:1 de:1
	in	a,(_PPORT)
	ld	e,a
;main.c:271: if ( buff != 0 && size > 0 )
;	genIfx
;	AOP_STK for 
	ld	a,4(ix)
	or	a,5(ix)
	jr	Z,00104$
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00104$
;main.c:273: *buff_b++ = c;
;	genAssign (pointer)
;	AOP_STK for _pport_receive_buff_b_1_1
;	isBitvar = 0
	ld	l,-2(ix)
	ld	h,-1(ix)
	ld	(hl),e
;	genPlus
;	AOP_STK for _pport_receive_buff_b_1_1
;	genPlusIncr
	inc	-2(ix)
	jr	NZ,00118$
	inc	-1(ix)
00118$:
;main.c:274: size--;
;	genMinus
	dec	bc
;	genGoto
	jr	00104$
;	genLabel
00109$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_pport_receive_end::
;main.c:280: void pport_open()
;	genLabel
;	genFunction
;	---------------------------------
; Function pport_open
; ---------------------------------
_pport_open_start::
_pport_open:
;main.c:282: pport_send( PP_CMD_CTL( PP_CTL_OPEN ), 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x7700
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:283: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:285: pport_good = ( pport_result == PP_W_ACK );
;	genCmpEq
; genCmpEq: left 2, right 2, result 1
;4
	ld	iy,#_pport_result
	ld	a,0(iy)
	or	a,a
	jr	NZ,00103$
	ld	a,1(iy)
	sub	a,#0x73
	jr	NZ,00103$
	ld	a,#0x01
	jr	00104$
00103$:
	xor	a,a
00104$:
;6
	ld	iy,#_pport_good
	ld	0(iy),a
;	genLabel
;	genEndFunction
	ret
_pport_open_end::
;main.c:288: void pport_close()
;	genLabel
;	genFunction
;	---------------------------------
; Function pport_close
; ---------------------------------
_pport_close_start::
_pport_close:
;main.c:290: pport_send( PP_CMD_CTL( PP_CTL_CLOSE ), 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x7701
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:291: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	ret
_pport_close_end::
;main.c:296: void print_pad_8( char *str, byte col, byte row, byte sz )
;	genLabel
;	genFunction
;	---------------------------------
; Function print_pad_8
; ---------------------------------
_print_pad_8_start::
_print_pad_8:
	push	ix
	ld	ix,#0
	add	ix,sp
;main.c:299: byte real_sz = strlen( str );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genCast
;main.c:300: text_out_pos_8( str, col, row, 0, sz );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for 
	ld	a,8(ix)
	push	af
	inc	sp
;	genIpush
	ld	a,#0x00
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,7(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	a,6(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:301: if ( real_sz < sz )
;	genCmpLt
;	AOP_STK for 
	ld	a,c
	sub	a,8(ix)
	jr	NC,00107$
;main.c:303: for ( i = real_sz; i < sz; i++ )
;	genAssign
;	(registers are the same)
;	genLabel
00103$:
;	genCmpLt
;	AOP_STK for 
	ld	a,c
	sub	a,8(ix)
	jr	NC,00107$
;main.c:305: text_out_pos_8( " ", col + i, row, 0, 1 );
;	genPlus
;	AOP_STK for 
	ld	a,6(ix)
	add	a,c
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0100
	push	hl
;	genIpush
;	AOP_STK for 
	ld	a,7(ix)
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#__str_2
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:303: for ( i = real_sz; i < sz; i++ )
;	genPlus
;	genPlusIncr
	inc	c
;	genGoto
	jr	00103$
;	genLabel
00107$:
;	genEndFunction
	pop	ix
	ret
_print_pad_8_end::
__str_2:
	.ascii " "
	.db 0x00
;main.c:310: void display_path( char *str, int col, int row, int max_sz )
;	genLabel
;	genFunction
;	---------------------------------
; Function display_path
; ---------------------------------
_display_path_start::
_display_path:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-38
	add	hl,sp
	ld	sp,hl
;main.c:312: byte path_buff[0x20] = "/";
;	genAddrOf
;	AOP_STK for _display_path_sloc1_1_0
	ld	hl,#0x0006
	add	hl,sp
	ld	-38(ix),l
	ld	-37(ix),h
;	genAssign (pointer)
;	AOP_STK for _display_path_sloc1_1_0
;	isBitvar = 0
	ld	l,-38(ix)
	ld	h,-37(ix)
	ld	(hl),#0x2F
;	genPlus
;	AOP_STK for _display_path_sloc1_1_0
;	genPlusIncr
	ld	e,-38(ix)
	ld	d,-37(ix)
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;main.c:313: byte *path_short = str;
;	genAssign
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,5(ix)
;	genAssign
;	AOP_STK for _display_path_path_short_1_1
	ld	-34(ix),c
	ld	-33(ix),b
;main.c:315: if ( strlen( str ) > max_sz )
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
;	genCmpGt
;	AOP_STK for 
	ld	a,10(ix)
	sub	a,e
	ld	a,11(ix)
	sbc	a,d
	jp	P,00108$
;main.c:317: while ( strlen( path_short ) > ( max_sz - 2 ) )
;	genMinus
;	AOP_STK for 
;	AOP_STK for _display_path_sloc0_1_0
	ld	a,10(ix)
	add	a,#0xFE
	ld	-36(ix),a
	ld	a,11(ix)
	adc	a,#0xFF
	ld	-35(ix),a
;	genLabel
00104$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _display_path_path_short_1_1
	ld	l,-34(ix)
	ld	h,-33(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
;	genCmpGt
;	AOP_STK for _display_path_sloc0_1_0
	ld	a,-36(ix)
	sub	a,e
	ld	a,-35(ix)
	sbc	a,d
	jp	P,00106$
;main.c:319: path_short++;
;	genPlus
;	AOP_STK for _display_path_path_short_1_1
;	genPlusIncr
	inc	-34(ix)
	jr	NZ,00115$
	inc	-33(ix)
00115$:
;main.c:320: while ( *path_short != '/' ) path_short++;
;	genAssign
;	AOP_STK for _display_path_path_short_1_1
	ld	e,-34(ix)
	ld	d,-33(ix)
;	genLabel
00101$:
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	c,a
	sub	a,#0x2F
	jr	Z,00104$
;	genPlus
;	genPlusIncr
	inc	de
;	genAssign
;	AOP_STK for _display_path_path_short_1_1
	ld	-34(ix),e
	ld	-33(ix),d
;	genGoto
	jr	00101$
;	genLabel
00106$:
;main.c:323: strcpy( path_buff, "..." );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_4
	push	hl
;	genIpush
;	AOP_STK for _display_path_sloc1_1_0
	ld	l,-38(ix)
	ld	h,-37(ix)
	push	hl
;	genCall
	call	_strcpy
	pop	af
	pop	af
;	genLabel
00108$:
;main.c:326: strcat( path_buff, path_short );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _display_path_path_short_1_1
	ld	l,-34(ix)
	ld	h,-33(ix)
	push	hl
;	genIpush
;	AOP_STK for _display_path_sloc1_1_0
	ld	l,-38(ix)
	ld	h,-37(ix)
	push	hl
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:327: print_pad_8( path_buff, col, row, max_sz );
;	genCast
;	AOP_STK for 
	ld	c,10(ix)
;	genCast
;	AOP_STK for 
	ld	b,8(ix)
;	genCast
;	AOP_STK for 
;	AOP_STK for _display_path_sloc1_1_0
	ld	a,6(ix)
	ld	-38(ix),a
;	genAddrOf
	ld	hl,#0x0006
	add	hl,sp
	ld	d,l
	ld	e,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,c
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
;	AOP_STK for _display_path_sloc1_1_0
	ld	a,-38(ix)
	push	af
	inc	sp
;	genIpush
	ld	l,d
	ld	h,e
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_display_path_end::
__str_4:
	.ascii "..."
	.db 0x00
;main.c:331: void show_table()
;	genLabel
;	genFunction
;	---------------------------------
; Function show_table
; ---------------------------------
_show_table_start::
_show_table:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-23
	add	hl,sp
	ld	sp,hl
;main.c:334: text_out_pos_8( "> ", 0, 1, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0100
	push	hl
;	genIpush
	ld	hl,#__str_5
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:335: display_path( path, 1, 1, 28 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x001C
	push	hl
;	genIpush
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	hl,#_path
	push	hl
;	genCall
	call	_display_path
	pop	af
	pop	af
	pop	af
	pop	af
;main.c:336: for ( i = 0; i < FILES_PER_ROW*2; i++ )
;	genAssign
;	AOP_STK for _show_table_i_1_1
	ld	-1(ix),#0x00
;	genLabel
00118$:
;	genCmpLt
;	AOP_STK for _show_table_i_1_1
	ld	a,-1(ix)
	sub	a,#0x20
	jp	NC,00121$
;main.c:338: int col = ( i / FILES_PER_ROW ) * 16 + 2;
;	genRightShift
;	AOP_STK for _show_table_i_1_1
	ld	b,-1(ix)
	srl	b
	srl	b
	srl	b
	srl	b
;	genCast
	ld	e,#0x00
;	genLeftShift
	sla	b
	rl	e
	sla	b
	rl	e
	sla	b
	rl	e
	sla	b
	rl	e
;	genPlus
;	AOP_STK for _show_table_col_2_2
;	genPlusIncr
	ld	a,b
	add	a,#0x02
	ld	-3(ix),a
	ld	a,e
	adc	a,#0x00
	ld	-2(ix),a
;main.c:339: int row = ( i % FILES_PER_ROW ) + 3;
;	genAnd
;	AOP_STK for _show_table_i_1_1
	ld	a,-1(ix)
	and	a,#0x0F
	ld	b,a
;	genCast
	ld	c,#0x00
;	genPlus
;	AOP_STK for _show_table_row_2_2
;	genPlusIncr
	ld	a,b
	add	a,#0x03
	ld	-5(ix),a
	ld	a,c
	adc	a,#0x00
	ld	-4(ix),a
;main.c:340: int pos = i + files_table_start;
;	genCast
;	AOP_STK for _show_table_i_1_1
	ld	c,-1(ix)
	ld	b,#0x00
;	genPlus
;	Shift into pair idx 0
	ld	hl,#_files_table_start
	ld	a,c
	add	a,(hl)
	ld	c,a
	ld	a,b
	inc	hl
	adc	a,(hl)
	ld	b,a
;	genAssign
;	AOP_STK for _show_table_pos_2_2
	ld	-7(ix),c
	ld	-6(ix),b
;main.c:342: if ( pos < files_size )
;	genCmpLt
;	AOP_STK for _show_table_pos_2_2
	ld	a,-7(ix)
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	a,-6(ix)
	sbc	a,1(iy)
	jp	P,00106$
;main.c:346: for ( len = 0; files[pos].name[len] && files[pos].name[len] != '.'; len++ );
;	genMult
;	AOP_STK for _show_table_pos_2_2
	ld	e,-7(ix)
	ld	d,-6(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	c,l
	ld	b,h
;	genPlus
	ld	hl,#_files
	add	hl,bc
	ld	c,l
	ld	b,h
;	genPlus
;	genPlusIncr
	inc	bc
;	genAssign
;	AOP_STK for _show_table_len_3_3
	ld	-8(ix),#0x00
;	genLabel
00114$:
;	genPlus
;	AOP_STK for _show_table_len_3_3
	ld	a,c
	add	a,-8(ix)
	ld	d,a
	ld	a,b
	adc	a,#0x00
	ld	e,a
;	genPointerGet
	ld	l,d
	ld	h,e
	ld	e,(hl)
;	genIfx
	xor	a,a
	or	a,e
	jr	Z,00137$
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x2E
	jr	Z,00137$
;	genPlus
;	AOP_STK for _show_table_len_3_3
;	genPlusIncr
	inc	-8(ix)
;	genGoto
	jr	00114$
;	genLabel
00137$:
;	genAssign
;	AOP_STK for _show_table_len_3_3
;	AOP_STK for _show_table_sloc1_1_0
	ld	a,-8(ix)
	ld	-21(ix),a
;main.c:347: if ( files[pos].name[len] && files[pos].name[0] != '.' )
;	genMult
;	AOP_STK for _show_table_pos_2_2
	ld	e,-7(ix)
	ld	d,-6(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	e,l
	ld	d,h
;	genPlus
;	AOP_STK for _show_table_sloc0_1_0
	ld	hl,#_files
	add	hl,de
	ld	-20(ix),l
	ld	-19(ix),h
;	genPlus
;	AOP_STK for _show_table_sloc0_1_0
;	genPlusIncr
	ld	a,-20(ix)
	add	a,#0x01
	ld	b,a
	ld	a,-19(ix)
	adc	a,#0x00
	ld	c,a
;	genPlus
;	AOP_STK for _show_table_len_3_3
	ld	a,b
	add	a,-8(ix)
	ld	b,a
	ld	a,c
	adc	a,#0x00
	ld	c,a
;	genPointerGet
	ld	l,b
	ld	h,c
	ld	a,(hl)
;	genIfx
	or	a,a
	jp	Z,00102$
;	genPlus
;	AOP_STK for _show_table_sloc0_1_0
;	genPlusIncr
	ld	c,-20(ix)
	ld	b,-19(ix)
	inc	bc
;	genPointerGet
	ld	a,(bc)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	c,a
	sub	a,#0x2E
	jp	Z,00102$
;main.c:350: byte fnlen = len > 8 ? 8 : len;
;	genCmpGt
;	AOP_STK for _show_table_len_3_3
	ld	a,#0x08
	sub	a,-8(ix)
	jr	NC,00124$
;	genAssign
	ld	c,#0x08
;	genGoto
	jr	00125$
;	genLabel
00124$:
;	genAssign
;	AOP_STK for _show_table_len_3_3
	ld	c,-8(ix)
;	genLabel
00125$:
;	genAssign
;	AOP_STK for _show_table_fnlen_4_4
	ld	-18(ix),c
;main.c:351: memcpy( fn, files[pos].name, fnlen );
;	genCast
;	AOP_STK for _show_table_fnlen_4_4
;	AOP_STK for _show_table_sloc0_1_0
	ld	a,-18(ix)
	ld	-20(ix),a
	ld	-19(ix),#0x00
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	c,l
	ld	b,h
;	genPlus
;	AOP_STK for _show_table_sloc2_1_0
;	genPlusIncr
	ld	a,c
	add	a,#0x01
	ld	-23(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-22(ix),a
;	genAddrOf
	ld	hl,#0x0006
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
;	AOP_STK for _show_table_sloc0_1_0
	ld	l,-20(ix)
	ld	h,-19(ix)
	push	hl
;	genIpush
;	AOP_STK for _show_table_sloc2_1_0
	ld	l,-23(ix)
	ld	h,-22(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_memcpy
	pop	af
	pop	af
	pop	af
	pop	de
;main.c:352: fn[fnlen] = 0;
;	genAddrOf
;	AOP_STK for _show_table_sloc2_1_0
	ld	hl,#0x0006
	add	hl,sp
	ld	-23(ix),l
	ld	-22(ix),h
;	genPlus
;	AOP_STK for _show_table_sloc2_1_0
;	AOP_STK for _show_table_fnlen_4_4
	ld	a,-23(ix)
	add	a,-18(ix)
	ld	c,a
	ld	a,-22(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;main.c:353: print_pad_8( fn, col, row, 8 );
;	genCast
;	AOP_STK for _show_table_row_2_2
;	AOP_STK for _show_table_sloc0_1_0
	ld	a,-5(ix)
	ld	-20(ix),a
;	genCast
;	AOP_STK for _show_table_col_2_2
	ld	b,-3(ix)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	a,#0x08
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _show_table_sloc0_1_0
	ld	a,-20(ix)
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
;	AOP_STK for _show_table_sloc2_1_0
	ld	l,-23(ix)
	ld	h,-22(ix)
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
	pop	de
;main.c:354: print_pad_8( files[pos].name + len, col + 8, row, 4 );
;	genCast
;	AOP_STK for _show_table_col_2_2
	ld	b,-3(ix)
;	genPlus
;	AOP_STK for _show_table_sloc2_1_0
;	genPlusIncr
	ld	a,b
	add	a,#0x08
	ld	-23(ix),a
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	b,l
	ld	c,h
;	genPlus
;	genPlusIncr
	inc	b
	jr	NZ,00143$
	inc	c
00143$:
;	genPlus
;	AOP_STK for _show_table_sloc1_1_0
	ld	a,b
	add	a,-21(ix)
	ld	b,a
	ld	a,c
	adc	a,#0x00
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x04
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _show_table_sloc0_1_0
	ld	a,-20(ix)
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _show_table_sloc2_1_0
	ld	a,-23(ix)
	push	af
	inc	sp
;	genIpush
	ld	l,b
	ld	h,c
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genGoto
	jp	00120$
;	genLabel
00102$:
;main.c:358: print_pad_8( files[pos].name, col, row, 8 );
;	genCast
;	AOP_STK for _show_table_row_2_2
	ld	c,-5(ix)
;	genCast
;	AOP_STK for _show_table_col_2_2
	ld	b,-3(ix)
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	e,l
	ld	d,h
;	genPlus
;	genPlusIncr
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,#0x08
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	push	de
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
	pop	bc
;main.c:359: print_pad_8( "", col + 8, row, 4 );
;	genCast
;	AOP_STK for _show_table_col_2_2
	ld	b,-3(ix)
;	genPlus
;	genPlusIncr
	ld	a,b
	add	a,#0x08
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x04
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#__str_6
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genGoto
	jr	00120$
;	genLabel
00106$:
;main.c:364: print_pad_8( "", col, row, 12 );
;	genCast
;	AOP_STK for _show_table_row_2_2
	ld	c,-5(ix)
;	genCast
;	AOP_STK for _show_table_col_2_2
	ld	b,-3(ix)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x0C
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#__str_6
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genLabel
00120$:
;main.c:336: for ( i = 0; i < FILES_PER_ROW*2; i++ )
;	genPlus
;	AOP_STK for _show_table_i_1_1
;	genPlusIncr
	inc	-1(ix)
;	genGoto
	jp	00118$
;	genLabel
00121$:
;main.c:367: if ( !files_size )
;	genIfx
	ld	iy,#_files_size
	ld	a,0(iy)
	or	a,1(iy)
	jr	NZ,00122$
;main.c:369: if ( !pport_good )
;	genIfx
	xor	a,a
	ld	iy,#_pport_good
	or	a,0(iy)
	jr	NZ,00109$
;main.c:371: text_out_pos_8( "SD error !", 10, 4, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x040A
	push	hl
;	genIpush
	ld	hl,#__str_7
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:372: set_attr( 0302, 10, 4, 10 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0A04
	push	hl
;	genIpush
	ld	hl,#0x0AC2
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genGoto
	jr	00122$
;	genLabel
00109$:
;main.c:376: text_out_pos_8( "no files !", 10, 4, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x040A
	push	hl
;	genIpush
	ld	hl,#__str_8
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:377: set_attr( 0102, 10, 4, 10 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0A04
	push	hl
;	genIpush
	ld	hl,#0x0A42
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genLabel
00122$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_show_table_end::
__str_5:
	.ascii "> "
	.db 0x00
__str_6:
	.db 0x00
__str_7:
	.ascii "SD error !"
	.db 0x00
__str_8:
	.ascii "no files !"
	.db 0x00
;main.c:384: byte comp_name( int a, int b )
;	genLabel
;	genFunction
;	---------------------------------
; Function comp_name
; ---------------------------------
_comp_name_start::
_comp_name:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-1
	add	hl,sp
	ld	sp,hl
;main.c:386: if (( files[a].attr & AM_DIR ) && !( files[b].attr & AM_DIR ) ) return true;
;	genMult
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	c,l
	ld	b,h
;	genPlus
	ld	hl,#_files
	add	hl,bc
	ld	e,l
	ld	d,h
;	genPointerGet
	ld	a,(de)
;	genAnd
;	AOP_STK for _comp_name_sloc0_1_0
	ld	e,a
	and	a,#0x10
;	genIfx
;	AOP_STK for _comp_name_sloc0_1_0
	ld	-1(ix),a
	or	a,a
	jr	Z,00106$
;	genMult
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	d,l
	ld	e,h
;	genPlus
	ld	a,#<_files
	add	a,d
	ld	d,a
	ld	a,#>_files
	adc	a,e
	ld	e,a
;	genPointerGet
	ld	l,d
	ld	h,e
	ld	d,(hl)
;	genAnd
	ld	a,d
	and	a,#0x10
	jr	Z,00116$
	jr	00106$
00116$:
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x01
	jp	00109$
;	genLabel
00106$:
;main.c:387: else if ( !( files[a].attr & AM_DIR ) && ( files[b].attr & AM_DIR ) ) return false;
;	genIfx
;	AOP_STK for _comp_name_sloc0_1_0
	xor	a,a
	or	a,-1(ix)
	jr	NZ,00102$
;	genMult
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	e,l
	ld	d,h
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	e,l
	ld	d,h
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x10
	jr	Z,00102$
;	genRet
; Dump of IC_LEFT: type AOP_LIT size 1
	ld	l,#0x00
	jr	00109$
;	genLabel
00102$:
;main.c:388: else return strcmp( files[a].name, files[b].name ) <= 0;
;	genMult
;	AOP_STK for 
	ld	e,6(ix)
	ld	d,7(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	e,l
	ld	d,h
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	e,l
	ld	d,h
;	genPlus
;	genPlusIncr
	inc	de
;	genPlus
	ld	hl,#_files
	add	hl,bc
	ld	c,l
	ld	b,h
;	genPlus
;	genPlusIncr
	inc	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
	push	bc
;	genCall
	call	_strcmp
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genCmpGt
	ld	a,#0x00
	sub	a,c
	ld	a,#0x00
	sbc	a,b
	rlca
	and	a,#0x01
;	genNot
	ld	c,a
	or	a,a
	sub	a,#0x01
	ld	a,#0x00
	rla
	ld	l,a
;	genRet
; Dump of IC_LEFT: type AOP_STR size 1
;	genLabel
00109$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_comp_name_end::
;main.c:391: void swap_name( int a, int b )
;	genLabel
;	genFunction
;	---------------------------------
; Function swap_name
; ---------------------------------
_swap_name_start::
_swap_name:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-16
	add	hl,sp
	ld	sp,hl
;main.c:395: memcpy( &temp, &files[a], sizeof( struct FRECORD ) );
;	genMult
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	c,l
	ld	b,h
;	genPlus
;	AOP_STK for _swap_name_sloc0_1_0
	ld	hl,#_files
	add	hl,bc
	ld	-16(ix),l
	ld	-15(ix),h
;	genAddrOf
	ld	hl,#0x0002
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x000E
	push	hl
;	genIpush
;	AOP_STK for _swap_name_sloc0_1_0
	ld	l,-16(ix)
	ld	h,-15(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_memcpy
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:396: memcpy( &files[a], &files[b], sizeof( struct FRECORD ) );
;	genMult
;	AOP_STK for 
;	AOP_STK for _swap_name_sloc0_1_0
	ld	e,6(ix)
	ld	d,7(ix)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	-16(ix),l
	ld	-15(ix),h
;	genPlus
;	AOP_STK for _swap_name_sloc0_1_0
	ld	a,#<_files
	add	a,-16(ix)
	ld	e,a
	ld	a,#>_files
	adc	a,-15(ix)
	ld	d,a
;	genPlus
	ld	hl,#_files
	add	hl,bc
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x000E
	push	hl
;	genIpush
	push	de
;	genIpush
	push	bc
;	genCall
	call	_memcpy
	pop	af
	pop	af
	pop	af
;main.c:397: memcpy( &files[b], &temp,  sizeof( struct FRECORD ) );
;	genAddrOf
	ld	hl,#0x0002
	add	hl,sp
	ld	c,l
	ld	b,h
;	genPlus
;	AOP_STK for _swap_name_sloc0_1_0
	ld	a,#<_files
	add	a,-16(ix)
	ld	e,a
	ld	a,#>_files
	adc	a,-15(ix)
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x000E
	push	hl
;	genIpush
	push	bc
;	genIpush
	push	de
;	genCall
	call	_memcpy
	pop	af
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_swap_name_end::
;main.c:400: void qsort( int l, int h )
;	genLabel
;	genFunction
;	---------------------------------
; Function qsort
; ---------------------------------
_qsort_start::
_qsort:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;main.c:402: int i = l;
;	genAssign
;	AOP_STK for 
	ld	e,4(ix)
	ld	d,5(ix)
;main.c:403: int j = h;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _qsort_j_1_1
	ld	a,6(ix)
	ld	-2(ix),a
	ld	a,7(ix)
	ld	-1(ix),a
;main.c:405: int k = ( l + h ) / 2;
;	genPlus
;	AOP_STK for _qsort_j_1_1
	ld	a,e
	add	a,-2(ix)
	ld	c,a
	ld	a,d
	adc	a,-1(ix)
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0002
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__divsint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	de
;	genAssign
;	AOP_STK for _qsort_k_1_1
	ld	-4(ix),c
	ld	-3(ix),b
;main.c:409: while ( i < k && comp_name( i, k ) ) i++;
;	genAssign
;	AOP_STK for _qsort_sloc0_1_0
	ld	-6(ix),e
	ld	-5(ix),d
;	genLabel
00102$:
;	genCmpLt
;	AOP_STK for _qsort_sloc0_1_0
;	AOP_STK for _qsort_k_1_1
	ld	a,-6(ix)
	sub	a,-4(ix)
	ld	a,-5(ix)
	sbc	a,-3(ix)
	jp	P,00130$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _qsort_k_1_1
	ld	l,-4(ix)
	ld	h,-3(ix)
	push	hl
;	genIpush
;	AOP_STK for _qsort_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	push	hl
;	genCall
	call	_comp_name
	ld	c,l
	pop	af
	pop	af
;	genIfx
	xor	a,a
	or	a,c
	jr	Z,00130$
;	genPlus
;	AOP_STK for _qsort_sloc0_1_0
;	genPlusIncr
	inc	-6(ix)
	jr	NZ,00138$
	inc	-5(ix)
00138$:
;	genGoto
	jr	00102$
;main.c:410: while ( j > k && comp_name( k, j ) ) j--;
;	genLabel
00130$:
;	genAssign
;	AOP_STK for _qsort_j_1_1
	ld	c,-2(ix)
	ld	b,-1(ix)
;	genLabel
00106$:
;	genCmpGt
;	AOP_STK for _qsort_k_1_1
	ld	a,-4(ix)
	sub	a,c
	ld	a,-3(ix)
	sbc	a,b
	jp	P,00136$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genIpush
;	AOP_STK for _qsort_k_1_1
	ld	l,-4(ix)
	ld	h,-3(ix)
	push	hl
;	genCall
	call	_comp_name
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genIfx
	xor	a,a
	or	a,e
	jr	Z,00136$
;	genMinus
	dec	bc
;	genAssign
;	AOP_STK for _qsort_j_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;	genGoto
	jr	00106$
;	genLabel
00136$:
;	genAssign
;	AOP_STK for _qsort_j_1_1
	ld	-2(ix),c
	ld	-1(ix),b
;main.c:412: if ( i == j ) break;
;	genCmpEq
;	AOP_STK for _qsort_sloc0_1_0
; genCmpEq: left 2, right 2, result 0
	ld	a,-6(ix)
	sub	c
	jr	NZ,00139$
	ld	a,-5(ix)
	sub	b
	jr	Z,00118$
00139$:
;main.c:413: swap_name( i, j );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
;	genIpush
;	AOP_STK for _qsort_sloc0_1_0
	ld	l,-6(ix)
	ld	h,-5(ix)
	push	hl
;	genCall
	call	_swap_name
	pop	af
	pop	af
	pop	bc
;main.c:415: if ( i == k ) k = j;
;	genCmpEq
;	AOP_STK for _qsort_sloc0_1_0
;	AOP_STK for _qsort_k_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-6(ix)
	sub	-4(ix)
	jr	NZ,00140$
	ld	a,-5(ix)
	sub	-3(ix)
	jr	Z,00141$
00140$:
	jr	00114$
00141$:
;	genAssign
;	AOP_STK for _qsort_k_1_1
	ld	-4(ix),c
	ld	-3(ix),b
;	genGoto
	jp	00102$
;	genLabel
00114$:
;main.c:416: else if ( j == k ) k = i;
;	genCmpEq
;	AOP_STK for _qsort_k_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	sub	-4(ix)
	jr	NZ,00142$
	ld	a,b
	sub	-3(ix)
	jr	Z,00143$
00142$:
	jp	00102$
00143$:
;	genAssign
;	AOP_STK for _qsort_sloc0_1_0
;	AOP_STK for _qsort_k_1_1
	ld	a,-6(ix)
	ld	-4(ix),a
	ld	a,-5(ix)
	ld	-3(ix),a
;	genGoto
	jp	00102$
;	genLabel
00118$:
;main.c:419: if ( l < k - 1 ) qsort( l, k - 1 );
;	genMinus
;	AOP_STK for _qsort_k_1_1
	ld	c,-4(ix)
	ld	b,-3(ix)
	dec	bc
;	genCmpLt
;	AOP_STK for 
	ld	a,4(ix)
	sub	a,c
	ld	a,5(ix)
	sbc	a,b
	jp	P,00120$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_qsort
	pop	af
	pop	af
;	genLabel
00120$:
;main.c:420: if ( k + 1 < h ) qsort( k + 1, h );
;	genPlus
;	AOP_STK for _qsort_k_1_1
;	genPlusIncr
	ld	c,-4(ix)
	ld	b,-3(ix)
	inc	bc
;	genCmpLt
;	AOP_STK for 
	ld	a,c
	sub	a,6(ix)
	ld	a,b
	sbc	a,7(ix)
	jp	P,00123$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_qsort
	pop	af
	pop	af
;	genLabel
00123$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_qsort_end::
;main.c:423: void read_dir()
;	genLabel
;	genFunction
;	---------------------------------
; Function read_dir
; ---------------------------------
_read_dir_start::
_read_dir:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-23
	add	hl,sp
	ld	sp,hl
;main.c:425: files_size = 0;
;	genAssign
	ld	iy,#_files_size
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;main.c:426: files_table_start = 0;
;	genAssign
	ld	iy,#_files_table_start
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;main.c:427: files_sel = 0;
;	genAssign
	ld	iy,#_files_sel
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;main.c:429: if ( pport_good )
;	genIfx
	xor	a,a
	ld	iy,#_pport_good
	or	a,0(iy)
	jp	Z,00119$
;main.c:431: if( strlen( path ) == 0 )
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jr	NZ,00102$
;main.c:433: pport_send( PP_CMD_FCTL( PP_FCTL_DIR ), strlen( path ), path );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genIpush
	push	bc
;	genIpush
	ld	hl,#0x7800
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:434: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;	genGoto
	jp	00130$
;	genLabel
00102$:
;main.c:438: pport_send( PP_CMD_FCTL( PP_FCTL_DIR ), strlen( path ) - 1, path );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genMinus
	dec	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genIpush
	push	bc
;	genIpush
	ld	hl,#0x7800
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:439: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:441: files[ files_size ].attr = AM_DIR;
;	genMult
	ld	de,(_files_size)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	c,l
	ld	b,h
;	genPlus
	ld	hl,#_files
	add	hl,bc
	ld	e,l
	ld	d,h
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x10
	ld	(de),a
;main.c:442: strcpy( files[ files_size ].name, ".." );
;	genPlus
	ld	hl,#_files
	add	hl,bc
	ld	c,l
	ld	b,h
;	genPlus
;	genPlusIncr
	inc	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_9
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:443: files_size++;
;	genPlus
;	genPlusIncr
	ld	iy,#_files_size
	inc	0(iy)
	jr	NZ,00134$
	inc	1(iy)
00134$:
;main.c:446: while ( true )
;	genLabel
00130$:
;	genLabel
00116$:
;main.c:450: pport_send( PP_CMD_FCTL( PP_FCTL_RDIR ), 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x7801
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:451: pport_receive( &fi, sizeof( fi ) );
;	genAddrOf
	ld	hl,#0x0001
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0016
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:453: if ( files_size == FILES_SIZE ) break;
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_files_size
	ld	a,0(iy)
	or	a,a
	jr	NZ,00135$
	ld	a,1(iy)
	sub	a,#0x04
	jp	Z,00120$
00135$:
;main.c:454: if ( pport_result != PP_W_ACK ) break;
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_pport_result
	ld	a,0(iy)
	or	a,a
	jr	NZ,00136$
	ld	a,1(iy)
	sub	a,#0x73
	jr	Z,00137$
00136$:
	jp	00120$
00137$:
;main.c:455: if ( fi.fname[0] == 0 ) break;
;	genAddrOf
	ld	hl,#0x0001
	add	hl,sp
	ld	c,l
	ld	b,h
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x09
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genPointerGet
	ld	a,(de)
;	genIfx
	or	a,a
	jp	Z,00120$
;main.c:456: if ( fi.fattrib & ( AM_HID | AM_SYS ) ) continue;
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x08
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genPointerGet
;	AOP_STK for _read_dir_sloc0_1_0
	ld	a,(de)
	ld	-23(ix),a
;	genAnd
;	AOP_STK for _read_dir_sloc0_1_0
	ld	a,-23(ix)
	and	a,#0x06
	jr	Z,00139$
	jp	00116$
00139$:
;main.c:458: files[ files_size ].attr = fi.fattrib;
;	genMult
	ld	de,(_files_size)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	d,l
	ld	e,h
;	genPlus
	ld	a,#<_files
	add	a,d
	ld	d,a
	ld	a,#>_files
	adc	a,e
	ld	e,a
;	genAssign (pointer)
;	AOP_STK for _read_dir_sloc0_1_0
;	isBitvar = 0
	ld	l,d
	ld	h,e
	ld	a,-23(ix)
	ld	(hl),a
;main.c:459: if ( fi.fattrib & ( AM_DIR ) ) strupr( fi.fname );
;	genAnd
;	AOP_STK for _read_dir_sloc0_1_0
	ld	a,-23(ix)
	and	a,#0x10
	jr	Z,00113$
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x09
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genCall
	call	_strupr
	pop	af
;	genGoto
	jr	00114$
;	genLabel
00113$:
;main.c:460: else strlwr( fi.fname );
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x09
	ld	c,a
	ld	a,b
	adc	a,#0x00
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_strlwr
	pop	af
;	genLabel
00114$:
;main.c:461: strcpy( files[ files_size ].name, fi.fname );
;	genAddrOf
	ld	hl,#0x0001
	add	hl,sp
	ld	c,l
	ld	b,h
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x09
	ld	c,a
	ld	a,b
	adc	a,#0x00
	ld	b,a
;	genMult
	ld	de,(_files_size)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	e,l
	ld	d,h
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	e,l
	ld	d,h
;	genPlus
;	genPlusIncr
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:463: files_size++;
;	genPlus
;	genPlusIncr
	ld	iy,#_files_size
	inc	0(iy)
	jr	NZ,00141$
	inc	1(iy)
00141$:
;	genGoto
	jp	00116$
;	genLabel
00119$:
;main.c:468: files_size = 0;
;	genAssign
	ld	iy,#_files_size
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;	genLabel
00120$:
;main.c:471: if ( files_size )
;	genIfx
	ld	iy,#_files_size
	ld	a,0(iy)
	or	a,1(iy)
	jr	Z,00123$
;main.c:473: qsort( 0, files_size - 1 );
;	genMinus
	ld	c,0(iy)
	ld	b,1(iy)
	dec	bc
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_qsort
	pop	af
	pop	af
;	genLabel
00123$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_read_dir_end::
__str_9:
	.ascii ".."
	.db 0x00
;main.c:479: void clrscr()
;	genLabel
;	genFunction
;	---------------------------------
; Function clrscr
; ---------------------------------
_clrscr_start::
_clrscr:
;main.c:499: __endasm;
;	genInline
	
		di
		ld hl, #0x4000
		push hl
		pop de
		inc de
		xor a
		ld( hl ), a
		ld bc, #0x1800
		ldir
		inc hl
		inc de
		ld a, #7
		ld( hl ), a
		ld bc, #0x300
		ldir
		xor a
		out( 0xfe ), a
		
;	genLabel
;	genEndFunction
	ret
_clrscr_end::
;main.c:507: int yes_or_no( char *prompt )
;	genLabel
;	genFunction
;	---------------------------------
; Function yes_or_no
; ---------------------------------
_yes_or_no_start::
_yes_or_no:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-5
	add	hl,sp
	ld	sp,hl
;main.c:512: byte sz = strlen( prompt );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genCast
;main.c:513: if ( sz & 1 ) sz += 1;
;	genAnd
	ld	a,c
	and	a,#0x01
	jr	Z,00102$
;	genPlus
;	genPlusIncr
	inc	c
;	genLabel
00102$:
;main.c:514: if ( sz < 18 ) sz = 18;
;	genCmpLt
	ld	a,c
	sub	a,#0x12
	jr	NC,00104$
;	genAssign
	ld	c,#0x12
;	genLabel
00104$:
;main.c:515: sz += 4;
;	genPlus
;	genPlusIncr
	inc	c
	inc	c
	inc	c
	inc	c
;main.c:517: for ( i = 0; i < 6; i++ )
;	genAssign
;	AOP_STK for _yes_or_no_i_1_1
	ld	-1(ix),#0x00
;	genLabel
00125$:
;	genCmpLt
;	AOP_STK for _yes_or_no_i_1_1
	ld	a,-1(ix)
	sub	a,#0x06
	jp	NC,00128$
;main.c:519: set_attr( 050, ( 32 - sz ) / 2, top + i, sz );
;	genPlus
;	AOP_STK for _yes_or_no_i_1_1
;	genPlusIncr
	ld	a,-1(ix)
	add	a,#0x07
	ld	e,a
;	genCast
	ld	d,c
	ld	b,#0x00
;	genMinus
	ld	a,#0x20
	sub	a,d
	ld	d,a
	ld	a,#0x00
	sbc	a,b
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	hl,#0x0002
	push	hl
;	genIpush
	ld	l,d
	ld	h,b
	push	hl
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	b,l
	pop	af
	pop	af
	ld	a,d
	pop	de
	ld	d,a
	ld	a,b
	pop	bc
	ld	b,a
;	genCast
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	a,#0x28
	push	af
	inc	sp
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	de
	pop	bc
;main.c:520: print_pad_8( "", ( 32 - sz ) / 2, top + i, sz );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#__str_10
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
	pop	bc
;main.c:517: for ( i = 0; i < 6; i++ )
;	genPlus
;	AOP_STK for _yes_or_no_i_1_1
;	genPlusIncr
	inc	-1(ix)
;	genGoto
	jp	00125$
;	genLabel
00128$:
;main.c:523: text_out_pos_8( "-= Confirmation =-", 7, top, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0707
	push	hl
;	genIpush
	ld	hl,#__str_11
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:524: text_out_pos_8( prompt, ( 32 - strlen( prompt ) ) / 2, top + 2, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genMinus
	ld	a,#0x20
	sub	a,e
	ld	e,a
	ld	a,#0x00
	sbc	a,d
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0002
	push	hl
;	genIpush
	push	de
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
	ld	b,e
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	a,#0x09
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:525: set_attr( 052, ( 32 - strlen( prompt ) ) / 2, top + 2, strlen( prompt ) );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genCast
	ld	b,e
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genMinus
	ld	a,#0x20
	sub	a,e
	ld	e,a
	ld	a,#0x00
	sbc	a,d
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0002
	push	hl
;	genIpush
	push	de
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	bc
	inc	sp
;	genIpush
	ld	a,#0x09
	push	af
	inc	sp
;	genIpush
;	genIpush
;	genCall
	ld	d,e
	ld	e,#0x2A
	push	de
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;main.c:527: text_out_pos_8( "Yes", 10, top + 4, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0B0A
	push	hl
;	genIpush
	ld	hl,#__str_12
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:528: set_attr( 017, 9, top + 4, 5 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x050B
	push	hl
;	genIpush
	ld	hl,#0x090F
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;main.c:529: text_out_pos_8( "No", 20, top + 4, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0B14
	push	hl
;	genIpush
	ld	hl,#__str_13
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:531: res = 1;
;	genAssign
;	AOP_STK for _yes_or_no_res_1_1
	ld	-3(ix),#0x01
	ld	-2(ix),#0x00
;main.c:533: while ( 1 )
;	genLabel
00123$:
;main.c:535: int new_res = res;
;	genAssign
;	AOP_STK for _yes_or_no_res_1_1
;	AOP_STK for _yes_or_no_new_res_2_3
	ld	a,-3(ix)
	ld	-5(ix),a
	ld	a,-2(ix)
	ld	-4(ix),a
;main.c:536: byte key = getkey();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	call	_getkey
	ld	a,l
	pop	bc
;	genAssign
;	(registers are the same)
;main.c:537: if ( key == 9 || key == 8 )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	b,a
	sub	a,#0x09
	jr	Z,00113$
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	sub	a,#0x08
	jr	Z,00152$
	jr	00114$
00152$:
;	genLabel
00113$:
;main.c:539: res = !res;
;	genNot
;	AOP_STK for _yes_or_no_res_1_1
	ld	a,-3(ix)
	or	a,-2(ix)
	sub	a,#0x01
	ld	a,#0x00
	rla
	ld	e,a
;	genCast
;	AOP_STK for _yes_or_no_res_1_1
	ld	-3(ix),e
	ld	-2(ix),#0x00
;	genGoto
	jr	00115$
;	genLabel
00114$:
;main.c:541: else if ( key == 'y' )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	sub	a,#0x79
	jr	Z,00154$
	jr	00111$
00154$:
;main.c:543: res = 1;
;	genAssign
;	AOP_STK for _yes_or_no_res_1_1
	ld	-3(ix),#0x01
	ld	-2(ix),#0x00
;main.c:544: break;
;	genGoto
	jp	00146$
;	genLabel
00111$:
;main.c:546: else if ( key == 'n' )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	sub	a,#0x6E
	jr	Z,00156$
	jr	00108$
00156$:
;main.c:548: res = 0;
;	genAssign
;	AOP_STK for _yes_or_no_res_1_1
	ld	-3(ix),#0x00
	ld	-2(ix),#0x00
;main.c:549: break;
;	genGoto
	jp	00146$
;	genLabel
00108$:
;main.c:551: else if ( key == 0xd )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	sub	a,#0x0D
	jp	Z,00146$
;main.c:553: break;
;	genLabel
00115$:
;main.c:555: if ( new_res != res )
;	genCmpEq
;	AOP_STK for _yes_or_no_new_res_2_3
;	AOP_STK for _yes_or_no_res_1_1
; genCmpEq: left 2, right 2, result 0
	ld	a,-5(ix)
	sub	-3(ix)
	jr	NZ,00158$
	ld	a,-4(ix)
	sub	-2(ix)
	jp	Z,00123$
00158$:
;main.c:557: if ( res )
;	genIfx
;	AOP_STK for _yes_or_no_res_1_1
	ld	a,-3(ix)
	or	a,-2(ix)
	jr	Z,00118$
;main.c:559: set_attr( 017, 9, top + 4, 5 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x050B
	push	hl
;	genIpush
	ld	hl,#0x090F
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;main.c:560: set_attr( 050, 19, top + 4, 4 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x040B
	push	hl
;	genIpush
	ld	hl,#0x1328
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;	genGoto
	jp	00123$
;	genLabel
00118$:
;main.c:564: set_attr( 050, 9, top + 4, 5 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x050B
	push	hl
;	genIpush
	ld	hl,#0x0928
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;main.c:565: set_attr( 017, 19, top + 4, 4 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x040B
	push	hl
;	genIpush
	ld	hl,#0x130F
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;	genGoto
	jp	00123$
;main.c:569: for ( i = 0; i < 6; i++ )
;	genLabel
00146$:
;	genAssign
;	AOP_STK for _yes_or_no_i_1_1
	ld	-1(ix),#0x00
;	genLabel
00129$:
;	genCmpLt
;	AOP_STK for _yes_or_no_i_1_1
	ld	a,-1(ix)
	sub	a,#0x06
	jp	NC,00132$
;main.c:571: print_pad_8( "", ( 32 - sz ) / 2, top + i, sz );
;	genPlus
;	AOP_STK for _yes_or_no_i_1_1
;	genPlusIncr
	ld	a,-1(ix)
	add	a,#0x07
	ld	e,a
;	genCast
	ld	d,c
	ld	b,#0x00
;	genMinus
	ld	a,#0x20
	sub	a,d
	ld	d,a
	ld	a,#0x00
	sbc	a,b
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	hl,#0x0002
	push	hl
;	genIpush
	ld	l,d
	ld	h,b
	push	hl
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	b,l
	pop	af
	pop	af
	ld	a,d
	pop	de
	ld	d,a
	ld	a,b
	pop	bc
	ld	b,a
;	genCast
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#__str_10
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
	pop	de
	pop	bc
;main.c:572: set_attr( 007, ( 32 - sz ) / 2, top + i, sz );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	a,#0x07
	push	af
	inc	sp
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;main.c:569: for ( i = 0; i < 6; i++ )
;	genPlus
;	AOP_STK for _yes_or_no_i_1_1
;	genPlusIncr
	inc	-1(ix)
;	genGoto
	jp	00129$
;	genLabel
00132$:
;main.c:574: return res;
;	genRet
;	AOP_STK for _yes_or_no_res_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -3
	ld	l,-3(ix)
	ld	h,-2(ix)
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_yes_or_no_end::
__str_10:
	.db 0x00
__str_11:
	.ascii "-= Confirmation =-"
	.db 0x00
__str_12:
	.ascii "Yes"
	.db 0x00
__str_13:
	.ascii "No"
	.db 0x00
;main.c:577: int input_box( char *head, char *prompt, char *str, int max_sz )
;	genLabel
;	genFunction
;	---------------------------------
; Function input_box
; ---------------------------------
_input_box_start::
_input_box:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-10
	add	hl,sp
	ld	sp,hl
;main.c:583: for ( i = 0; i < 6; i++ )
;	genAssign
	ld	c,#0x00
;	genLabel
00150$:
;	genCmpLt
;main.c:585: set_attr( 050, ( 32 - WN_8 ) / 2, top + i, WN_8 );
;	genPlus
;	genPlusIncr
	ld	a,c
	cp	a,#0x06
	jr	NC,00153$
	add	a,#0x07
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,#0x16
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#0x0528
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;main.c:586: print_pad_8( "", ( 32 - WN_8 ) / 2, top + i, WN_8 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,#0x16
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	a,#0x05
	push	af
	inc	sp
;	genIpush
	ld	hl,#__str_14
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
	pop	bc
;main.c:583: for ( i = 0; i < 6; i++ )
;	genPlus
;	genPlusIncr
	inc	c
;	genGoto
	jr	00150$
;	genLabel
00153$:
;main.c:588: set_attr( 0417, ( 32 - WN_8 ) / 2 + 1, top + 4, WN_8 - 2 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x140B
	push	hl
;	genIpush
	ld	hl,#0x060F
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;main.c:589: i = strlen( head );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genCast
;main.c:590: text_out_pos_8( "-= ", ( 26 - i ) / 2, top, 0, 0xff );
;	genCast
	ld	e,c
	ld	d,#0x00
;	genMinus
	ld	a,#0x1A
	sub	a,e
	ld	e,a
	ld	a,#0x00
	sbc	a,d
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0002
	push	hl
;	genIpush
	push	de
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
	ld	b,e
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	a,#0x07
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	hl,#__str_15
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	de
	pop	bc
;main.c:591: text_out_pos_8( head, ( 26 - i ) / 2 + 3, top, 0, 0xff );
;	genCast
	ld	b,e
;	genPlus
;	genPlusIncr
	inc	b
	inc	b
	inc	b
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	a,#0x07
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:592: text_out_pos_8( " =-", ( 26 - i ) / 2 + 3 + i, top, 0, 0xff );
;	genPlus
	ld	a,b
	add	a,c
	ld	c,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	a,#0x07
	push	af
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
	ld	hl,#__str_16
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:593: text_out_pos_8( prompt, ( 32 - WN_8 ) / 2 + 1, top + 2, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0906
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,6(ix)
	ld	h,7(ix)
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:595: curs = start = 0;
;	genAssign
;	AOP_STK for _input_box_start_1_1
	ld	-3(ix),#0x00
;	genAssign
;	AOP_STK for _input_box_curs_1_1
	ld	-2(ix),#0x00
;main.c:596: str[0] = 0;
;	genAssign
;	AOP_STK for 
;	AOP_STK for _input_box_sloc1_1_0
	ld	a,8(ix)
	ld	-10(ix),a
	ld	a,9(ix)
	ld	-9(ix),a
;	genAssign (pointer)
;	AOP_STK for _input_box_sloc1_1_0
;	isBitvar = 0
	ld	l,-10(ix)
	ld	h,-9(ix)
	ld	(hl),#0x00
;main.c:597: sz = 0;
;	genAssign
;	AOP_STK for _input_box_sz_1_1
	ld	-4(ix),#0x00
;main.c:598: set_attr( 0272, ( 32 - WN_8 ) / 2 + 1 + curs, top + 4, 1 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x010B
	push	hl
;	genIpush
	ld	hl,#0x06BA
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;main.c:599: while ( 1 )
;	genLabel
00148$:
;main.c:601: byte prev_curs = curs;
;	genAssign
;	AOP_STK for _input_box_curs_1_1
;	AOP_STK for _input_box_prev_curs_2_3
	ld	a,-2(ix)
	ld	-5(ix),a
;main.c:602: byte prev_start = start;
;	genAssign
;	AOP_STK for _input_box_start_1_1
;	AOP_STK for _input_box_prev_start_2_3
	ld	a,-3(ix)
	ld	-6(ix),a
;main.c:604: byte redraw = 0;
;	genAssign
	ld	e,#0x00
;main.c:606: key = getkey();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	call	_getkey
	ld	c,l
	pop	de
;	genAssign
	ld	d,c
;main.c:607: if ( key == 8 )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x08
	jr	Z,00203$
	jr	00143$
00203$:
;main.c:609: if ( curs > 0 )
;	genIfx
;	AOP_STK for _input_box_curs_1_1
	xor	a,a
	or	a,-2(ix)
	jp	Z,00144$
;main.c:611: curs--;
;	genMinus
;	AOP_STK for _input_box_curs_1_1
	dec	-2(ix)
;main.c:612: if ( curs < start )
;	genCmpLt
;	AOP_STK for _input_box_curs_1_1
;	AOP_STK for _input_box_start_1_1
	ld	a,-2(ix)
	sub	a,-3(ix)
	jp	NC,00144$
;main.c:614: start--;
;	genMinus
;	AOP_STK for _input_box_start_1_1
	dec	-3(ix)
;main.c:615: redraw = 1;
;	genAssign
	ld	e,#0x01
;	genGoto
	jp	00144$
;	genLabel
00143$:
;main.c:619: else if ( key == 9 )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x09
	jr	Z,00205$
	jr	00140$
00205$:
;main.c:621: if ( curs < sz )
;	genCmpLt
;	AOP_STK for _input_box_curs_1_1
;	AOP_STK for _input_box_sz_1_1
	ld	a,-2(ix)
	sub	a,-4(ix)
	jr	NC,00106$
;main.c:623: curs += 1;
;	genPlus
;	AOP_STK for _input_box_curs_1_1
;	genPlusIncr
	inc	-2(ix)
;	genLabel
00106$:
;main.c:625: if (( start + ( WN_8 - 3 ) ) < curs )
;	genCast
;	AOP_STK for _input_box_start_1_1
	ld	c,-3(ix)
	ld	b,#0x00
;	genPlus
;	AOP_STK for _input_box_sloc0_1_0
;	genPlusIncr
	ld	a,c
	add	a,#0x13
	ld	-8(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-7(ix),a
;	genCast
;	AOP_STK for _input_box_curs_1_1
	ld	c,-2(ix)
	ld	b,#0x00
;	genCmpLt
;	AOP_STK for _input_box_sloc0_1_0
	ld	a,-8(ix)
	sub	a,c
	ld	a,-7(ix)
	sbc	a,b
	jp	P,00144$
;main.c:627: start += 1;
;	genPlus
;	AOP_STK for _input_box_start_1_1
;	genPlusIncr
	inc	-3(ix)
;main.c:628: redraw = 1;
;	genAssign
	ld	e,#0x01
;	genGoto
	jp	00144$
;	genLabel
00140$:
;main.c:631: else if ( key == 0xc )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x0C
	jr	Z,00207$
	jp	00137$
00207$:
;main.c:633: if ( curs == sz && curs > 0 )
;	genCmpEq
;	AOP_STK for _input_box_curs_1_1
;	AOP_STK for _input_box_sz_1_1
; genCmpEq: left 1, right 1, result 0
	ld	a,-2(ix)
	sub	-4(ix)
	jr	Z,00209$
	jr	00116$
00209$:
;	genIfx
;	AOP_STK for _input_box_curs_1_1
	xor	a,a
	or	a,-2(ix)
	jr	Z,00116$
;main.c:635: sz -= 1;
;	genMinus
;	AOP_STK for _input_box_sz_1_1
	dec	-4(ix)
;main.c:636: curs -= 1;
;	genMinus
;	AOP_STK for _input_box_curs_1_1
	dec	-2(ix)
;main.c:637: if ( start > 0 )
;	genIfx
;	AOP_STK for _input_box_start_1_1
	xor	a,a
	or	a,-3(ix)
	jr	Z,00110$
;main.c:639: start--;
;	genMinus
;	AOP_STK for _input_box_start_1_1
	dec	-3(ix)
;	genLabel
00110$:
;main.c:641: str[sz] = 0;
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_sz_1_1
	ld	a,-10(ix)
	add	a,-4(ix)
	ld	c,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;main.c:642: redraw = 1;
;	genAssign
	ld	e,#0x01
;	genGoto
	jp	00144$
;	genLabel
00116$:
;main.c:644: else if ( curs > 0 )
;	genIfx
;	AOP_STK for _input_box_curs_1_1
	xor	a,a
	or	a,-2(ix)
	jp	Z,00144$
;main.c:646: for ( i = curs; i < sz; i++ )
;	genAssign
;	AOP_STK for _input_box_curs_1_1
;	AOP_STK for _input_box_i_1_1
	ld	a,-2(ix)
	ld	-1(ix),a
;	genLabel
00154$:
;	genCmpLt
;	AOP_STK for _input_box_i_1_1
;	AOP_STK for _input_box_sz_1_1
	ld	a,-1(ix)
	sub	a,-4(ix)
	jr	NC,00157$
;main.c:648: str[i-1] = str[i];
;	genCast
;	AOP_STK for _input_box_i_1_1
	ld	b,-1(ix)
	ld	c,#0x00
;	genMinus
	ld	l,b
	ld	h,c
	dec	hl
	ld	b,l
	ld	c,h
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
	ld	a,-10(ix)
	add	a,b
	ld	e,a
	ld	a,-9(ix)
	adc	a,c
	ld	d,a
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_i_1_1
	ld	a,-10(ix)
	add	a,-1(ix)
	ld	c,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAssign (pointer)
;	isBitvar = 0
	ld	(de),a
;main.c:646: for ( i = curs; i < sz; i++ )
;	genPlus
;	AOP_STK for _input_box_i_1_1
;	genPlusIncr
	inc	-1(ix)
;	genGoto
	jr	00154$
;	genLabel
00157$:
;main.c:650: sz -= 1;
;	genMinus
;	AOP_STK for _input_box_sz_1_1
	dec	-4(ix)
;main.c:651: str[sz] = 0;
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_sz_1_1
	ld	a,-10(ix)
	add	a,-4(ix)
	ld	c,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;main.c:652: curs -= 1;
;	genMinus
;	AOP_STK for _input_box_curs_1_1
	dec	-2(ix)
;main.c:653: if ( start > 0 )
;	genIfx
;	AOP_STK for _input_box_start_1_1
	xor	a,a
	or	a,-3(ix)
	jr	Z,00112$
;main.c:655: start--;
;	genMinus
;	AOP_STK for _input_box_start_1_1
	dec	-3(ix)
;	genLabel
00112$:
;main.c:657: redraw = 1;
;	genAssign
	ld	e,#0x01
;	genGoto
	jp	00144$
;	genLabel
00137$:
;main.c:660: else if ( key >= 32 && key < 128 && sz < max_sz )
;	genCmpLt
;	genCmpLt
	ld	a,d
	cp	a,#0x20
	jp	C,00132$
	sub	a,#0x80
	jp	NC,00132$
;	genCast
;	AOP_STK for _input_box_sz_1_1
	ld	c,-4(ix)
	ld	b,#0x00
;	genCmpLt
;	AOP_STK for 
	ld	a,c
	sub	a,10(ix)
	ld	a,b
	sbc	a,11(ix)
	jp	P,00132$
;main.c:662: if ( curs == sz )
;	genCmpEq
;	AOP_STK for _input_box_curs_1_1
;	AOP_STK for _input_box_sz_1_1
; genCmpEq: left 1, right 1, result 0
	ld	a,-2(ix)
	sub	-4(ix)
	jr	Z,00211$
	jr	00190$
00211$:
;main.c:664: str[curs] = key;
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_curs_1_1
	ld	a,-10(ix)
	add	a,-2(ix)
	ld	c,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,d
	ld	(bc),a
;main.c:665: curs += 1;
;	genPlus
;	AOP_STK for _input_box_curs_1_1
;	genPlusIncr
	inc	-2(ix)
;main.c:666: sz += 1;
;	genPlus
;	AOP_STK for _input_box_sz_1_1
;	genPlusIncr
	inc	-4(ix)
;main.c:667: redraw = 1;
;	genAssign
	ld	e,#0x01
;main.c:668: if (( start + ( WN_8 - 3 ) ) < curs )
;	genCast
;	AOP_STK for _input_box_start_1_1
	ld	c,-3(ix)
	ld	b,#0x00
;	genPlus
;	AOP_STK for _input_box_sloc0_1_0
;	genPlusIncr
	ld	a,c
	add	a,#0x13
	ld	-8(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-7(ix),a
;	genCast
;	AOP_STK for _input_box_curs_1_1
	ld	c,-2(ix)
	ld	b,#0x00
;	genCmpLt
;	AOP_STK for _input_box_sloc0_1_0
	ld	a,-8(ix)
	sub	a,c
	ld	a,-7(ix)
	sbc	a,b
	jp	P,00125$
;main.c:670: start += 1;
;	genPlus
;	AOP_STK for _input_box_start_1_1
;	genPlusIncr
	inc	-3(ix)
;	genGoto
	jp	00125$
;main.c:675: for ( i = sz; i > curs; i-- )
;	genLabel
00190$:
;	genAssign
;	AOP_STK for _input_box_sz_1_1
	ld	e,-4(ix)
;	genLabel
00158$:
;	genCmpGt
;	AOP_STK for _input_box_curs_1_1
	ld	a,-2(ix)
	sub	a,e
	jr	NC,00161$
;main.c:677: str[i] = str[i-1];
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_sloc0_1_0
	ld	a,-10(ix)
	add	a,e
	ld	-8(ix),a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	-7(ix),a
;	genCast
	ld	c,e
	ld	b,#0x00
;	genMinus
	dec	bc
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
	ld	a,-10(ix)
	add	a,c
	ld	c,a
	ld	a,-9(ix)
	adc	a,b
	ld	b,a
;	genPointerGet
	ld	a,(bc)
;	genAssign (pointer)
;	AOP_STK for _input_box_sloc0_1_0
;	isBitvar = 0
	ld	l,-8(ix)
	ld	h,-7(ix)
	ld	(hl),a
;main.c:675: for ( i = sz; i > curs; i-- )
;	genMinus
	dec	e
;	genGoto
	jr	00158$
;	genLabel
00161$:
;main.c:679: str[curs] = key;
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_curs_1_1
	ld	a,-10(ix)
	add	a,-2(ix)
	ld	c,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,d
	ld	(bc),a
;main.c:680: sz += 1;
;	genPlus
;	AOP_STK for _input_box_sz_1_1
;	genPlusIncr
	inc	-4(ix)
;main.c:681: curs += 1;
;	genPlus
;	AOP_STK for _input_box_curs_1_1
;	genPlusIncr
	inc	-2(ix)
;main.c:682: if (( start + ( WN_8 - 3 ) ) < curs )
;	genCast
;	AOP_STK for _input_box_start_1_1
	ld	c,-3(ix)
	ld	b,#0x00
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x13
	ld	e,a
	ld	a,b
	adc	a,#0x00
	ld	d,a
;	genCast
;	AOP_STK for _input_box_curs_1_1
	ld	c,-2(ix)
	ld	b,#0x00
;	genCmpLt
	ld	a,e
	sub	a,c
	ld	a,d
	sbc	a,b
	jp	P,00122$
;main.c:684: start += 1;
;	genPlus
;	AOP_STK for _input_box_start_1_1
;	genPlusIncr
	inc	-3(ix)
;	genLabel
00122$:
;main.c:686: redraw = 1;
;	genAssign
	ld	e,#0x01
;	genLabel
00125$:
;main.c:688: str[sz] = 0;
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_sz_1_1
	ld	a,-10(ix)
	add	a,-4(ix)
	ld	c,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;	genGoto
	jr	00144$
;	genLabel
00132$:
;main.c:690: else if ( key == 0x81 )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x81
	jr	Z,00213$
	jr	00129$
00213$:
;main.c:692: result = -1;
;	genAssign
	ld	bc,#0xFFFFFFFF
;main.c:693: break;
;	genGoto
	jp	00197$
;	genLabel
00129$:
;main.c:695: else if ( key == 0x0d )
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x0D
	jr	Z,00215$
	jr	00144$
00215$:
;main.c:697: result = sz;
;	genCast
;	AOP_STK for _input_box_sz_1_1
	ld	c,-4(ix)
	ld	b,#0x00
;main.c:698: break;
;	genGoto
	jp	00197$
;	genLabel
00144$:
;main.c:700: if ( redraw )
;	genIfx
	xor	a,a
	or	a,e
	jr	Z,00146$
;main.c:702: print_pad_8( str + start, ( 32 - WN_8 ) / 2 + 1, top + 4, WN_8 - 3 );
;	genPlus
;	AOP_STK for _input_box_sloc1_1_0
;	AOP_STK for _input_box_start_1_1
	ld	a,-10(ix)
	add	a,-3(ix)
	ld	e,a
	ld	a,-9(ix)
	adc	a,#0x00
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x130B
	push	hl
;	genIpush
	ld	a,#0x06
	push	af
	inc	sp
;	genIpush
	push	de
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genLabel
00146$:
;main.c:704: set_attr( 0417, ( 32 - WN_8 ) / 2 + 1 + prev_curs - prev_start, top + 4, 1 );
;	genPlus
;	AOP_STK for _input_box_prev_curs_2_3
;	genPlusIncr
	ld	a,-5(ix)
	add	a,#0x06
;	genMinus
;	AOP_STK for _input_box_prev_start_2_3
	ld	e,a
	sub	a,-6(ix)
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x010B
	push	hl
;	genIpush
;	genIpush
;	genCall
	ld	d,e
	ld	e,#0x0F
	push	de
	call	_set_attr
	pop	af
	pop	af
;main.c:705: set_attr( 0272, ( 32 - WN_8 ) / 2 + 1 + curs - start, top + 4, 1 );
;	genPlus
;	AOP_STK for _input_box_curs_1_1
;	genPlusIncr
	ld	a,-2(ix)
	add	a,#0x06
;	genMinus
;	AOP_STK for _input_box_start_1_1
	ld	e,a
	sub	a,-3(ix)
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x010B
	push	hl
;	genIpush
;	genIpush
;	genCall
	ld	d,e
	ld	e,#0xBA
	push	de
	call	_set_attr
	pop	af
	pop	af
;	genGoto
	jp	00148$
;main.c:707: for ( i = 0; i < 6; i++ )
;	genLabel
00197$:
;	genAssign
	ld	e,#0x00
;	genLabel
00162$:
;	genCmpLt
;main.c:709: print_pad_8( "", ( 32 - WN_8 ) / 2, top + i, WN_8 );
;	genPlus
;	genPlusIncr
	ld	a,e
	cp	a,#0x06
	jr	NC,00165$
	add	a,#0x07
	ld	d,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	a,#0x16
	push	af
	inc	sp
;	genIpush
	push	de
	inc	sp
;	genIpush
	ld	a,#0x05
	push	af
	inc	sp
;	genIpush
	ld	hl,#__str_14
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
	pop	de
	pop	bc
;main.c:710: set_attr( 007, ( 32 - WN_8 ) / 2, top + i, WN_8 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 1 deSending: 0
	push	bc
	push	de
	ld	a,#0x16
	push	af
	inc	sp
;	genIpush
	push	de
	inc	sp
;	genIpush
	ld	hl,#0x0507
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	de
	pop	bc
;main.c:707: for ( i = 0; i < 6; i++ )
;	genPlus
;	genPlusIncr
	inc	e
;	genGoto
	jr	00162$
;	genLabel
00165$:
;main.c:712: return result;
;	genRet
; Dump of IC_LEFT: type AOP_REG size 2
;	 reg = bc
	ld	l,c
	ld	h,b
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_input_box_end::
__str_14:
	.db 0x00
__str_15:
	.ascii "-= "
	.db 0x00
__str_16:
	.ascii " =-"
	.db 0x00
;main.c:717: void calc_sel()
;	genLabel
;	genFunction
;	---------------------------------
; Function calc_sel
; ---------------------------------
_calc_sel_start::
_calc_sel:
;main.c:719: if ( files_sel >= files_size ) files_sel = files_size - 1;
;	genCmpLt
	ld	iy,#_files_sel
	ld	a,0(iy)
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	iy,#_files_sel
	ld	a,1(iy)
	ld	iy,#_files_size
	sbc	a,1(iy)
	jp	M,00104$
;	genMinus
;	Shift into pair idx 0
	ld	hl,#_files_sel
	ld	a,0(iy)
	add	a,#0xFF
	ld	(hl),a
	ld	a,1(iy)
	adc	a,#0xFF
	inc	hl
	ld	(hl),a
;	genGoto
	jr	00106$
;	genLabel
00104$:
;main.c:720: else if ( files_sel < 0 ) files_sel = 0;
;	genCmpLt
	ld	iy,#_files_sel
	ld	a,1(iy)
	bit	7,a
	jr	Z,00106$
;	genAssign
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;main.c:722: while ( files_sel < files_table_start )
;	genLabel
00106$:
;	genCmpLt
	ld	iy,#_files_sel
	ld	a,0(iy)
	ld	iy,#_files_table_start
	sub	a,0(iy)
	ld	iy,#_files_sel
	ld	a,1(iy)
	ld	iy,#_files_table_start
	sbc	a,1(iy)
	jp	P,00109$
;main.c:724: files_table_start -= FILES_PER_ROW;
;	genMinus
;	Shift into pair idx 0
	ld	hl,#_files_table_start
	ld	a,(hl)
	add	a,#0xF0
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a,#0xFF
	ld	(hl),a
;main.c:725: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;	genGoto
	jr	00106$
;main.c:728: while ( files_sel >= files_table_start + FILES_PER_ROW * 2 )
;	genLabel
00109$:
;	genPlus
;	genPlusIncr
	ld	iy,#_files_table_start
	ld	a,0(iy)
	add	a,#0x20
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genCmpLt
	ld	iy,#_files_sel
	ld	a,0(iy)
	sub	a,c
	ld	a,1(iy)
	sbc	a,b
	jp	M,00111$
;main.c:730: files_table_start += FILES_PER_ROW;
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_files_table_start
	ld	a,(hl)
	add	a,#0x10
	inc	hl
	dec	hl
;	Addition result is in same register as operand of next addition.
	push	bc
	ld	c, a
	inc	hl
	ld	a, (hl)
	ld	b, a
	ld	a, c
	dec	hl
	ld	(hl), a
	ld	a, b
	pop	bc
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;main.c:731: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;	genGoto
	jr	00109$
;	genLabel
00111$:
;main.c:734: selx = (( files_sel - files_table_start ) / FILES_PER_ROW ) * 16 + 1;
;	genMinus
;	Shift into pair idx 0
	ld	hl,#_files_table_start
	ld	iy,#_files_sel
	ld	a,0(iy)
	sub	a,(hl)
	ld	c,a
	ld	a,1(iy)
	inc	hl
	sbc	a,(hl)
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0010
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__divsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
;	genLeftShift
	ld	a,e
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	ld	e,a
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_selx
	ld	a,e
	add	a,#0x01
	ld	(hl),a
;main.c:735: sely = (( files_sel - files_table_start ) % FILES_PER_ROW ) + 3;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0010
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__modsint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genCast
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_sely
	ld	a,c
	add	a,#0x03
	ld	(hl),a
;	genLabel
;	genEndFunction
	ret
_calc_sel_end::
;main.c:739: void hide_sel()
;	genLabel
;	genFunction
;	---------------------------------
; Function hide_sel
; ---------------------------------
_hide_sel_start::
_hide_sel:
;main.c:741: set_attr( 007, selx, sely, 14 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x0E
	push	af
	inc	sp
;	genIpush
	ld	a,(_sely)
	push	af
	inc	sp
;	genIpush
	ld	a,(_selx)
	push	af
	inc	sp
;	genIpush
	ld	a,#0x07
	push	af
	inc	sp
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	ret
_hide_sel_end::
;main.c:744: void show_sel()
;	genLabel
;	genFunction
;	---------------------------------
; Function show_sel
; ---------------------------------
_show_sel_start::
_show_sel:
;main.c:746: if ( files_size <= 0 ) return;
;	genCmpGt
	ld	a,#0x00
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	a,#0x00
	sbc	a,1(iy)
	jp	M,00102$
;	genRet
	ret
;	genLabel
00102$:
;main.c:747: calc_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_calc_sel
;main.c:748: set_attr( 071, selx, sely, 14 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x0E
	push	af
	inc	sp
;	genIpush
	ld	a,(_sely)
	push	af
	inc	sp
;	genIpush
	ld	a,(_selx)
	push	af
	inc	sp
;	genIpush
	ld	a,#0x39
	push	af
	inc	sp
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	ret
_show_sel_end::
;main.c:751: void display_fn( char *fn, int col, int row, int max_sz )
;	genLabel
;	genFunction
;	---------------------------------
; Function display_fn
; ---------------------------------
_display_fn_start::
_display_fn:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;main.c:753: if ( strlen( fn ) == 0 )
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jr	NZ,00108$
;main.c:755: print_pad_8( fn, col, row, max_sz );
;	genCast
;	AOP_STK for 
	ld	c,10(ix)
;	genCast
;	AOP_STK for 
	ld	b,8(ix)
;	genCast
;	AOP_STK for 
	ld	e,6(ix)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,c
	push	af
	inc	sp
;	genIpush
	push	bc
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genGoto
	jp	00110$
;	genLabel
00108$:
;main.c:759: char *p = fn + strlen( fn ) - 1;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,4(ix)
	ld	h,5(ix)
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genPlus
;	AOP_STK for 
	ld	a,4(ix)
	add	a,c
	ld	c,a
	ld	a,5(ix)
	adc	a,b
	ld	b,a
;	genMinus
;	AOP_STK for _display_fn_p_2_3
	ld	a,c
	add	a,#0xFF
	ld	-2(ix),a
	ld	a,b
	adc	a,#0xFF
	ld	-1(ix),a
;main.c:760: while ( p != fn && *p != '/' ) p--;
;	genAssign
;	AOP_STK for _display_fn_p_2_3
	ld	c,-2(ix)
	ld	b,-1(ix)
;	genLabel
00102$:
;	genCmpEq
;	AOP_STK for 
; genCmpEq: left 2, right 2, result 0
	ld	a,c
	sub	4(ix)
	jr	NZ,00118$
	ld	a,b
	sub	5(ix)
	jr	Z,00117$
00118$:
;	genPointerGet
	ld	a,(bc)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	sub	a,#0x2F
	jr	Z,00117$
;	genMinus
	dec	bc
;	genGoto
	jr	00102$
;	genLabel
00117$:
;	genAssign
;	AOP_STK for _display_fn_p_2_3
	ld	-2(ix),c
	ld	-1(ix),b
;main.c:761: if ( *p == '/' ) p++;
;	genPointerGet
	ld	a,(bc)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	sub	a,#0x2F
	jr	Z,00121$
	jr	00106$
00121$:
;	genPlus
;	AOP_STK for _display_fn_p_2_3
;	genPlusIncr
	ld	a,c
	add	a,#0x01
	ld	-2(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-1(ix),a
;	genLabel
00106$:
;main.c:762: print_pad_8( p, col, row, max_sz );
;	genCast
;	AOP_STK for 
	ld	e,10(ix)
;	genCast
;	AOP_STK for 
	ld	d,8(ix)
;	genCast
;	AOP_STK for 
	ld	c,6(ix)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,e
	push	af
	inc	sp
;	genIpush
	push	de
	inc	sp
;	genIpush
	ld	a,c
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _display_fn_p_2_3
	ld	l,-2(ix)
	ld	h,-1(ix)
	push	hl
;	genCall
	call	_print_pad_8
	pop	af
	pop	af
	inc	sp
;	genLabel
00110$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_display_fn_end::
;main.c:766: void get_dsk_name( byte dsk, char *buf, word size )
;	genLabel
;	genFunction
;	---------------------------------
; Function get_dsk_name
; ---------------------------------
_get_dsk_name_start::
_get_dsk_name:
	push	ix
	ld	ix,#0
	add	ix,sp
;main.c:768: pport_send( PP_CMD_FCTL( PP_FCTL_DSK_GET ), 1, &dsk );
;	genAddrOf
	ld	hl,#0x0004
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	hl,#0x7813
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:769: pport_receive( buf, size );
;	genAssign
;	AOP_STK for 
	ld	c,5(ix)
	ld	b,6(ix)
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for 
	ld	l,7(ix)
	ld	h,8(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:776: if ( pport_result != PP_W_ACK )
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_pport_result
	ld	a,0(iy)
	or	a,a
	jr	NZ,00111$
	ld	a,1(iy)
	sub	a,#0x73
	jr	Z,00105$
00111$:
;main.c:778: strcpy( buf, "err" );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_17
	push	hl
;	genIpush
;	AOP_STK for 
	ld	l,5(ix)
	ld	h,6(ix)
	push	hl
;	genCall
	call	_strcpy
	pop	af
	pop	af
;	genGoto
	jr	00107$
;	genLabel
00105$:
;main.c:780: else if ( buf[0] == 0 )
;	genAssign
;	AOP_STK for 
	ld	c,5(ix)
	ld	b,6(ix)
;	genPointerGet
	ld	a,(bc)
;	genIfx
	or	a,a
	jr	NZ,00102$
;main.c:782: strcpy( buf, "----" );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_18
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcpy
	pop	af
	pop	af
;	genGoto
	jr	00107$
;	genLabel
00102$:
;main.c:786: buf[pport_pktsize] = 0;
;	genPlus
;	Shift into pair idx 0
	ld	hl,#_pport_pktsize
	ld	a,c
	add	a,(hl)
	ld	c,a
	ld	a,b
	inc	hl
	adc	a,(hl)
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;	genLabel
00107$:
;	genEndFunction
	pop	ix
	ret
_get_dsk_name_end::
__str_17:
	.ascii "err"
	.db 0x00
__str_18:
	.ascii "----"
	.db 0x00
;main.c:790: word get_flags()
;	genLabel
;	genFunction
;	---------------------------------
; Function get_flags
; ---------------------------------
_get_flags_start::
_get_flags:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-2
	add	hl,sp
	ld	sp,hl
;main.c:793: pport_send( PP_CMD_FCTL( PP_FCTL_CFG_GFLAGS ), 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x7821
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:794: pport_receive( &flags, sizeof( flags ) );
;	genAddrOf
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0002
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:799: if ( pport_result != PP_W_ACK )
;	genCmpEq
; genCmpEq: left 2, right 2, result 0
	ld	iy,#_pport_result
	ld	a,0(iy)
	or	a,a
	jr	NZ,00106$
	ld	a,1(iy)
	sub	a,#0x73
	jr	Z,00102$
00106$:
;main.c:801: flags = 0;
;	genAssign
;	AOP_STK for _get_flags_flags_1_1
	ld	-2(ix),#0x00
	ld	-1(ix),#0x00
;	genLabel
00102$:
;main.c:803: return flags;
;	genRet
;	AOP_STK for _get_flags_flags_1_1
; Dump of IC_LEFT: type AOP_STK size 2
;	 aop_stk -2
	ld	l,-2(ix)
	ld	h,-1(ix)
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_get_flags_end::
;main.c:806: void update_disks( byte dsk )
;	genLabel
;	genFunction
;	---------------------------------
; Function update_disks
; ---------------------------------
_update_disks_start::
_update_disks:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-77
	add	hl,sp
	ld	sp,hl
;main.c:810: char dsk_head[4] = { "A:" };
;	genAddrOf
	ld	hl,#0x0008
	add	hl,sp
	ld	c,l
	ld	b,h
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x41
	ld	(bc),a
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x3A
	ld	(de),a
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
	inc	de
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;main.c:811: if ( dsk > 3 )
;	genCmpGt
;	AOP_STK for 
	ld	a,#0x03
	sub	a,4(ix)
	jp	NC,00108$
;main.c:815: word flags = get_flags();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	call	_get_flags
	ld	d,h
	ld	e,l
	pop	bc
;	genAssign
;	AOP_STK for _update_disks_flags_2_2
	ld	-72(ix),e
	ld	-71(ix),d
;main.c:816: for ( i = 0; i < 4; i++ )
;	genAssign
;	AOP_STK for _update_disks_i_2_2
	ld	-70(ix),#0x00
;	genLabel
00110$:
;	genCmpLt
;	AOP_STK for _update_disks_i_2_2
	ld	a,-70(ix)
	sub	a,#0x04
	jp	NC,00114$
;main.c:818: dsk_name[0] = 0;
;	genAddrOf
	ld	hl,#0x000C
	add	hl,sp
;	genAssign (pointer)
;	isBitvar = 0
	ld	d,l
	ld	e,h
	ld	(hl),#0x00
;main.c:819: get_dsk_name( i, dsk_name, 0x40 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	l,d
	ld	h,e
	push	hl
;	genIpush
;	AOP_STK for _update_disks_i_2_2
	ld	a,-70(ix)
	push	af
	inc	sp
;	genCall
	call	_get_dsk_name
	pop	af
	pop	af
	inc	sp
	pop	bc
;main.c:820: dsk_head[0] = 'A' + i;
;	genPlus
;	AOP_STK for _update_disks_i_2_2
;	genPlusIncr
	ld	a,-70(ix)
	add	a,#0x41
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;main.c:821: text_out_pos_8( dsk_head, 0, 20 + i, 0, 0xff );
;	genPlus
;	AOP_STK for _update_disks_i_2_2
;	AOP_STK for _update_disks_sloc0_1_0
;	genPlusIncr
	ld	a,-70(ix)
	add	a,#0x14
	ld	-75(ix),a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0xFF00
	push	hl
;	genIpush
;	AOP_STK for _update_disks_sloc0_1_0
	ld	a,-75(ix)
	push	af
	inc	sp
;	genIpush
	ld	a,#0x00
	push	af
	inc	sp
;	genIpush
	push	bc
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:822: display_fn( dsk_name, 2, 20 + i, 25 );
;	genCast
;	AOP_STK for _update_disks_i_2_2
	ld	d,-70(ix)
	ld	e,#0x00
;	genPlus
;	AOP_STK for _update_disks_sloc1_1_0
;	genPlusIncr
	ld	a,d
	add	a,#0x14
	ld	-77(ix),a
	ld	a,e
	adc	a,#0x00
	ld	-76(ix),a
;	genAddrOf
	ld	hl,#0x000C
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0019
	push	hl
;	genIpush
;	AOP_STK for _update_disks_sloc1_1_0
	ld	l,-77(ix)
	ld	h,-76(ix)
	push	hl
;	genIpush
	ld	hl,#0x0002
	push	hl
;	genIpush
	push	de
;	genCall
	call	_display_fn
	pop	af
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:823: if ( flags & ( 1 << i ) )
;	genLeftShift
;	AOP_STK for _update_disks_i_2_2
	ld	a,-70(ix)
	inc	a
	push	af
	ld	de,#0x0001
	pop	af
	jr	00123$
00122$:
	sla	e
	rl	d
00123$:
	dec	a
	jr	NZ,00122$
;	genAnd
;	AOP_STK for _update_disks_flags_2_2
	ld	a,e
	and	a,-72(ix)
	ld	e,a
	ld	a,d
	and	a,-71(ix)
;	genIfx
	ld	d,a
	or	a,e
	jr	Z,00102$
;main.c:825: set_attr( 0102, 0, 20 + i, 1 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,#0x01
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _update_disks_sloc0_1_0
	ld	a,-75(ix)
	push	af
	inc	sp
;	genIpush
	ld	hl,#0x0042
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;	genGoto
	jr	00112$
;	genLabel
00102$:
;main.c:829: set_attr( 0104, 0, 20 + i, 1 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	a,#0x01
	push	af
	inc	sp
;	genIpush
;	AOP_STK for _update_disks_sloc0_1_0
	ld	a,-75(ix)
	push	af
	inc	sp
;	genIpush
	ld	hl,#0x0044
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
	pop	bc
;	genLabel
00112$:
;main.c:816: for ( i = 0; i < 4; i++ )
;	genPlus
;	AOP_STK for _update_disks_i_2_2
;	genPlusIncr
	inc	-70(ix)
;	genGoto
	jp	00110$
;	genLabel
00108$:
;main.c:835: word flags = get_flags();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	call	_get_flags
	ld	d,h
	ld	e,l
	pop	bc
;	genAssign
;	AOP_STK for _update_disks_flags_2_6
	ld	-74(ix),e
	ld	-73(ix),d
;main.c:836: dsk_name[0] = 0;
;	genAddrOf
	ld	hl,#0x000C
	add	hl,sp
	ld	e,l
	ld	d,h
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(de),a
;main.c:837: get_dsk_name( dsk, dsk_name, 0x40 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0040
	push	hl
;	genIpush
	push	de
;	genIpush
;	AOP_STK for 
	ld	a,4(ix)
	push	af
	inc	sp
;	genCall
	call	_get_dsk_name
	pop	af
	pop	af
	inc	sp
	pop	bc
;main.c:838: dsk_head[0] = 'A' + dsk;
;	genPlus
;	AOP_STK for 
;	genPlusIncr
	ld	a,4(ix)
	add	a,#0x41
;	genAssign (pointer)
;	isBitvar = 0
	ld	(bc),a
;main.c:839: text_out_pos_8( dsk_head, 0, 20 + dsk, 0, 0xff );
;	genPlus
;	AOP_STK for 
;	genPlusIncr
	ld	a,4(ix)
	add	a,#0x14
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	ld	a,#0x00
	push	af
	inc	sp
;	genIpush
	push	bc
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
	pop	de
;main.c:840: display_fn( dsk_name, 2, 20 + dsk, 25 );
;	genCast
;	AOP_STK for 
	ld	c,4(ix)
	ld	b,#0x00
;	genPlus
;	AOP_STK for _update_disks_sloc1_1_0
;	genPlusIncr
	ld	a,c
	add	a,#0x14
	ld	-77(ix),a
	ld	a,b
	adc	a,#0x00
	ld	-76(ix),a
;	genAddrOf
	ld	hl,#0x000C
	add	hl,sp
	ld	d,l
	ld	c,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0019
	push	hl
;	genIpush
;	AOP_STK for _update_disks_sloc1_1_0
	ld	l,-77(ix)
	ld	h,-76(ix)
	push	hl
;	genIpush
	ld	hl,#0x0002
	push	hl
;	genIpush
	ld	l,d
	ld	h,c
	push	hl
;	genCall
	call	_display_fn
	pop	af
	pop	af
	pop	af
	pop	af
	pop	de
;main.c:841: if ( flags & ( 1 << dsk ) )
;	genLeftShift
;	AOP_STK for 
	ld	a,4(ix)
	inc	a
	push	af
	ld	bc,#0x0001
	pop	af
	jr	00125$
00124$:
	sla	c
	rl	b
00125$:
	dec	a
	jr	NZ,00124$
;	genAnd
;	AOP_STK for _update_disks_flags_2_6
	ld	a,c
	and	a,-74(ix)
	ld	c,a
	ld	a,b
	and	a,-73(ix)
;	genIfx
	ld	b,a
	or	a,c
	jr	Z,00105$
;main.c:843: set_attr( 0102, 0, 20 + dsk, 1 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x01
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	ld	hl,#0x0042
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genGoto
	jr	00114$
;	genLabel
00105$:
;main.c:847: set_attr( 0104, 0, 20 + dsk, 1 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x01
	push	af
	inc	sp
;	genIpush
	ld	a,e
	push	af
	inc	sp
;	genIpush
	ld	hl,#0x0044
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genLabel
00114$:
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_update_disks_end::
;main.c:852: void update_rom()
;	genLabel
;	genFunction
;	---------------------------------
; Function update_rom
; ---------------------------------
_update_rom_start::
_update_rom:
;main.c:854: word flags = get_flags();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_get_flags
	ld	b,h
	ld	c,l
;	genAssign
;	(registers are the same)
;main.c:855: text_out_pos_8( flags & CFG_FLG_STROM1 ? "ROM1" : "ROM0", 28, 23, 0, 0xff );
;	genAnd
	ld	a,c
	and	a,#0x20
	jr	Z,00103$
;	genAddrOf
	ld	hl,#__str_20
	ld	c,l
	ld	b,h
;	genGoto
	jr	00104$
;	genLabel
00103$:
;	genAddrOf
	ld	hl,#__str_21
	ld	c,l
	ld	b,h
;	genLabel
00104$:
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x171C
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;	genLabel
;	genEndFunction
	ret
_update_rom_end::
__str_20:
	.ascii "ROM1"
	.db 0x00
__str_21:
	.ascii "ROM0"
	.db 0x00
;main.c:858: void init_screen()
;	genLabel
;	genFunction
;	---------------------------------
; Function init_screen
; ---------------------------------
_init_screen_start::
_init_screen:
;main.c:860: clrscr();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_clrscr
;main.c:862: set_attr( 0104, 0, 0, 32 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x2000
	push	hl
;	genIpush
	ld	hl,#0x0044
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;main.c:863: text_out_pos_8( "-=Syd's Speccy2007 boot-loader=-", 0, 0, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#__str_22
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:898: __endasm;
;	genInline
	
		ld hl, #0x4240
		push hl
		pop de
		ld a, #0xff
		ld( hl ), a
		inc de
		ld bc, #0x1f
		ldir
		ld hl, #0x4440
		push hl
		pop de
		ld a, #0xff
		ld( hl ), a
		inc de
		ld bc, #0x1f
		ldir
		ld hl, #0x5260
		push hl
		pop de
		ld a, #0xff
		ld( hl ), a
		inc de
		ld bc, #0x1f
		ldir
		ld hl, #0x5460
		push hl
		pop de
		ld a, #0xff
		ld( hl ), a
		inc de
		ld bc, #0x1f
		ldir
		
;	genLabel
;	genEndFunction
	ret
_init_screen_end::
__str_22:
	.ascii "-=Syd's Speccy2007 boot-loader=-"
	.db 0x00
;main.c:901: void main()
;	genLabel
;	genFunction
;	---------------------------------
; Function main
; ---------------------------------
_main_start::
_main:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-606
	add	hl,sp
	ld	sp,hl
;main.c:904: strcpy( tap_path, "boot.tap" );
;	genAddrOf
	ld	hl,#0x020E
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_23
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:906: init_screen();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_init_screen
;main.c:908: pport_open();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_pport_open
;main.c:910: strcpy( path, "" );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_24
	push	hl
;	genIpush
	ld	hl,#_path
	push	hl
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:911: read_dir();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_read_dir
;main.c:913: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;main.c:914: show_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_sel
;main.c:915: update_disks( 4 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x04
	push	af
	inc	sp
;	genCall
	call	_update_disks
	inc	sp
;main.c:918: while ( true )
;	genAddrOf
;	AOP_EXSTK for _main_sloc2_1_0
	ld	hl,#0x0037
	add	hl,sp
	ld	iy,#6
	add	iy,sp
	ld	0(iy),l
	ld	1(iy),h
;	genPlus
;	AOP_EXSTK for _main_sloc2_1_0
;	AOP_EXSTK for _main_sloc1_1_0
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#8
	add	hl,sp
	ld	a,0(iy)
	add	a,#0x02
	ld	(hl),a
	ld	a,1(iy)
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;	genAddrOf
;	AOP_EXSTK for _main_sloc0_1_0
	ld	hl,#0x0017
	add	hl,sp
	ld	iy,#10
	add	iy,sp
	ld	0(iy),l
	ld	1(iy),h
;	genLabel
00217$:
;main.c:920: byte key = getkey();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_getkey
	ld	e,l
;	genAssign
;	AOP_STK for _main_key_2_2
	ld	-81(ix),e
;main.c:922: byte *name = files[ files_sel ].name;
;	genMult
	ld	de,(_files_sel)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	d,l
	ld	e,h
;	genPlus
	ld	a,#<_files
	add	a,d
	ld	d,a
	ld	a,#>_files
	adc	a,e
	ld	e,a
;	genPlus
;	AOP_STK for _main_name_2_2
;	genPlusIncr
	ld	a,d
	add	a,#0x01
	ld	-83(ix),a
	ld	a,e
	adc	a,#0x00
	ld	-82(ix),a
;main.c:925: if ( key >= 0x08 && key <= 0x0b && files_size > 0 )
;	genCmpLt
;	AOP_STK for _main_key_2_2
	ld	a,-81(ix)
	sub	a,#0x08
	jp	C,00212$
;	genCmpGt
;	AOP_STK for _main_key_2_2
	ld	a,#0x0B
	sub	a,-81(ix)
	jp	C,00212$
;	genCmpGt
	ld	a,#0x00
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	a,#0x00
	sbc	a,1(iy)
	jp	P,00212$
;main.c:929: hide_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_hide_sel
;main.c:931: if ( key == 0x08 ) files_sel -= FILES_PER_ROW;
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x08
	jr	Z,00286$
	jr	00110$
00286$:
;	genMinus
;	Shift into pair idx 0
	ld	hl,#_files_sel
	ld	a,(hl)
	add	a,#0xF0
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a,#0xFF
	ld	(hl),a
;	genGoto
	jr	00111$
;	genLabel
00110$:
;main.c:932: else if ( key == 0x09 ) files_sel += FILES_PER_ROW;
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x09
	jr	Z,00288$
	jr	00107$
00288$:
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_files_sel
	ld	a,(hl)
	add	a,#0x10
	inc	hl
	dec	hl
;	Addition result is in same register as operand of next addition.
	push	bc
	ld	c, a
	inc	hl
	ld	a, (hl)
	ld	b, a
	ld	a, c
	dec	hl
	ld	(hl), a
	ld	a, b
	pop	bc
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;	genGoto
	jr	00111$
;	genLabel
00107$:
;main.c:933: else if ( key == 0x0a ) files_sel++;
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x0A
	jr	Z,00290$
	jr	00104$
00290$:
;	genPlus
;	genPlusIncr
	ld	iy,#_files_sel
	inc	0(iy)
	jr	NZ,00291$
	inc	1(iy)
00291$:
;	genGoto
	jr	00111$
;	genLabel
00104$:
;main.c:934: else if ( key == 0x0b ) files_sel--;
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x0B
	jr	Z,00293$
	jr	00111$
00293$:
;	genMinus
	ld	hl,(_files_sel)
	dec	hl
	ld	(_files_sel),hl
;	genLabel
00111$:
;main.c:936: show_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_sel
;	genGoto
	jp	00217$
;	genLabel
00212$:
;main.c:939: else if ( key == 0x0d )
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x0D
	jr	Z,00295$
	jp	00209$
00295$:
;main.c:941: if (( files[ files_sel ].attr & AM_DIR ) )
;	genMult
	ld	de,(_files_sel)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	e,l
	ld	d,h
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	e,l
	ld	d,h
;	genPointerGet
	ld	a,(de)
;	genAnd
	ld	e,a
	and	a,#0x10
	jp	Z,00152$
;main.c:943: hide_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_hide_sel
;main.c:945: if ( strcmp( name, ".." ) == 0 )
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_25
	push	hl
;	genIpush
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genCall
	call	_strcmp
	ld	d,h
	ld	e,l
	pop	af
	pop	af
;	genIfx
	ld	a,e
	or	a,d
	jp	NZ,00129$
;main.c:947: byte i = strlen( path );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
;	genCast
;	AOP_STK for _main_i_5_6
	ld	-84(ix),e
;main.c:949: if ( i != 0 )
;	genIfx
;	AOP_STK for _main_i_5_6
	xor	a,a
	or	a,-84(ix)
	jp	Z,00130$
;main.c:951: i--;
;	genMinus
;	AOP_STK for _main_i_5_6
	dec	-84(ix)
;main.c:952: path[i] = 0;
;	genPlus
;	AOP_STK for _main_i_5_6
	ld	a,#<_path
	add	a,-84(ix)
	ld	d,a
	ld	a,#>_path
	adc	a,#0x00
	ld	e,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	l,d
	ld	h,e
	ld	(hl),#0x00
;main.c:954: while ( i != 0 && path[i - 1] != '/' ) i--;
;	genLabel
00113$:
;	genIfx
;	AOP_STK for _main_i_5_6
	xor	a,a
	or	a,-84(ix)
	jr	Z,00115$
;	genMinus
;	AOP_STK for _main_i_5_6
	ld	a,-84(ix)
	add	a,#0xFF
;	genPlus
	ld	e, a
	add	a,#<_path
	ld	d,a
	ld	a,#>_path
	adc	a,#0x00
	ld	c,a
;	genPointerGet
	ld	l,d
	ld	h,c
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x2F
	jr	Z,00115$
;	genAssign
;	(registers are the same)
;	genAssign
;	AOP_STK for _main_i_5_6
	ld	-84(ix),e
;	genGoto
	jr	00113$
;	genLabel
00115$:
;main.c:955: strcpy( dir_name, &path[i] );
;	genPlus
;	AOP_STK for _main_i_5_6
	ld	a,#<_path
	add	a,-84(ix)
	ld	c,a
	ld	a,#>_path
	adc	a,#0x00
	ld	b,a
;	genAddrOf
	ld	hl,#0x01FD
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:957: path[i] = 0;
;	genPlus
;	AOP_STK for _main_i_5_6
	ld	a,#<_path
	add	a,-84(ix)
	ld	c,a
	ld	a,#>_path
	adc	a,#0x00
	ld	b,a
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;main.c:958: read_dir();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_read_dir
;main.c:960: for ( files_sel = 0; files_sel < files_size; files_sel++ )
;	genAssign
	ld	iy,#_files_sel
	ld	0(iy),#0x00
	ld	1(iy),#0x00
;	genLabel
00118$:
;	genCmpLt
	ld	iy,#_files_sel
	ld	a,0(iy)
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	iy,#_files_sel
	ld	a,1(iy)
	ld	iy,#_files_size
	sbc	a,1(iy)
	jp	P,00121$
;main.c:961: if ( strcmp( files[files_sel].name, dir_name ) == 0 )
;	genAddrOf
	ld	hl,#0x01FD
	add	hl,sp
	ld	c,l
	ld	b,h
;	genMult
	ld	de,(_files_sel)
	ld	l,e
	ld	h,d
	add	hl,hl
	add	hl,de
	add	hl,hl
	add	hl,de
	add	hl,hl
	ld	e,l
	ld	d,h
;	genPlus
	ld	hl,#_files
	add	hl,de
	ld	e,l
	ld	d,h
;	genPlus
;	genPlusIncr
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	push	de
;	genCall
	call	_strcmp
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00121$
;main.c:960: for ( files_sel = 0; files_sel < files_size; files_sel++ )
;	genPlus
;	genPlusIncr
	ld	iy,#_files_sel
	inc	0(iy)
	jr	NZ,00298$
	inc	1(iy)
00298$:
;	genGoto
	jp	00118$
;	genLabel
00121$:
;main.c:963: if (( files_table_start + FILES_PER_ROW * 2 - 1 ) < files_sel )
;	genPlus
;	genPlusIncr
	ld	iy,#_files_table_start
	ld	a,0(iy)
	add	a,#0x1F
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genCmpLt
	ld	a,c
	ld	iy,#_files_sel
	sub	a,0(iy)
	ld	a,b
	sbc	a,1(iy)
	jp	P,00123$
;main.c:965: files_table_start = files_sel;
;	genAssign
	ld	hl,(_files_sel)
	ld	iy,#_files_table_start
	ld	0(iy),l
	ld	1(iy),h
;	genLabel
00123$:
;main.c:968: sely = (( files_sel - files_table_start ) % FILES_PER_ROW ) + 3;
;	genMinus
;	Shift into pair idx 0
	ld	hl,#_files_table_start
	ld	iy,#_files_sel
	ld	a,0(iy)
	sub	a,(hl)
	ld	c,a
	ld	a,1(iy)
	inc	hl
	sbc	a,(hl)
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0010
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__modsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_sely
	ld	a,e
	add	a,#0x03
	ld	(hl),a
;main.c:969: selx = (( files_sel - files_table_start ) / FILES_PER_ROW ) * 16 + 1;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0010
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__divsint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genCast
;	genLeftShift
	ld	a,c
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	ld	c,a
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_selx
	ld	a,c
	add	a,#0x01
	ld	(hl),a
;main.c:971: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;	genGoto
	jp	00130$
;	genLabel
00129$:
;main.c:974: else if ( strlen( path ) + strlen( name ) + 1 < PATH_SIZE )
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genPlus
	ld	a,c
	add	a,e
	ld	c,a
	ld	a,b
	adc	a,d
	ld	b,a
;	genPlus
;	genPlusIncr
	inc	bc
;	genCmpLt
	ld	a,c
	sub	a,#0x40
	ld	a,b
	sbc	a,#0x00
	jp	P,00130$
;main.c:976: strcat( path, name );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	ld	hl,#_path
	push	hl
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:977: strcat( path, "/" );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_26
	push	hl
;	genIpush
	ld	hl,#_path
	push	hl
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:978: read_dir();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_read_dir
;main.c:979: sely = (( files_sel - files_table_start ) % FILES_PER_ROW ) + 3;
;	genMinus
;	Shift into pair idx 0
	ld	hl,#_files_table_start
	ld	iy,#_files_sel
	ld	a,0(iy)
	sub	a,(hl)
	ld	c,a
	ld	a,1(iy)
	inc	hl
	sbc	a,(hl)
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0010
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__modsint_rrx_s
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genCast
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_sely
	ld	a,e
	add	a,#0x03
	ld	(hl),a
;main.c:980: selx = (( files_sel - files_table_start ) / FILES_PER_ROW ) * 16 + 1;
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0010
	push	hl
;	genIpush
	push	bc
;	genCall
	call	__divsint_rrx_s
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genCast
;	genLeftShift
	ld	a,c
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	ld	c,a
;	genPlus
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#_selx
	ld	a,c
	add	a,#0x01
	ld	(hl),a
;main.c:982: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;	genLabel
00130$:
;main.c:985: show_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_sel
;	genGoto
	jp	00217$
;	genLabel
00152$:
;main.c:991: sdata[0] = FA_OPEN_EXISTING | FA_READ;
;	genAddrOf
	ld	hl,#0x01AD
	add	hl,sp
	ld	c,l
	ld	b,h
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x01
	ld	(bc),a
;main.c:992: strcpy( &sdata[1], path );
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#_path
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
	pop	bc
;main.c:993: strcat( &sdata[1], name );
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcat
	pop	af
	pop	af
	pop	bc
;main.c:995: strcpy( ext, name + strlen( name ) - 3 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genPlus
;	AOP_STK for _main_name_2_2
	ld	a,-83(ix)
	add	a,e
	ld	e,a
	ld	a,-82(ix)
	adc	a,d
	ld	d,a
;	genMinus
;	AOP_EXSTK for _main_sloc3_1_0
;	Shift into pair idx 0
	ld	hl,#4
	add	hl,sp
	ld	a,e
	add	a,#0xFD
	ld	(hl),a
	ld	a,d
	adc	a,#0xFF
	inc	hl
	ld	(hl),a
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_EXSTK for _main_sloc3_1_0
	ld	iy,#6
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
	pop	bc
;main.c:997: if ( strcmp( ext, "tap" ) == 0 || strcmp( ext, "tzx" ) == 0 )
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_27
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcmp
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genIfx
	ld	a,e
	or	a,d
	jr	Z,00147$
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_28
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcmp
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genIfx
	ld	a,e
	or	a,d
	jr	NZ,00148$
;	genLabel
00147$:
;main.c:999: tap_path[0] = sdata[0];
;	genAddrOf
;	AOP_EXSTK for _main_sloc3_1_0
	ld	hl,#0x020E
	add	hl,sp
	ld	iy,#4
	add	iy,sp
	ld	0(iy),l
	ld	1(iy),h
;	genPointerGet
	ld	a,(bc)
;	genAssign (pointer)
;	AOP_EXSTK for _main_sloc3_1_0
;	isBitvar = 0
	ld	l,0(iy)
	ld	h,1(iy)
	ld	(hl),a
;main.c:1000: strcpy( &tap_path[1], &sdata[1] );
;	genPlus
;	AOP_EXSTK for _main_sloc4_1_0
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#2
	add	hl,sp
	ld	a,c
	add	a,#0x01
	ld	(hl),a
	ld	a,b
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;	genPlus
;	AOP_EXSTK for _main_sloc3_1_0
;	genPlusIncr
	ld	e,0(iy)
	ld	d,1(iy)
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_sloc4_1_0
	ld	iy,#2
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:1001: break;
;	genGoto
	jp	00218$
;	genLabel
00148$:
;main.c:1003: else if ( strcmp( ext, "scr" ) == 0 )
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_29
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcmp
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genIfx
	ld	a,e
	or	a,d
	jp	NZ,00145$
;main.c:1005: pport_send( PP_CMD_FCTL( PP_FCTL_OPEN ), 0x40, sdata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7802
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1006: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1008: size = 0;
;	genAssign
;	AOP_EXSTK for _main_size_4_10
	xor	a,a
	ld	iy,#409
	add	iy,sp
	ld	0(iy),a
	ld	1(iy),a
	ld	2(iy),a
	ld	3(iy),a
;main.c:1009: pport_send( PP_CMD_FCTL( PP_FCTL_SEEK ), 4, &size );
;	genAddrOf
	ld	hl,#0x0199
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
	ld	hl,#0x0004
	push	hl
;	genIpush
	ld	hl,#0x7806
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1010: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1012: size = SCR_SIZE;
;	genAssign
;	AOP_EXSTK for _main_size_4_10
	ld	iy,#409
	add	iy,sp
	ld	0(iy),#0x00
	ld	1(iy),#0x1B
	ld	2(iy),#0x00
	ld	3(iy),#0x00
;main.c:1013: pport_send( PP_CMD_FCTL( PP_FCTL_READ ), 4, &size );
;	genAddrOf
	ld	hl,#0x0199
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
	ld	hl,#0x0004
	push	hl
;	genIpush
	ld	hl,#0x7804
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1015: pport_receive( (void*)0x4000, SCR_SIZE );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x1B00
	push	hl
;	genIpush
	ld	hl,#0x4000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1017: getkey();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_getkey
;main.c:1019: init_screen();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_init_screen
;main.c:1020: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;main.c:1021: show_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_sel
;main.c:1022: update_disks( 4 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x04
	push	af
	inc	sp
;	genCall
	call	_update_disks
	inc	sp
;	genGoto
	jp	00217$
;	genLabel
00145$:
;main.c:1024: else if ( strcmp( ext, "sna" ) == 0 )
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#__str_30
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcmp
	ld	d,h
	ld	e,l
	pop	af
	pop	af
	pop	bc
;	genIfx
	ld	a,e
	or	a,d
	jp	NZ,00142$
;main.c:1026: byte i = 0xff;
;	genAssign
	ld	e,#0xFF
;main.c:1028: pport_send( PP_CMD_FCTL( PP_FCTL_OPEN ), 0x40, sdata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	push	bc
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7802
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
	pop	de
;main.c:1029: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
	pop	de
;main.c:1031: pport_send( PP_CMD_CTL( PP_CTL_PROM ), 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x7702
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
	pop	de
;main.c:1032: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
	pop	de
;main.c:1034: while (( KPORT | 0xe0 ) != 0xff ) while ( i-- != 0 );
;	genLabel
00134$:
;	genOr
;Z80 AOP_SFR for _KPORT banked:1 bc:1 de:1
	ld	a,#>_KPORT
	in	a,(#<_KPORT)
	or	a,#0xE0
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	c,a
	inc	a
	jr	Z,00136$
;	genAssign
	ld	c,e
;	genLabel
00131$:
;	genAssign
	ld	b,c
;	genMinus
	dec	c
;	genAssign
	ld	e,c
;	genIfx
	xor	a,a
	or	a,b
	jr	Z,00134$
;	genGoto
	jr	00131$
;	genLabel
00136$:
;main.c:1037: __endasm;
;	genInline
		jp 0x3870;
		    
;	genGoto
	jp	00217$
;	genLabel
00142$:
;main.c:1039: else if ( strcmp( ext, "trd" ) == 0 || strcmp( ext, "fdi" ) == 0 || strcmp( ext, "scl" ) == 0 )
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_31
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcmp
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00137$
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_32
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcmp
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jr	Z,00137$
;	genAddrOf
	ld	hl,#0x019D
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_33
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcmp
	ld	b,h
	ld	c,l
	pop	af
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jp	NZ,00217$
;	genLabel
00137$:
;main.c:1042: ddata[0] = 0; // disk 'a';
;	genAddrOf
	ld	hl,#0x0149
	add	hl,sp
	ld	c,l
	ld	b,h
;	genAssign (pointer)
;	isBitvar = 0
	ld	a,#0x00
	ld	(bc),a
;main.c:1043: strcpy( ddata + 1, path );
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#_path
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
	pop	bc
;main.c:1044: strcat( ddata + 1, name );
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcat
	pop	af
	pop	af
	pop	bc
;main.c:1045: pport_send( PP_CMD_FCTL( PP_FCTL_DSK_OPEN ), 0x40, ddata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7810
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1046: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1052: __endasm;
;	genInline
	
		                   ld bc, #0x0000
		                   push bc
		                   jp 0x3d2d;
		                   
;	genGoto
	jp	00217$
;	genLabel
00209$:
;main.c:1057: else if ( key >= 0x81 && key <= 0x84 )
;	genCmpLt
;	AOP_STK for _main_key_2_2
	ld	a,-81(ix)
	sub	a,#0x81
	jr	C,00205$
;	genCmpGt
;	AOP_STK for _main_key_2_2
	ld	a,#0x84
	sub	a,-81(ix)
	jr	C,00205$
;main.c:1061: ddata = key - 0x81;
;	genMinus
;	AOP_STK for _main_key_2_2
;	AOP_EXSTK for _main_ddata_3_15
;	Shift into pair idx 0
	ld	hl,#328
	add	hl,sp
	ld	a,-81(ix)
	add	a,#0x7F
	ld	(hl),a
;main.c:1062: pport_send( PP_CMD_FCTL( PP_FCTL_DSK_CLOSE ), 1, &ddata );
;	genAddrOf
	ld	hl,#0x0148
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0001
	push	hl
;	genIpush
	ld	hl,#0x7811
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1063: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1064: update_disks( ddata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_ddata_3_15
	ld	iy,#328
	add	iy,sp
	ld	a,0(iy)
	push	af
	inc	sp
;	genCall
	call	_update_disks
	inc	sp
;	genGoto
	jp	00217$
;	genLabel
00205$:
;main.c:1066: else if ( key >= 'a' && key <= 'd' && files_size > 0 )
;	genCmpLt
;	AOP_STK for _main_key_2_2
	ld	a,-81(ix)
	sub	a,#0x61
	jp	C,00200$
;	genCmpGt
;	AOP_STK for _main_key_2_2
	ld	a,#0x64
	sub	a,-81(ix)
	jp	C,00200$
;	genCmpGt
	ld	a,#0x00
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	a,#0x00
	sbc	a,1(iy)
	jp	P,00200$
;main.c:1069: ddata[0] = key - 'a';
;	genAddrOf
	ld	hl,#0x00F8
	add	hl,sp
	ld	c,l
	ld	b,h
;	genMinus
;	AOP_STK for _main_key_2_2
;	AOP_EXSTK for _main_sloc4_1_0
;	Shift into pair idx 0
	ld	hl,#2
	add	hl,sp
	ld	a,-81(ix)
	add	a,#0x9F
	ld	(hl),a
;	genAssign (pointer)
;	AOP_EXSTK for _main_sloc4_1_0
;	isBitvar = 0
	ld	iy,#2
	add	iy,sp
	ld	a,0(iy)
	ld	(bc),a
;main.c:1070: strcpy( ddata + 1, path );
;	genPlus
;	genPlusIncr
	ld	a,c
	add	a,#0x01
	ld	d,a
	ld	a,b
	adc	a,#0x00
	ld	e,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#_path
	push	hl
;	genIpush
	ld	l,d
	ld	h,e
	push	hl
;	genCall
	call	_strcpy
	pop	af
	pop	af
	pop	bc
;main.c:1071: strcat( ddata + 1, name );
;	genPlus
;	genPlusIncr
	ld	e,c
	ld	d,b
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcat
	pop	af
	pop	af
	pop	bc
;main.c:1072: pport_send( PP_CMD_FCTL( PP_FCTL_DSK_OPEN ), 0x40, ddata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7810
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1073: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1074: update_disks( key - 'a' );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_sloc4_1_0
	ld	iy,#2
	add	iy,sp
	ld	a,0(iy)
	push	af
	inc	sp
;	genCall
	call	_update_disks
	inc	sp
;	genGoto
	jp	00217$
;	genLabel
00200$:
;main.c:1076: else if ( key >= 'A' && key <= 'D' )
;	genCmpLt
;	AOP_STK for _main_key_2_2
	ld	a,-81(ix)
	sub	a,#0x41
	jp	C,00196$
;	genCmpGt
;	AOP_STK for _main_key_2_2
	ld	a,#0x44
	sub	a,-81(ix)
	jp	C,00196$
;main.c:1079: word flags = get_flags();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_get_flags
	ld	b,h
	ld	c,l
;	genAssign
;	AOP_EXSTK for _main_flags_3_17
	ld	iy,#246
	add	iy,sp
	ld	0(iy),c
	ld	1(iy),b
;main.c:1081: ddata[0] = key - 'A';
;	genAddrOf
	ld	hl,#0x00F4
	add	hl,sp
	ld	e,l
	ld	d,h
;	genMinus
;	AOP_STK for _main_key_2_2
;	AOP_EXSTK for _main_sloc4_1_0
;	Shift into pair idx 0
	ld	hl,#2
	add	hl,sp
	ld	a,-81(ix)
	add	a,#0xBF
	ld	(hl),a
;	genAssign (pointer)
;	AOP_EXSTK for _main_sloc4_1_0
;	isBitvar = 0
	ld	iy,#2
	add	iy,sp
	ld	a,0(iy)
	ld	(de),a
;main.c:1082: ddata[1] = flags & ( 1 << ddata[0] ) ? 0 : 1;
;	genPlus
;	AOP_EXSTK for _main_sloc5_1_0
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#0
	add	hl,sp
	ld	a,e
	add	a,#0x01
	ld	(hl),a
	ld	a,d
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;	genLeftShift
;	AOP_EXSTK for _main_sloc4_1_0
	ld	a,0(iy)
	inc	a
	push	af
	ld	bc,#0x0001
	pop	af
	jr	00301$
00300$:
	sla	c
	rl	b
00301$:
	dec	a
	jr	NZ,00300$
;	genAnd
;	AOP_EXSTK for _main_flags_3_17
	ld	a,c
	ld	iy,#246
	add	iy,sp
	and	a,0(iy)
	ld	c,a
	ld	a,b
	and	a,1(iy)
;	genIfx
	ld	b,a
	or	a,c
	jr	Z,00221$
;	genAssign
	ld	c,#0x00
;	genGoto
	jr	00222$
;	genLabel
00221$:
;	genAssign
	ld	c,#0x01
;	genLabel
00222$:
;	genAssign (pointer)
;	AOP_EXSTK for _main_sloc5_1_0
;	isBitvar = 0
	ld	iy,#0
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	ld	(hl),c
;main.c:1083: pport_send( PP_CMD_FCTL( PP_FCTL_DSK_WP ), 2, ddata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
	ld	hl,#0x0002
	push	hl
;	genIpush
	ld	hl,#0x7812
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1084: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1085: update_disks( key - 'A' );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_sloc4_1_0
	ld	iy,#2
	add	iy,sp
	ld	a,0(iy)
	push	af
	inc	sp
;	genCall
	call	_update_disks
	inc	sp
;	genGoto
	jp	00217$
;	genLabel
00196$:
;main.c:1087: else if ( key == 0x85 && files_size > 0 )
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x85
	jr	Z,00303$
	jp	00192$
00303$:
;	genCmpGt
	ld	a,#0x00
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	a,#0x00
	sbc	a,1(iy)
	jp	P,00192$
;main.c:1091: strcpy( prompt, "Delete \"" );
;	genAddrOf
	ld	hl,#0x00D9
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_34
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:1092: strcat( prompt, name );
;	genAddrOf
	ld	hl,#0x00D9
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:1093: strcat( prompt, "\"?" );
;	genAddrOf
	ld	hl,#0x00D9
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_35
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:1095: if ( yes_or_no( prompt ) )
;	genAddrOf
	ld	hl,#0x00D9
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_yes_or_no
	ld	b,h
	ld	c,l
	pop	af
;	genIfx
	ld	a,c
	or	a,b
	jp	Z,00160$
;main.c:1098: strcpy( ddata, path );
;	genAddrOf
	ld	hl,#0x0089
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:1099: strcat( ddata, name );
;	genAddrOf
	ld	hl,#0x0089
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:1101: if ( strlen( ddata ) <= 0x40 )
;	genAddrOf
	ld	hl,#0x0089
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genCmpGt
	ld	a,#0x40
	sub	a,c
	ld	a,#0x00
	sbc	a,b
	jp	M,00160$
;main.c:1103: int old_sel = files_sel;
;	genAssign
	ld	bc,(_files_sel)
;main.c:1104: int old_files_table_start = files_table_start;
;	genAssign
;	AOP_EXSTK for _main_old_files_table_start_5_20
	ld	hl,(_files_table_start)
	ld	iy,#135
	add	iy,sp
	ld	0(iy),l
	ld	1(iy),h
;main.c:1106: hide_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	call	_hide_sel
	pop	bc
;main.c:1108: pport_send( PP_CMD_FCTL( PP_FCTL_DEL ), 0x40, ddata );
;	genAddrOf
	ld	hl,#0x0089
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	push	de
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7809
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
	pop	bc
;main.c:1109: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
	pop	bc
;main.c:1111: if (( byte ) pport_result == FR_DENIED )
;	genCast
	ld	iy,#_pport_result
	ld	e,0(iy)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x07
	jr	Z,00305$
	jr	00155$
00305$:
;main.c:1113: text_out_pos_8( "ACCESS DENIED", 9, 4, 0, 0xff );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0xFF00
	push	hl
;	genIpush
	ld	hl,#0x0409
	push	hl
;	genIpush
	ld	hl,#__str_36
	push	hl
;	genCall
	call	_text_out_pos_8
	pop	af
	pop	af
	pop	af
;main.c:1114: set_attr( 0302, 9, 4, 13 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0D04
	push	hl
;	genIpush
	ld	hl,#0x09C2
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;main.c:1116: getkey();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_getkey
;main.c:1117: set_attr( 07, 9, 4, 13 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0D04
	push	hl
;	genIpush
	ld	hl,#0x0907
	push	hl
;	genCall
	call	_set_attr
	pop	af
	pop	af
;	genGoto
	jr	00160$
;	genLabel
00155$:
;main.c:1121: read_dir();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
	call	_read_dir
	pop	bc
;main.c:1123: files_sel = old_sel;
;	genAssign
	ld	iy,#_files_sel
	ld	0(iy),c
	ld	1(iy),b
;main.c:1124: files_table_start = old_files_table_start;
;	genAssign
;	AOP_EXSTK for _main_old_files_table_start_5_20
	ld	iy,#135
	add	iy,sp
	ld	a,0(iy)
	ld	iy,#_files_table_start
	ld	0(iy),a
	ld	iy,#135
	add	iy,sp
	ld	a,1(iy)
	ld	iy,#_files_table_start
	ld	1(iy),a
;	genLabel
00160$:
;main.c:1129: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;main.c:1130: show_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_sel
;	genGoto
	jp	00217$
;	genLabel
00192$:
;main.c:1132: else if ( key == 0x86 && files_size > 0 )
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x86
	jr	Z,00307$
	jp	00188$
00307$:
;	genCmpGt
	ld	a,#0x00
	ld	iy,#_files_size
	sub	a,0(iy)
	ld	a,#0x00
	sbc	a,1(iy)
	jp	P,00188$
;main.c:1137: hide_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_hide_sel
;main.c:1139: if ( input_box( "New filename", name, new_name, 30 ) > 0 )
;	genAddrOf
	ld	hl,#0x0017
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x001E
	push	hl
;	genIpush
	push	bc
;	genIpush
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	ld	hl,#__str_37
	push	hl
;	genCall
	call	_input_box
	ld	b,h
	ld	c,l
	pop	af
	pop	af
	pop	af
	pop	af
;	genCmpGt
	ld	a,#0x00
	sub	a,c
	ld	a,#0x00
	sbc	a,b
	jp	P,00184$
;main.c:1141: if ( new_name[0] != 0 && strlen( path ) + strlen( name ) + 2 <= 0x40 && strlen( path ) + strlen( new_name ) + 2 <= 0x40 )
;	genPointerGet
;	AOP_EXSTK for _main_sloc0_1_0
	ld	iy,#10
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	ld	a,(hl)
;	genIfx
	or	a,a
	jp	Z,00184$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genPlus
	ld	a,c
	add	a,e
	ld	c,a
	ld	a,b
	adc	a,d
	ld	b,a
;	genPlus
;	genPlusIncr
	inc	bc
	inc	bc
;	genCmpGt
	ld	a,#0x40
	sub	a,c
	ld	a,#0x00
	sbc	a,b
	jp	M,00184$
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 1 deSending: 0
	push	bc
;	AOP_EXSTK for _main_sloc0_1_0
	ld	iy,#12
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
	pop	bc
;	genPlus
	ld	a,c
	add	a,e
	ld	c,a
	ld	a,b
	adc	a,d
	ld	b,a
;	genPlus
;	genPlusIncr
	inc	bc
	inc	bc
;	genCmpGt
	ld	a,#0x40
	sub	a,c
	ld	a,#0x00
	sbc	a,b
	jp	M,00184$
;main.c:1143: int old_sel = files_sel;
;	genAssign
;	AOP_EXSTK for _main_old_sel_5_25
	ld	hl,(_files_sel)
	ld	iy,#21
	add	iy,sp
	ld	0(iy),l
	ld	1(iy),h
;main.c:1144: int old_files_table_start = files_table_start;
;	genAssign
;	AOP_EXSTK for _main_old_files_table_start_5_25
	ld	hl,(_files_table_start)
	ld	iy,#19
	add	iy,sp
	ld	0(iy),l
	ld	1(iy),h
;main.c:1148: hide_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_hide_sel
;main.c:1150: strcpy( ddata, path );
;	genAddrOf
	ld	hl,#0x0037
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:1151: strcat( ddata, name );
;	genAddrOf
	ld	hl,#0x0037
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_STK for _main_name_2_2
	ld	l,-83(ix)
	ld	h,-82(ix)
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcat
	pop	af
	pop	af
;main.c:1152: data_part2 = ddata + strlen( ddata ) + 1;
;	genAddrOf
	ld	hl,#0x0037
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 1 bcInUse: 0 deSending: 0
	push	de
	push	de
;	genCall
	call	_strlen
	ld	b,h
	ld	c,l
	pop	af
	pop	de
;	genPlus
	ld	a,e
	add	a,c
	ld	c,a
	ld	a,d
	adc	a,b
	ld	b,a
;	genPlus
;	AOP_EXSTK for _main_data_part2_5_25
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#17
	add	hl,sp
	ld	a,c
	add	a,#0x01
	ld	(hl),a
	ld	a,b
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;main.c:1153: strcpy( data_part2, "_" );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_38
	push	hl
;	genIpush
;	AOP_EXSTK for _main_data_part2_5_25
	ld	iy,#19
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:1155: pport_send( PP_CMD_FCTL( PP_FCTL_RENAME ), 0x40, ddata );
;	genAddrOf
	ld	hl,#0x0037
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7808
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1156: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1161: strcpy( ddata, "_" );
;	genAddrOf
	ld	hl,#0x0037
	add	hl,sp
	ld	e,l
	ld	d,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#__str_38
	push	hl
;	genIpush
	push	de
;	genCall
	call	_strcpy
	pop	af
	pop	af
;main.c:1162: data_part2 = ddata + 2;
;	genAssign
;	AOP_EXSTK for _main_sloc1_1_0
;	AOP_EXSTK for _main_data_part2_5_25
	ld	iy,#8
	add	iy,sp
	ld	a,0(iy)
	ld	iy,#17
	add	iy,sp
	ld	0(iy),a
	ld	iy,#8
	add	iy,sp
	ld	a,1(iy)
	ld	iy,#17
	add	iy,sp
	ld	1(iy),a
;main.c:1164: if( new_name[0] == '/' )
;	genPointerGet
;	AOP_EXSTK for _main_sloc0_1_0
	ld	iy,#10
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	ld	e,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x2F
	jr	Z,00309$
	jr	00177$
00309$:
;main.c:1166: strcpy( data_part2, new_name + 1 );
;	genPlus
;	AOP_EXSTK for _main_sloc0_1_0
;	genPlusIncr
	ld	iy,#10
	add	iy,sp
	ld	e,0(iy)
	ld	d,1(iy)
	inc	de
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	de
;	genIpush
;	AOP_EXSTK for _main_data_part2_5_25
	ld	iy,#19
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genCall
	call	_strcpy
	pop	af
	pop	af
;	genGoto
	jp	00178$
;	genLabel
00177$:
;main.c:1170: byte path_size = strlen( path );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#_path
	push	hl
;	genCall
	call	_strlen
	ld	d,h
	ld	e,l
	pop	af
;	genCast
;	AOP_EXSTK for _main_path_size_6_27
	ld	iy,#16
	add	iy,sp
	ld	0(iy),e
;main.c:1171: char *new_name_ptr = new_name;
;	genAssign
;	AOP_EXSTK for _main_sloc0_1_0
	ld	iy,#10
	add	iy,sp
	ld	b,0(iy)
	ld	c,1(iy)
;	genAssign
;	(registers are the same)
;main.c:1173: while( new_name_ptr[0] == '.' && new_name_ptr[1] == '/' ) new_name_ptr += 2;
;	genAssign
	ld	d,b
;	genLabel
00162$:
;	genPointerGet
	ld	l,d
	ld	h,c
	ld	b,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	sub	a,#0x2E
	jr	Z,00311$
	jr	00281$
00311$:
;	genPlus
;	genPlusIncr
	ld	a,d
	add	a,#0x01
	ld	b,a
	ld	a,c
	adc	a,#0x00
	ld	e,a
;	genPointerGet
	ld	l,b
	ld	h,e
	ld	b,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,b
	sub	a,#0x2F
	jr	Z,00313$
	jr	00281$
00313$:
;	genPlus
;	genPlusIncr
	ld	a,d
	add	a,#0x02
	ld	d,a
	ld	a,c
	adc	a,#0x00
	ld	c,a
;	genGoto
	jr	00162$
;main.c:1174: while( new_name_ptr[0] == '.' && new_name_ptr[1] == '.' && new_name_ptr[2] == '/' )
;	genLabel
00281$:
;	genAssign
;	AOP_EXSTK for _main_new_name_ptr_6_27
	ld	iy,#14
	add	iy,sp
	ld	0(iy),d
	ld	1(iy),c
;	genLabel
00173$:
;	genPointerGet
;	AOP_EXSTK for _main_new_name_ptr_6_27
	ld	iy,#14
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	ld	e,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,e
	sub	a,#0x2E
	jr	Z,00315$
	jp	00175$
00315$:
;	genPlus
;	AOP_EXSTK for _main_new_name_ptr_6_27
;	genPlusIncr
	ld	iy,#14
	add	iy,sp
	ld	e,0(iy)
	ld	d,1(iy)
	inc	de
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	sub	a,#0x2E
	jr	Z,00317$
	jp	00175$
00317$:
;	genPlus
;	AOP_EXSTK for _main_new_name_ptr_6_27
;	genPlusIncr
	ld	iy,#14
	add	iy,sp
	ld	e,0(iy)
	ld	d,1(iy)
	inc	de
	inc	de
;	genPointerGet
	ld	a,(de)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	e,a
	sub	a,#0x2F
	jr	Z,00319$
	jp	00175$
00319$:
;main.c:1176: if( path_size != 0 )
;	genIfx
;	AOP_EXSTK for _main_path_size_6_27
	xor	a,a
	ld	iy,#16
	add	iy,sp
	or	a,0(iy)
	jr	Z,00170$
;main.c:1178: path_size--;
;	genMinus
;	AOP_EXSTK for _main_path_size_6_27
	dec	0(iy)
;main.c:1179: while ( path_size != 0 && path[ path_size - 1 ] != '/' ) path_size--;
;	genLabel
00166$:
;	genIfx
;	AOP_EXSTK for _main_path_size_6_27
	xor	a,a
	ld	iy,#16
	add	iy,sp
	or	a,0(iy)
	jr	Z,00170$
;	genMinus
;	AOP_EXSTK for _main_path_size_6_27
	ld	a,0(iy)
	add	a,#0xFF
;	genPlus
	ld	e, a
	add	a,#<_path
	ld	d,a
	ld	a,#>_path
	adc	a,#0x00
	ld	c,a
;	genPointerGet
	ld	l,d
	ld	h,c
	ld	d,(hl)
;	genCmpEq
; genCmpEq: left 1, right 1, result 0
	ld	a,d
	sub	a,#0x2F
	jr	Z,00170$
;	genAssign
;	(registers are the same)
;	genAssign
;	AOP_EXSTK for _main_path_size_6_27
	ld	iy,#16
	add	iy,sp
	ld	0(iy),e
;	genGoto
	jr	00166$
;	genLabel
00170$:
;main.c:1182: new_name_ptr += 3;
;	genPlus
;	AOP_EXSTK for _main_new_name_ptr_6_27
;	genPlusIncr
;	Shift into pair idx 0
	ld	hl,#14
	add	hl,sp
	ld	a,(hl)
	add	a,#0x03
	inc	hl
	dec	hl
;	Addition result is in same register as operand of next addition.
	push	bc
	ld	c, a
	inc	hl
	ld	a, (hl)
	ld	b, a
	ld	a, c
	dec	hl
	ld	(hl), a
	ld	a, b
	pop	bc
	adc	a,#0x00
	inc	hl
	ld	(hl),a
;	genGoto
	jp	00173$
;	genLabel
00175$:
;main.c:1185: strncpy( data_part2, path, path_size );
;	genCast
;	AOP_EXSTK for _main_path_size_6_27
	ld	iy,#16
	add	iy,sp
	ld	c,0(iy)
	ld	b,#0x00
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#_path
	push	hl
;	genIpush
;	AOP_EXSTK for _main_data_part2_5_25
	ld	iy,#21
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genCall
	call	_strncpy
	pop	af
	pop	af
	pop	af
;main.c:1186: strcpy( data_part2 + path_size, new_name_ptr );
;	genPlus
;	AOP_EXSTK for _main_data_part2_5_25
;	AOP_EXSTK for _main_path_size_6_27
;	Shift into pair idx 0
	ld	hl,#16
	add	hl,sp
	ld	iy,#17
	add	iy,sp
	ld	a,0(iy)
	add	a,(hl)
	ld	c,a
	ld	a,1(iy)
	adc	a,#0x00
	ld	b,a
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_new_name_ptr_6_27
	ld	iy,#14
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genIpush
	push	bc
;	genCall
	call	_strcpy
	pop	af
	pop	af
;	genLabel
00178$:
;main.c:1189: pport_send( PP_CMD_FCTL( PP_FCTL_RENAME ), 0x40, ddata );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_sloc2_1_0
	ld	iy,#6
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7808
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1190: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1195: read_dir();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_read_dir
;main.c:1197: files_sel = old_sel;
;	genAssign
;	AOP_EXSTK for _main_old_sel_5_25
	ld	iy,#21
	add	iy,sp
	ld	a,0(iy)
	ld	iy,#_files_sel
	ld	0(iy),a
	ld	iy,#21
	add	iy,sp
	ld	a,1(iy)
	ld	iy,#_files_sel
	ld	1(iy),a
;main.c:1198: files_table_start = old_files_table_start;
;	genAssign
;	AOP_EXSTK for _main_old_files_table_start_5_25
	ld	iy,#19
	add	iy,sp
	ld	a,0(iy)
	ld	iy,#_files_table_start
	ld	0(iy),a
	ld	iy,#19
	add	iy,sp
	ld	a,1(iy)
	ld	iy,#_files_table_start
	ld	1(iy),a
;	genLabel
00184$:
;main.c:1202: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;main.c:1203: show_sel();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_sel
;	genGoto
	jp	00217$
;	genLabel
00188$:
;main.c:1205: else if ( key == 0x87 )
;	genCmpEq
;	AOP_STK for _main_key_2_2
; genCmpEq: left 1, right 1, result 0
	ld	a,-81(ix)
	sub	a,#0x87
	jr	Z,00322$
	jp	00217$
00322$:
;main.c:1207: word flags = get_flags();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_get_flags
	ld	b,h
	ld	c,l
;main.c:1208: flags ^= CFG_FLG_STROM1;
;	genXor
;	AOP_EXSTK for _main_flags_3_30
	ld	a,c
	xor	a,#0x20
	ld	iy,#12
	add	iy,sp
	ld	0(iy),a
	ld	1(iy),b
;main.c:1209: pport_send( PP_CMD_FCTL( PP_FCTL_CFG_SFLAGS ), sizeof( flags ), &flags );
;	genAddrOf
	ld	hl,#0x000C
	add	hl,sp
	ld	c,l
	ld	b,h
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	push	bc
;	genIpush
	ld	hl,#0x0002
	push	hl
;	genIpush
	ld	hl,#0x7822
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1210: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1213: init_screen();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_init_screen
;main.c:1214: update_disks( 4 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	a,#0x04
	push	af
	inc	sp
;	genCall
	call	_update_disks
	inc	sp
;main.c:1215: show_table();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_show_table
;	genGoto
	jp	00217$
;	genLabel
00218$:
;main.c:1219: pport_send( PP_CMD_FCTL( PP_FCTL_OPEN ), 0x40, tap_path );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
;	AOP_EXSTK for _main_sloc3_1_0
	ld	iy,#4
	add	iy,sp
	ld	l,0(iy)
	ld	h,1(iy)
	push	hl
;	genIpush
	ld	hl,#0x0040
	push	hl
;	genIpush
	ld	hl,#0x7802
	push	hl
;	genCall
	call	_pport_send
	pop	af
	pop	af
	pop	af
;main.c:1220: pport_receive( 0, 0 );
;	genIpush
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	ld	hl,#0x0000
	push	hl
;	genIpush
	ld	hl,#0x0000
	push	hl
;	genCall
	call	_pport_receive
	pop	af
	pop	af
;main.c:1221: pport_close();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_pport_close
;main.c:1223: halt();
;	genCall
; _saveRegsForCall: sendSetSize: 0 deInUse: 0 bcInUse: 0 deSending: 0
	call	_halt
;	genLabel
;	genEndFunction
	ld	sp,ix
	pop	ix
	ret
_main_end::
__str_23:
	.ascii "boot.tap"
	.db 0x00
__str_24:
	.db 0x00
__str_25:
	.ascii ".."
	.db 0x00
__str_26:
	.ascii "/"
	.db 0x00
__str_27:
	.ascii "tap"
	.db 0x00
__str_28:
	.ascii "tzx"
	.db 0x00
__str_29:
	.ascii "scr"
	.db 0x00
__str_30:
	.ascii "sna"
	.db 0x00
__str_31:
	.ascii "trd"
	.db 0x00
__str_32:
	.ascii "fdi"
	.db 0x00
__str_33:
	.ascii "scl"
	.db 0x00
__str_34:
	.ascii "Delete "
	.db 0x22
	.db 0x00
__str_35:
	.db 0x22
	.ascii "?"
	.db 0x00
__str_36:
	.ascii "ACCESS DENIED"
	.db 0x00
__str_37:
	.ascii "New filename"
	.db 0x00
__str_38:
	.ascii "_"
	.db 0x00
	.area _CODE
	.area _CABS
