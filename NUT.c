
asm (
    ".section .entry;"
    ".global _start;"
    "_start:"
        // Disable VGA cursor
        "mov $0x01, %ah;"
        "mov $0x2607, %cx;"
        "int $0x10;"
        "call kmain;"
);

#include <stddef.h>
#include <stdint.h>

#define MK_FP(seg, off) \
((void __far *) ((unsigned long) (unsigned) (seg) << 16 | \
                 (unsigned) (off)))

int ticks = 0;

int text[80][25] = {0};
int curx = 0;
int cury = 0;

/*
 * Set the backgroun color so that it draws an italian flag.
 */
char get_color_from_pos(int x) {
	if(x <= 26) {
		return 0x2f;
	} else if(x >= 26 && x <= 54) {
		return 0xf2;
	} else if (x > 54 && x < 80){
		return 0x4f;
	}
	return 0x34;
}

int rand() {
	return ticks;
}

void set_character(char c, char color, int x, int y) {
	volatile int __far * VGA = MK_FP(0xb800, 0);
	int full_char = (color << 8) | c;
	text[x][y] = full_char;
	VGA[x + y * 80] = full_char;
}

void delete_char() {
	set_character(' ', get_color_from_pos(curx - 1), curx - 1, cury);
	if(curx != 1) {
		curx -= 1;
	}
}

void puts(char *str) {
    int i;
	volatile int __far * VGA = MK_FP(0xb800, 0);

    for (i = 0; str[i]; i++) {
		if(str[i] != '\n' && str[i] != '\r') {
			set_character(str[i], get_color_from_pos(curx), curx, cury);
			curx++;
			if(curx > 79) {
				curx = 0;
				cury++;
			}
		} else if (str[i] == '\n'){
			cury++;
		} else if (str[i] == '\r'){
			curx = 0;
		}

		if(cury > 24) {
			for(int i = 0; i < 80; i++) {
				for(int j = 1; j < 25; j++) {
					text[i][j - 1] = text[i][j];
				}
			}
			cury = 24;
			for(int i = 0; i < 80; i++) {
				set_character(' ', get_color_from_pos(i), i, cury);
			}
			for(int i = 0; i < 80; i++) {
				for(int j = 0; j < 25; j++) {
					VGA[i + j * 80] = text[i][j];
				}
			}
		}
    }

    return;
}

int bios_getchar(void) {
    int ret;
    asm volatile (
        "int $0x16;"
        "xor %%ah, %%ah;"
        : "=a"(ret)
        : "a"(0)
    );
    return ret;
}

void bios_gets(char *str, int limit) {
    int i = 0;
	char in[2];
	in[1] = 0;

    for (;;) {
        in[0] = bios_getchar();
        switch (in[0]) {
            case 0x08:
                if (i) {
                    i--;
					delete_char();
                }
                continue;
			case 0x1c:
				continue;
            case 0x0d:
                str[i] = 0;
                break;
            default:
                if (i == limit - 1)
                    continue;
                puts(in);
                str[i++] = (char)in[0];
                continue;
        }
        break;
    }

    return;
}

int sub_m_size = 12;
char* subject_m[] = {"DIO", "LO SPIRITO SANTO", "GESU", "PADRE PIO", "SAN TOMMASO", "SAN GIUSEPPE", "OGNI SANTO", "IL PAPA",
        "SANTO STEFANO", "SAN BENEDETTO DA NORCIA", "SAN GENNARO", "IL PADRE ETERNO"};

int ins_m_size =13;
char* insult_m[] = {"PORCO", "MAIALE", "BASTARDO", "PEZZO DI MERDA", "", "DEPORTATO", "SCHIFOSO", "DEFICIENTE",
        "IDIOTA", "IMPESTATO", "COGLIONE", "TESTICOLO","BESTEMMIARE"};

int att_m_size = 53;
char* attribute_m[] = {"SALDATORE", "ARITMETICO", "ARBITRO", "PIROTECNICO", "PORCONE", "SBRATTO", "STATICO", "ALBERO",
        "STABILE", "SUBLIME", "PREPUZIO", "TRABEAZIONE", "TRANQUILLONE", "PELATO", "SEGMENTATO", "ALTALENA",
        "ROBUSTO", "CONDENSATORE", "AMPLIFICATORE", "NIENTE", "SASSOFONO", "TRE", "FORNACE", "PORTAFOGLIO",
        "PEZZO", "PALLE", "FUCILE", "CANE", "LETTO", "SALVADANAIO", "FUNGHETTO", "CUBICO",
        "VENTILATORE", "MANUBRIO", "ERRORE", "PROFESSIONALE", "PISTA", "FRUSTA", "DA CORSA", "BESTEMMIARE",
        "MULTIFUNZIONE", "MECCANICO", "SU UNA MOTO", "LERCIO", "RADIATORE", "FRACICO", "IN VENDITA ALL'ASTA", "CONFETTO",
        "RICONDIZIONATO", "TRASGRESSIVO", "SFERICO", "CHIOSCO", "40ENNE", "TAVOLINO", "RAGGIO LASER", "ANCESTRALE",
        "PRIMORDIALE", "FINALE", "ANALE", "BUSTINA", "PIEDE"};

