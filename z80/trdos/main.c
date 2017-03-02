#include<string.h>

void main()
{
__asm
    ld bc, #0x0000
    push bc
    jp 0x3d2d;
__endasm;
}

