
as-z80.exe -o crt0.o  crt0.s
sdcc -mz80 --verbose --opt-code-size --no-std-crt0 --data-loc 0xAC00 --code-loc 0x8000 -c txtcore.c
sdcc -mz80 --verbose --opt-code-size --no-std-crt0 --data-loc 0xAC00 --code-loc 0x8000 -c main.c
sdcc -mz80 --verbose --opt-code-size --no-std-crt0 --data-loc 0xAC00 --code-loc 0x8000 -o .\bin\ main.o crt0.o txtcore.o

.\loader\hex2bin .\bin\main.ihx
.\loader\bin2sna bin\myboot.sna loader\loader.sna bin\main.bin

rem del *.rel
rem del *.o
rem del *.lst
rem del *.asm
rem del *.sym
