OUTPUT_FORMAT(binary)
ENTRY(_start)

SECTIONS
{
    . = 0x7e00;

    .text : {
        *(.entry)
        *(.text*)
    }

    .data : {
        *(.data*)
        *(.rodata*)
        *(COMMON)
        *(.bss*)
    }
}