int sub_f_size = 7;
char* subject_f[] = {"MADONNA", "MARIA MADDALENA", "LA SANTISSIMA", "L'IMMACOLATA", "SANTA BARBARA", "LA VERGINE", "LA PENTECOSTE"};

int ins_f_size = 15;
char* insult_f[] = {"TROIA", "MAIALA", "PUTTANONA", "BASTARDA", "ZOCCOLA", "PUTTANA", "MALEDETTA", "SCHIFOSA",
        "MALATA", "MERETRICE", "BALDRACCONA", "BALDRACCA", "", "IMPESTATA","BESTEMMIARE"};

int att_f_size = 30;
char* attribute_f[] = {"STIPATA", "SUBLIME", "CATGIRL", "CLEOPATRA", "ABBACINANTE", "CAPRA", "DIAPOSITIVA", "INDOSSATRICE",
        "AMMACCATURA", "PASTA", "MAFIA", "TRAP", "PORTA", "BARCA A VELA", "PROFESSIONALE", "PISTA",
        "FRUSTA", "DA CORSA", "METROPOLITANA", "BARELLA", "VIDEOLUDICA", "DA BATTAGLIA", "ARIA CONDIZIONATA",
        "RAFFREDDATA", "MITRAGLIATRICE", "BUSTINA", "PESCA NOCE", "PALLA", "ESPERTA", "NOCE"};

int pre_size = 7;
char* prefix[] = {"QUASI-", "SUPER-", "PSEUDO-", "ULTRA-", "MEGA-", "MINI-", "MICRO-"};

void bestemmiare(){
    if(rand() % 2){
        if(rand() % 2){
            puts(subject_m[rand() % sub_m_size]);
            puts(" ");
            puts(insult_m[rand() % ins_m_size]);
            puts(" ");
            int i=0;
			if(!(rand() % 11)){
				puts(prefix[rand() % pre_size]);
			}
			puts(attribute_m[rand() % att_m_size]);
			puts(" ");
        }else{
            puts(insult_m[rand() % ins_m_size]);
            puts(" ");
            puts(subject_m[rand() % sub_m_size]);
            puts(" ");
            int i=0;
			if(!(rand() % 11)){
				puts(prefix[rand() % pre_size]);
			}
			puts(attribute_m[rand() % att_m_size]);
			puts(" ");
        }
    }else{
        if(rand() % 2){
            puts(subject_f[rand() % sub_f_size]);
            puts(" ");
            puts(insult_f[rand() % ins_f_size]);
            puts(" ");
            int i=0;
			if(!(rand() % 11)){
				puts(prefix[rand() % pre_size]);
			}
			puts(attribute_f[rand() % att_f_size]);
			puts(" ");
        }else{
            puts(insult_f[rand() % ins_f_size]);
            puts(" ");
            puts(subject_f[rand() % sub_f_size]);
            puts(" ");
            int i=0;
			if(!(rand() % 11)){
				puts(prefix[rand() % pre_size]);
			}
			puts(attribute_f[rand() % att_f_size]);
			puts(" ");
        }
    }
}

asm (
    ".section .text;"
    "timer_isr:"
        "push %ax;"
        "push %ds;"
        "xor %ax, %ax;"
        "mov %ax, %ds;"
        "incw (ticks);"
        "pop %ds;"
        "pop %ax;"
        "iretw;"
);

void timer_isr(void);

struct ivt_entry {
    uint16_t offset;
    uint16_t segment;
};

void kmain(void) {
    // Hook int 0x1c
    struct ivt_entry *ivt = (void *)0;
    ivt[0x1c].segment = 0;
    ivt[0x1c].offset  = (uint16_t)timer_isr;

    char prompt[256];
	for(int i = 0; i < 80; i++) {
		for(int j = 0; j < 25; j++) {
			set_character(' ', get_color_from_pos(i), i, j);
		}
	}
	char* str = "Benenuto a BestOS";
	puts(str);
    for (;;) {
        puts("\r\nGRANDE NOCE> ");
        bios_gets(prompt, 256);
        puts("\r\n");
		bestemmiare();
    }
}

