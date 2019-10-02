#!/bin/sh

set -e
set -x

export PATH="$(pwd)/toolchain/bin:$PATH"

CC=ia16-elf-gcc

CHARDFLAGS="-ffreestanding -I."
CFLAGS="-pipe -O2 -Wall -Wextra"
LDHARDFLAGS="-nostdlib -lgcc -static-libgcc -T linker.ld"
LDFLAGS="-O2"

${CC} ${CFLAGS} ${CHARDFLAGS} -c NUT.c -o NUT.o
${CC} NUT.o ${LDHARDFLAGS} ${LDFLAGS} -o NUT.bin

nasm NUT.asm -f bin -o NUT.img
