 DEVICE	ZXSPECTRUM128
 SLOT	0
 
 org	#0000
	incbin	"..\48.rom"

 org	#0038
	ret
 org	#0060
	jp	#3870
 org	#0066
	jr	#0060
 org	#3EFF
	dw	#3F01
 org	#3F01
	inc	a
	ret

 macro	pport_wr
	out	(#1F), a
 endm
 macro	pport_rd
	in	a, (#1F)
 endm

 macro	call_np	addr
	ld	iy, $+4+3
	jp	addr
 endm
 macro	ret_np
	jp	iy
 endm

 org	#3870	
	//--------------------------------------------
	//  save context -----------------------------
	//--------------------------------------------

	ld	( #57e0 + #17 ), sp
	ld	sp, #57e0 + #17
	push	af
	push	af

	ld	a, ( #5ae0 )
	rra
	rra
	rra
	ld	( #57e0 + #1a ), a

	ld	a, i
	ld	( #57e0 ), a

	ld	a, r
	ld	( #57e0 + #14 ), a

	ld	a, #0
	jp	PO, int_en
	dec	a

int_en:
	ld	( #57e0 + #13 ), a

	ld	a, #3e
	ld	i, a

	ld	a, #1
	ei
	halt
	ld	( #57e0 + #19 ), a

	push	ix
	push	iy
	push	bc
	push	de
	push	hl
	ex	af,af'
	push	af
	exx
	push	bc
	push	de
	push	hl

	//--------------------------------------------
	//  test read --------------------------------
	//--------------------------------------------

	ld	bc, 0
	exx

	xor	a
	out	( #fe ), a

	//pport_send( #7700 );
	ld	a, #77
	pport_wr
	ld	a, #00
	pport_wr
	xor	a
	pport_wr
	pport_wr

	pport_rd
	cp	#73
	jp	NZ, restore_context

	//pport_send( #7804, 4, "\x02\x00\x00\x00" );
	ld	a, #78
	pport_wr
	ld	a, #04
	pport_wr
	pport_wr
	xor	a
	pport_wr

	ld	a, #02
	pport_wr
	xor	a
	pport_wr
	pport_wr
	pport_wr

	//pport_receive( bc );
	pport_rd
	pport_rd
	pport_rd
	ld	c, a
	pport_rd
	or	c

	jp	NZ, load_snapshot

	//--------------------------------------------
	//  save snapshot ----------------------------
	//--------------------------------------------
save_snapshot:
	//pport_send( #7805, 4, "\x1b\x0\x0\x0" );
	ld	a, #78
	pport_wr
	ld	a, #05
	pport_wr
	ld	a, #04
	pport_wr
	xor	a
	pport_wr

	ld	a, #1b
	pport_wr
	xor	a
	pport_wr
	pport_wr
	pport_wr

	//byte *pos = (byte*) #57e0;
	//while( pport_datasize-- != 0 ) PPORT = *pos++;

	ld	hl, #57e0
	ld	bc, #001b
start3:
	ld	a, b
	or	c
	jr	Z, end3

	ld	a, (hl)
	pport_wr
	inc	hl
	dec	bc
	jr	start3
end3:

	//pport_send( #7805, 4, "\x00\xc0\x0\x0" );
	ld	a, #78
	pport_wr
	ld	a, #05
	pport_wr
	ld	a, #04
	pport_wr
	xor	a
	pport_wr

	pport_wr
	ld	a, #c0
	pport_wr
	xor	a
	pport_wr
	pport_wr

	//byte *pos = (byte*) #4000;
	//while( pport_datasize-- != 0 ) PPORT = *pos++;

	ld	hl, #4000
	ld	bc, #c000
start4:
	ld	a, b
	or	c
	jr	Z, end4

	ld	a, c
	and	#3f
	jr	NZ, noout4
	ld	a, #2
	out	(#fe), a

noout4:
	ld	a, (hl)
	pport_wr

	ld	a, #0
	out	(#fe), a

	inc	hl
	dec	bc

/*
	ld	a, c
	and	#3f
	jr	Z, out4
	ld	a, #fe

out4:
	inc	a
	inc	a
	out	(#fe), a
*/

	jr	start4
end4:
	jp	close_pport

	//--------------------------------------------
	//  load snapshot ----------------------------
	//--------------------------------------------

load_snapshot:
	// determine if snapshot is 128k
	ld	de, #0000
	ld	bc, #C01B
	call_np	file_seek

	ld	bc, #0004
	call_np	read_file_start
	ld	a, c
	cp	3
	jr	c, .snap_48

	ld	hl, #8000
	call_np	read_file_receive	// receive PC, 7FFD, TR-DOS flag

	ld	hl, #8000 + 2
	ld	a, (hl)
	and	#07
	ld	d, a
	ld	e, 0

.check_page
	ld	a, d
	cp	e
	jr	nz,$+2+1+2
	inc	e
	jr	.check_page

	ld	a, 5
	cp	e
	jr	nz,$+2+1+2
	inc	e
	jr	.check_page

	ld	a, 2
	cp	e
	jr	nz,$+2+1+2
	inc	e
	jr	.check_page

	ld	a, 7
	cp	e
	jr	c, .set_mode

	ld	a, e
	ld	bc, #7FFD
	out	(c), a	

	ld	bc, #4000
	call_np	read_file_start
	ld	hl, #C000
	call_np	read_file_receive

	inc	e
	jr	.check_page

.set_mode
	ld	de, (#8000)	// PC
	ld	bc, (#8002)	// 7FFD & TR-DOS flag
	ld	a, c
	ld	c, 1	// 128k snap
	jr	.load_lowmem
	
.snap_48
	ld	a, #10
	ld	bc, 0	//  48k snap	
	
.load_lowmem
	exx
	ld	bc, #7FFD
	out	(c), a

	ld	de, #0000
	ld	bc, #001B
	call_np	file_seek

	ld	bc, #C000
	call_np	read_file_start

	ld	hl, #4000
	call_np	read_file_receive

	ld	de, #0000
	ld	bc, #0000
	call_np	file_seek

	ld	bc, #001B
	call_np	read_file_start

	//byte *pos = (byte*) #57e0;
	//while( pport_datasize-- != 0 ) *pos++ = PPORT;

	ld	hl, #57e0
	call_np	read_file_receive

close_pport:
	//pport_send0( #7803 );

	ld	a, #78
	pport_wr
	ld	a, #03
	pport_wr
	xor	a
	pport_wr
	pport_wr

	//pport_send0( #7701 );
	//pport_receive0();

	ld	a, #77
	pport_wr
	ld	a, #01
	pport_wr
	xor	a
	pport_wr
	pport_wr

	pport_rd
	pport_rd
	pport_rd
	pport_rd

	//--------------------------------------------
	//  restore context --------------------------
	//--------------------------------------------

restore_context:	
	ld	sp, #57e1
	pop hl
	pop de
	pop bc
	exx

	ld	a, #d3								 // pport_wr
	ld	( #57E1 + 0 ), a
	ld	a, #1f
	ld	( #57E1 + 1 ), a
	ld	a, #fb								 // ei (if need)
	ld	( #57E1 + 2 ), a

	ld	a, c
	or	a
	jr	z, .restore_ret

	ld	a, #c3								 // jp	xxxx
	ld	( #57E1 + 3 ), a

	ld	a, b
	or	a
	jr	z, .restore_jp

	ld	sp, (#57E0+#17)
	push	de
	ld	(#57E0+#17), sp
	ld	sp, #57E1 + 6
	ld	de, #3D2F

.restore_jp
	ld	(#57E1 + 4), de
	jr	.load_regs

.restore_ret
	ld	a, #c9								 // ret
	ld	( #57E1 + 3 ), a

.load_regs
	pop af
	ex	af,af'
	pop hl
	pop de
	pop bc
	pop iy
	pop ix
	pop af

	ld	a, ( #57e0 + #1a )
	out	( #fe ), a

	ld	a, ( #57e0 )
	ld	i, a
	ld	a, ( #57e0 + #14 )
	ld	r, a

	ld	a, ( #57e0 + #19 )
	sub	#02
	jr	Z, im2

	im 1
	jr	no_im2

im2:
	im 2

no_im2:
	ld	a, ( #57e0 + #13 )
	and	#04
	jr	NZ, set_ei

	xor	a
	ld	( #57E1 + 2 ), a

set_ei:
	pop af
	ld	sp, ( #57e0 + #17 )
	jp	#57E1

// file_seek
// bc,de - position
file_seek
	//pport_send( #7806, 4, bc, de );
	ld	a, #78
	pport_wr
	ld	a, #06
	pport_wr
	ld	a, #04
	pport_wr
	xor	a
	pport_wr

	ld	a, c
	pport_wr
	ld	a, b
	pport_wr
	ld	a, e
	pport_wr
	ld	a, d
	pport_wr

	ret_np

// read_file_start
// bc - bytes to be read
read_file_start:
	//pport_send( #7804, 4, bc,"\x00\x00" );
	ld	a, #78
	pport_wr
	ld	a, #04
	pport_wr
	pport_wr
	xor	a
	pport_wr

	ld	a, c
	pport_wr
	ld	a, b
	pport_wr
	xor	a
	pport_wr
	pport_wr

	//pport_receive( bc );
	pport_rd
	pport_rd
	pport_rd
	ld	c, a
	pport_rd
	ld	b, a
	ret_np

; read file
; hl - address to read
read_file_receive:
	ld	a, b
	or	c
	jr	Z, .end

	ld	a, c
	and	#3f
	jr	NZ, .noout
	ld	a, #1
	out	(#fe), a

.noout:
	pport_rd
	ld	(hl), a

	ld	a, #0
	out	(#fe), a

	inc	hl
	dec	bc

	jr	read_file_receive
.end
	ret_np

 savebin	"..\patch.rom",0x0000,0x4000