        .module crt0
       	.globl	_main

    ;;-----------------------------------------------------------
	;; Ordering of segments for the linker.
	;;-----------------------------------------------------------

	.area	_CODE
        .area   _GSINIT
        .area   _GSFINAL

	.area	_DATA
        .area   _BSS
        .area   _HEAP

    ;;-----------------------------------------------------------
    ;; statrup
    ;;-----------------------------------------------------------

	.area	_CODE
    	di
        call    gsinit
        jp      _main

    ;;-----------------------------------------------------------
    ;; Initialise global variables
    ;;-----------------------------------------------------------

        .area   _GSINIT
gsinit::

        .area   _GSFINAL
        ret


