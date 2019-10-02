! 1 
! 1 # 1 "NUT.c"
! 1 void kmain();
!BCC_EOS
! 2 
! 3 int x, y;
!BCC_EOS
! 4 
! 5 int main()
! 6 # 5 "NUT.c"
! 5 {
export	_main
_main:
! 6     kmain();
push	bp
mov	bp,sp
push	di
push	si
! Debug: func () void = kmain+0 (used reg = )
call	_kmain
!BCC_EOS
! 7 
! 8     for (;;);
!BCC_EOS
!BCC_EOS
.3:
!BCC_EOS
! 9 }
.2:
jmp	.3
.1:
pop	si
pop	di
pop	bp
ret
! 10 
! 11 void clear_screen()
! 12 # 11 "NUT.c"
! 11 {
export	_clear_screen
_clear_screen:
! 12 #asm
!BCC_ASM
	push ax
	mov ah, #$0
	mov al, #$03 
	int #$10
	pop ax
! 18 endasm
!BCC_ENDASM
! 19 }
ret
! 20 
! 21 void set_background(c)
! 22 # 21 "NUT.c"
! 21 char c;
export	_set_background
_set_background:
!BCC_EOS
! 22 # 21 "NUT.c"
! 21 {
! 22 #asm
!BCC_ASM
_set_background.c	set	2
	push bp
    mov bp, sp
    push ax
	mov bl, [bp+4]
	mov bh, #$0
    mov ah, #$0b
    int #$10
    pop ax
    pop bp
! 32 endasm
!BCC_ENDASM
! 33 }
ret
! 34 
! 35 void bios_set_cursor(col,row)
! 36 # 35 "NUT.c"
! 35 int col;
export	_bios_set_cursor
_bios_set_cursor:
!BCC_EOS
! 36 # 35 "NUT.c"
! 35 int row;
!BCC_EOS
! 36 # 35 "NUT.c"
! 35 {
! 36 #asm
!BCC_ASM
_bios_set_cursor.col	set	2
_bios_set_cursor.row	set	4
    push bp
    mov bp, sp
    push ax
    mov dl, [bp+4]
    mov dh, [bp+6]
    mov ah, #$02
    int #$10
    pop ax
    pop bp
! 46 endasm
!BCC_ENDASM
! 47 }
ret
! 48 
! 49 void bios_putchar(c,color)
! 50 # 49 "NUT.c"
! 49 char c;
export	_bios_putchar
_bios_putchar:
!BCC_EOS
! 50 # 49 "NUT.c"
! 49 char color;
!BCC_EOS
! 50 # 49 "NUT.c"
! 49 {
! 50 
! 51 
! 52 	return;
push	bp
mov	bp,sp
push	di
push	si
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 53 #asm
!BCC_EOS
!BCC_ASM
_bios_putchar.color	set	$A
.bios_putchar.color	set	6
_bios_putchar.c	set	8
.bios_putchar.c	set	4
	push bx
	push es
	mov bx, (0xb8000)
	mov es, ax
	mov al, #$40
	mov ah, #$20
	mov bx, 0
! 61  69
	 
! 70  79
 	 
! 80  90
	 
! 91  96
	 

    pop ax
    pop bp
! 100 endasm
!BCC_ENDASM
!BCC_EOS
! 101 }
! 102 
! 103 void bios_puts(str,color)
! 104 # 103 "NUT.c"
! 103 char *str;
export	_bios_puts
_bios_puts:
!BCC_EOS
! 104 # 103 "NUT.c"
! 103 char color;
!BCC_EOS
! 104 # 103 "NUT.c"
! 103 {
! 104     int i;
!BCC_EOS
! 105 
! 106     for (i = 0; str[i]; i++) {
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .6
.7:
! 107         bios_putchar(str[i],color);
! Debug: list char color = [S+8+4] (used reg = )
mov	al,6[bp]
xor	ah,ah
push	ax
! Debug: ptradd int i = [S+$A-8] to * char str = [S+$A+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
! Debug: list char = [bx+0] (used reg = )
mov	al,[bx]
xor	ah,ah
push	ax
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 108     }
! 109 
! 110     return;
.5:
! Debug: postinc int i = [S+8-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
.6:
! Debug: ptradd int i = [S+8-8] to * char str = [S+8+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
mov	al,[bx]
test	al,al
jne	.7
.8:
.4:
inc	sp
inc	sp
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 111 }
! 112 
! 113 int bios_getchar()
! Register BX used in function bios_puts
! 114 # 113 "NUT.c"
! 113 {
export	_bios_getchar
_bios_getchar:
! 114 #asm
!BCC_ASM
    xor ax, ax
    int #$16
    xor ah, ah
! 118 endasm
!BCC_ENDASM
! 119 }
ret
! 120 
! 121 void bios_gets(str,limit)
! 122 # 121 "NUT.c"
! 121 char *str;
export	_bios_gets
_bios_gets:
!BCC_EOS
! 122 # 121 "NUT.c"
! 121 int limit;
!BCC_EOS
! 122 # 121 "NUT.c"
! 121 {
! 122     int i = 0;
push	bp
mov	bp,sp
push	di
push	si
dec	sp
dec	sp
! Debug: eq int = const 0 to int i = [S+8-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
! 123     int c;
!BCC_EOS
! 124 
! 125     for (;;) {
dec	sp
dec	sp
!BCC_EOS
!BCC_EOS
.B:
! 126         c = bios_getchar();
! Debug: func () int = bios_getchar+0 (used reg = )
call	_bios_getchar
! Debug: eq int = ax+0 to int c = [S+$A-$A] (used reg = )
mov	-8[bp],ax
!BCC_EOS
! 127         switch (c) {
mov	ax,-8[bp]
br 	.E
! 128             case 0x08:
! 129                 if (i) {
.F:
mov	ax,-6[bp]
test	ax,ax
je  	.10
.11:
! 130                     i--;
! Debug: postdec int i = [S+$A-8] (used reg = )
mov	ax,-6[bp]
dec	ax
mov	-6[bp],ax
!BCC_EOS
! 131                     bios_putchar(0x08,5);
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 132                     bios_putchar(' ',5);
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int = const $20 (used reg = )
mov	ax,*$20
push	ax
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 133                     bios_putchar(0x08,5);
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int = const 8 (used reg = )
mov	ax,*8
push	ax
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 134                 }
! 135                 continue;
.10:
add	sp,#-$A-..FFFF
jmp .A
!BCC_EOS
! 136             case 0x0d:
! 137                 bios_putchar(0x0d,5);
.12:
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int = const $D (used reg = )
mov	ax,*$D
push	ax
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 138                 bios_putchar(0x0a,5);
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int = const $A (used reg = )
mov	ax,*$A
push	ax
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 139                 str[i] = 0;
! Debug: ptradd int i = [S+$A-8] to * char str = [S+$A+2] (used reg = )
mov	ax,-6[bp]
add	ax,4[bp]
mov	bx,ax
! Debug: eq int = const 0 to char = [bx+0] (used reg = )
xor	al,al
mov	[bx],al
!BCC_EOS
! 140                 break;
jmp .C
!BCC_EOS
! 141             default:
! 142                 if (i == limit - 1)
.13:
! Debug: sub int = const 1 to int limit = [S+$A+4] (used reg = )
mov	ax,6[bp]
! Debug: logeq int = ax-1 to int i = [S+$A-8] (used reg = )
! Debug: expression subtree swapping
dec	ax
cmp	ax,-6[bp]
jne 	.14
.15:
! 143                     continue;
add	sp,#-$A-..FFFF
jmp .A
!BCC_EOS
! 144                 bios_putchar(c,5);
.14:
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list int c = [S+$C-$A] (used reg = )
push	-8[bp]
! Debug: func () void = bios_putchar+0 (used reg = )
call	_bios_putchar
add	sp,*4
!BCC_EOS
! 145                 str[i++] = (char)c;
! Debug: postinc int i = [S+$A-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
! Debug: ptradd int = ax-1 to * char str = [S+$A+2] (used reg = )
dec	ax
add	ax,4[bp]
mov	bx,ax
! Debug: eq char c = [S+$A-$A] to char = [bx+0] (used reg = )
mov	al,-8[bp]
mov	[bx],al
!BCC_EOS
! 146                 continue;
add	sp,#-$A-..FFFF
jmp .A
!BCC_EOS
! 147         }
! 148         break;
jmp .C
.E:
sub	ax,*8
beq 	.F
sub	ax,*5
je 	.12
jmp	.13
.C:
..FFFF	=	-$A
jmp .9
!BCC_EOS
! 149     }
! 150 
! 151     return;
.A:
br 	.B
.9:
add	sp,*4
pop	si
pop	di
pop	bp
ret
!BCC_EOS
! 152 }
! 153 
! 154 void draw_italian_flag()
! Register BX used in function bios_gets
! 155 # 154 "NUT.c"
! 154 {
export	_draw_italian_flag
_draw_italian_flag:
! 155 	int i;
!BCC_EOS
! 156 	int j;
!BCC_EOS
! 157 	set_backgro
! 157 und(5);
push	bp
mov	bp,sp
push	di
push	si
add	sp,*-4
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: func () void = set_background+0 (used reg = )
call	_set_background
inc	sp
inc	sp
!BCC_EOS
! 158 	for(i = 0; i < 640; i++) {
! Debug: eq int = const 0 to int i = [S+$A-8] (used reg = )
xor	ax,ax
mov	-6[bp],ax
!BCC_EOS
!BCC_EOS
jmp .18
.19:
! 159 		for(j = 0; j < 480; j++) {
! Debug: eq int = const 0 to int j = [S+$A-$A] (used reg = )
xor	ax,ax
mov	-8[bp],ax
!BCC_EOS
!BCC_EOS
jmp .1C
.1D:
! 160 		}
! 161 	}
.1B:
! Debug: postinc int j = [S+$A-$A] (used reg = )
mov	ax,-8[bp]
inc	ax
mov	-8[bp],ax
.1C:
! Debug: lt int = const $1E0 to int j = [S+$A-$A] (used reg = )
mov	ax,-8[bp]
cmp	ax,#$1E0
jl 	.1D
.1E:
.1A:
! 162 }
.17:
! Debug: postinc int i = [S+$A-8] (used reg = )
mov	ax,-6[bp]
inc	ax
mov	-6[bp],ax
.18:
! Debug: lt int = const $280 to int i = [S+$A-8] (used reg = )
mov	ax,-6[bp]
cmp	ax,#$280
jl 	.19
.1F:
.16:
add	sp,*4
pop	si
pop	di
pop	bp
ret
! 163 
! 164 extern void print_char();
!BCC_EOS
! 165 
! 166 void kmain()
! 167 # 166 "NUT.c"
! 166 {
export	_kmain
_kmain:
! 167     char prompt[256];
!BCC_EOS
! 168 	clear_screen();
push	bp
mov	bp,sp
push	di
push	si
add	sp,#-$100
! Debug: func () void = clear_screen+0 (used reg = )
call	_clear_screen
!BCC_EOS
! 169     bios_set_cursor(0,0);
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: list int = const 0 (used reg = )
xor	ax,ax
push	ax
! Debug: func () void = bios_set_cursor+0 (used reg = )
call	_bios_set_cursor
add	sp,*4
!BCC_EOS
! 170 
! 171 
! 172 	print_char();
! Debug: func () void = print_char+0 (used reg = )
call	_print_char
!BCC_EOS
! 173 
! 174     for (;;) {
!BCC_EOS
!BCC_EOS
.22:
! 175 		bios_puts("\r\nGRANDE NOCE> ",0x35);
! Debug: list int = const $35 (used reg = )
mov	ax,*$35
push	ax
! Debug: list * char = .23+0 (used reg = )
mov	bx,#.23
push	bx
! Debug: func () void = bios_puts+0 (used reg = )
call	_bios_puts
add	sp,*4
!BCC_EOS
! 176         bios_gets(prompt,256);
! Debug: list int = const $100 (used reg = )
mov	ax,#$100
push	ax
! Debug: list * char prompt = S+$108-$106 (used reg = )
lea	bx,-$104[bp]
push	bx
! Debug: func () void = bios_gets+0 (used reg = )
call	_bios_gets
add	sp,*4
!BCC_EOS
! 177         bios_puts(prompt,5);
! Debug: list int = const 5 (used reg = )
mov	ax,*5
push	ax
! Debug: list * char prompt = S+$108-$106 (used reg = )
lea	bx,-$104[bp]
push	bx
! Debug: func () void = bios_puts+0 (used reg = )
call	_bios_puts
add	sp,*4
!BCC_EOS
! 178     }
! 179 }
.21:
jmp	.22
.20:
lea	sp,-4[bp]
pop	si
pop	di
pop	bp
ret
! 180 
! Register BX used in function kmain
.data
.23:
.24:
.byte	$D,$A
.ascii	"GRANDE NOCE> "
.byte	0
.bss
.comm	_y,2
.comm	_x,2

! 0 errors detected
