io_table:
	dw io_type_FFD3
	dw io_type_3FD3
	dw io_type_1FDB
	dw io_type_1FD3
	dw io_type_5FD3
	dw io_type_FFDB
	dw io_type_51ED
	dw io_type_7FD3
	dw io_type_79ED
	dw io_type_5FDB
	dw io_type_3FDB
	dw io_type_60ED
	dw io_type_7FDB
	dw io_type_A3ED
	dw io_type_A2ED

; 0x02BE - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#02BE
		db	#CF, #00

; 0x1E3A - ( D3 3F ) - out (#3f), a - io_type_3FD3
	org	#1E3A
		db	#CF, #01

; 0x1FDD - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#1FDD
		db	#CF, #02

; 0x1FF3 - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#1FF3
		db	#CF, #00

; 0x2000 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#2000
		db	#CF, #03

; 0x2076 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#2076
		db	#CF, #02

; 0x2085 - ( D3 3F ) - out (#3f), a - io_type_3FD3
	org	#2085
		db	#CF, #01

; 0x208D - ( D3 5F ) - out (#5f), a - io_type_5FD3
	org	#208D
		db	#CF, #04

; 0x2093 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#2093
		db	#CF, #03

; 0x2099 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#2099
		db	#CF, #02

; 0x20B1 - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#20B1
		db	#CF, #05

; 0x20B8 - ( ED 51 ) - out (c), d - io_type_51ED
	org	#20B8
		db	#CF, #06

; 0x2740 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#2740
		db	#CF, #02

; 0x2748 - ( D3 7F ) - out (#7f), a - io_type_7FD3
	org	#2748
		db	#CF, #07

; 0x2A53 - ( ED 79 ) - out (c), a - io_type_79ED
	org	#2A53
		db	#CF, #08

; 0x2A71 - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#2A71
		db	#CF, #00

; 0x2A77 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#2A77
		db	#CF, #02

; 0x2AD9 - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#2AD9
		db	#CF, #00

; 0x2B25 - ( DB 5F ) - in a, (#5f) - io_type_5FDB
	org	#2B25
		db	#CF, #09

; 0x2B68 - ( ED 51 ) - out (c), d - io_type_51ED
;	org	#2B68
;		db	#CF, #06

; 0x2B7A - ( ED 51 ) - out (c), d - io_type_51ED
;	org	#2B7A
;		db	#CF, #06

; 0x2C07 - ( DB 5F ) - in a, (#5f) - io_type_5FDB
	org	#2C07
		db	#CF, #09

; 0x2C19 - ( ED 79 ) - out (c), a - io_type_79ED
;	org	#2C19
;		db	#CF, #08

; 0x2C6A - ( ED 79 ) - out (c), a - io_type_79ED
;	org	#2C6A
;		db	#CF, #08

; 0x2CD8 - ( DB 5F ) - in a, (#5f) - io_type_5FDB
	org	#2CD8
		db	#CF, #09

; 0x2D75 - ( D3 5F ) - out (#5f), a - io_type_5FD3
	org	#2D75
		db	#CF, #04

; 0x2D80 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#2D80
		db	#CF, #03

; 0x2D87 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#2D87
		db	#CF, #02

; 0x2DEC - ( ED 79 ) - out (c), a - io_type_79ED
;	org	#2DEC
;		db	#CF, #08

; 0x2E21 - ( ED 79 ) - out (c), a - io_type_79ED
;	org	#2E21
;		db	#CF, #08

; 0x2EF4 - ( ED 79 ) - out (c), a - io_type_79ED
;	org	#2EF4
;		db	#CF, #08

; 0x2F0C - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#2F0C
		db	#CF, #00

; 0x2F1D - ( D3 5F ) - out (#5f), a - io_type_5FD3
	org	#2F1D
		db	#CF, #04

; 0x2F28 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#2F28
		db	#CF, #03

; 0x2F2F - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#2F2F
		db	#CF, #02

; 0x2F3C - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#2F3C
		db	#CF, #00

; 0x2F4D - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#2F4D
		db	#CF, #00

; 0x2F50 - ( D3 7F ) - out (#7f), a - io_type_7FD3
	org	#2F50
		db	#CF, #07

; 0x2F57 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#2F57
		db	#CF, #03

; 0x2F59 - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#2F59
		db	#CF, #05

; 0x2FB1 - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#2FB1
		db	#CF, #00

; 0x2FC3 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#2FC3
		db	#CF, #03

; 0x3D4D - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#3D4D
		db	#CF, #00

; 0x3D9A - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#3D9A
		db	#CF, #03

; 0x3DA6 - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3DA6
		db	#CF, #05

; 0x3DB5 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#3DB5
		db	#CF, #02

; 0x3DBA - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#3DBA
		db	#CF, #02

; 0x3DD5 - ( D3 FF ) - out (#ff), a - io_type_FFD3
	org	#3DD5
		db	#CF, #00

; 0x3E30 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#3E30
		db	#CF, #02

; 0x3E3A - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#3E3A
		db	#CF, #02

; 0x3E44 - ( D3 7F ) - out (#7f), a - io_type_7FD3
	org	#3E44
		db	#CF, #07

; 0x3E4C - ( D3 7F ) - out (#7f), a - io_type_7FD3
	org	#3E4C
		db	#CF, #07

; 0x3E50 - ( DB 3F ) - in a, (#3f) - io_type_3FDB
	org	#3E50
		db	#CF, #0A

; 0x3E78 - ( DB 3F ) - in a, (#3f) - io_type_3FDB
	org	#3E78
		db	#CF, #0A

; 0x3E7E - ( D3 3F ) - out (#3f), a - io_type_3FD3
	org	#3E7E
		db	#CF, #01

; 0x3E87 - ( DB 3F ) - in a, (#3f) - io_type_3FDB
	org	#3E87
		db	#CF, #0A

; 0x3E95 - ( D3 3F ) - out (#3f), a - io_type_3FD3
	org	#3E95
		db	#CF, #01

; 0x3EB5 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#3EB5
		db	#CF, #02

; 0x3EBC - ( DB 3F ) - in a, (#3f) - io_type_3FDB
	org	#3EBC
		db	#CF, #0A

; 0x3EC9 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#3EC9
		db	#CF, #03

; 0x3ECE - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3ECE
		db	#CF, #05

; 0x3EDF - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#3EDF
		db	#CF, #03

; 0x3EF3 - ( ED 60 ) - in h, (c) - io_type_60ED
	org	#3EF3
		db	#CF, #0B

; 0x3EF5 - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3EF5
		db	#CF, #05

; 0x3EFE - ( DB 7F ) - in a, (#7f) - io_type_7FDB
	org	#3EFE
		db	#CF, #0C

; 0x3F1B - ( D3 5F ) - out (#5f), a - io_type_5FD3
	org	#3F1B
		db	#CF, #04

; 0x3F25 - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#3F25
		db	#CF, #03

; 0x3F33 - ( DB 1F ) - in a, (#1f) - io_type_1FDB
	org	#3F33
		db	#CF, #02

; 0x3F4D - ( D3 1F ) - out (#1f), a - io_type_1FD3
	org	#3F4D
		db	#CF, #03

; 0x3F55 - ( DB 3F ) - in a, (#3f) - io_type_3FDB
	org	#3F55
		db	#CF, #0A

; 0x3F5A - ( DB 5F ) - in a, (#5f) - io_type_5FDB
	org	#3F5A
		db	#CF, #09

; 0x3F69 - ( DB 3F ) - in a, (#3f) - io_type_3FDB
	org	#3F69
		db	#CF, #0A

; 0x3F72 - ( DB 5F ) - in a, (#5f) - io_type_5FDB
	org	#3F72
		db	#CF, #09

; 0x3FBC - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3FBC
		db	#CF, #05

; 0x3FCA - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3FCA
		db	#CF, #05

; 0x3FD1 - ( ED A3 ) - outi - io_type_A3ED
	org	#3FD1
		db	#CF, #0D

; 0x3FD7 - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3FD7
		db	#CF, #05

; 0x3FE5 - ( DB FF ) - in a, (#ff) - io_type_FFDB
	org	#3FE5
		db	#CF, #05

; 0x3FEC - ( ED A2 ) - ini - io_type_A2ED
	org	#3FEC
		db	#CF, #0E

