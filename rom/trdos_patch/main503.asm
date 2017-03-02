	DEVICE	ZXSPECTRUM128
	SLOT	0
 
	org	#0000
		incbin	"trdos503.rom"

	include "main.asm"
	include "result503.asm"

	savebin	"trdos503_sp2k7.rom",0x0000,0x4000
