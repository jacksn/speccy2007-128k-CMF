	DEVICE	ZXSPECTRUM128
	SLOT	0
 
	macro	pport_wr src
		ld a, src
		out	(#1F), a
	endm

	macro	pport_wr_a
		out	(#1F), a
	endm

	macro	pport_rd_a
		in	a, (#1F)
	endm

	org	#0004
		jp	saved_start
 		nop

	org	#0008
 		jp	io_handler

	org	#2A35
		ld 		hl, loc_2A41_copy

	org	#0880

loc_2A41_copy:
		ld      a, (#03B5)
		cp      #F3
		ld      a, #10
		jr      z, loc_2A4B
		xor     a

loc_2A4B:
		ld      (#5C01), a
		ld      bc, #7FFD
		ld      a, #10
		out     (c), a
		ret

saved_start:
		ld a, 7
		out (#fe), a
		jp #000b

io_handler:
		push af
		push hl

		ld hl, 4
		add hl, sp

		push bc
		ld c, (hl)
		inc hl
		ld b, (hl)

		dec bc
		ld a, (bc)
		cp #cf
        jr nz, io_handler_exit

        inc bc
		ld a, (bc)
		rla

        inc bc
        ld (hl), b
        dec hl
        ld (hl), c

		ld b, 0
		ld c, a

		ld hl, io_table
		add hl, bc

		ld bc, (hl)

		push bc
		pop hl

		pop bc
		jp hl

io_handler_exit:
		rst 0

io_type_1FD3:		; out (#1f), a
	pop hl
	pport_wr #79
	pport_wr #1f
	pport_wr #00
	pop af
	pport_wr_a
	ret

io_type_3FD3:		; out (#3f), a
	pop hl
	pport_wr #79
	pport_wr #3f
	pport_wr #00
	pop af
	pport_wr_a
	ret

io_type_5FD3:		; out (#5f), a
	pop hl
	pport_wr #79
	pport_wr #5f
	pport_wr #00
	pop af
	pport_wr_a
	ret

io_type_7FD3:		; out (#7f), a
	pop hl
	pport_wr #79
	pport_wr #7f
	pport_wr #00
	pop af
	pport_wr_a
	ret

io_type_FFD3:		; out (#ff), a
	pop hl
	pport_wr #79
	pport_wr #ff
	pport_wr #00
	pop af
	pport_wr_a
	ret

io_type_51ED:		; out (c), d
	pop hl
	pport_wr #79
	pport_wr c
	pport_wr b
	pport_wr d
	pop af
	ret

io_type_79ED:		; out (c), a
	pop hl
	pport_wr #79
	pport_wr c
	pport_wr b
	pop af
	pport_wr_a
	ret

io_type_1FDB:		; in a, (#1f)
	pop hl
	pport_wr #80
	pport_wr #1f
	pport_wr #00
	pport_wr_a
	pop af
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ret

io_type_3FDB:		; in a, (#3f)
	pop hl
	pport_wr #80
	pport_wr #3f
	pport_wr #00
	pport_wr_a
	pop af
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ret

io_type_5FDB:		; in a, (#5f)
	pop hl
	pport_wr #80
	pport_wr #5f
	pport_wr #00
	pport_wr_a
	pop af
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ret

io_type_7FDB:		; in a, (#7f)
	pop hl
	pport_wr #80
	pport_wr #7f
	pport_wr #00
	pport_wr_a
	pop af
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ret

io_type_FFDB:		; in a, (#ff)
	pop hl
	pport_wr #80
	pport_wr #ff
	pport_wr #00
	pport_wr_a
	pop af
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ret

io_type_60ED:		; in h, (c)
	pop hl
	pport_wr #80
	pport_wr c
	pport_wr b
	pport_wr #00
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ld h, a
	pop af    
	ret

io_type_A3ED:		; outi
	pop hl
	pport_wr #79
	pport_wr c
	pport_wr b
	pport_wr (hl)
	pop af
	inc hl
	dec b
	ret

io_type_A2ED:		; ini
	pop hl
	pport_wr #80
	pport_wr c
	pport_wr b
	pport_wr 0
	pport_rd_a
	pport_rd_a
	pport_rd_a
	pport_rd_a
	ld (hl), a
	pop af
	inc hl
	dec b
	ret
	
