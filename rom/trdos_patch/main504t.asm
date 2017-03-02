	DEVICE	ZXSPECTRUM128
	SLOT	0
 
	org	#0000
		incbin	"trdos504t.rom"

	include "main.asm"
	include "result504t.asm"

	savebin	"trdos504t_sp2k7.rom",0x0000,0x4000
