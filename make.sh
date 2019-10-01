#!/bin/sh

set -e
set -x
bcc -c -ansi NUT.c -o NUT.o
ld86 -d -T0x7e00 NUT.o -o NUT.bin
nasm NUT.asm -f bin -o NUT.img
exit 0
