org 0x7c00
bits 16

cli
cld
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7bf0
nop
nop
jmp 0x0000:adjust_cs
adjust_cs:
nop
sti

mov ax, 16      ; count
push ax
mov ax, 1       ; from sect 1
push ax
mov ax, 0       ; head 0
push ax
push ax         ; cyl 0
mov ax, 0x7c00  ; buf
push ax
mov ax, 0
push ax         ; seg
xor dh, dh
push dx         ; drive
call bios_floppy_load_sectors_chs
add sp, 7*2
test ax, ax

jnz err

jmp NUT

err:
    mov ah, 0x0e
    mov al, '!'
    int 0x10
    jmp $

; int bios_floppy_load_sectors_chs(int drive, unsigned int seg, void *buf, int cyl, int head, int sect, int count)
bios_floppy_load_sectors_chs:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    mov ax, [bp+14]
    mov cl, al
    mov ax, [bp+12]
    mov dh, al
    mov ax, [bp+10]
    mov ch, al
    mov ax, [bp+8]
    mov bx, ax
    mov ax, [bp+6]
    mov es, ax
    mov ax, [bp+4]
    mov dl, al
    mov ax, [bp+16]
    mov ah, 0x02
    clc
    int 0x13
    jc .failure
    xor ax, ax
    jmp .done
  .failure:
    xor ax, ax
    inc ax
  .done:
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

times 510-($-$$) db 0
dw 0xaa55

NUT:
incbin 'NUT.bin'

times 2880*512-($-$$) db 0
