#include <stdint.h>

static volatile uint16_t *vga = (uint16_t *)0xB8000;
static uint32_t cursor = 0;

static void putc(char c)
{
    if (c == '\n') {
        cursor += 80 - (cursor % 80);
        return;
    }

    if (cursor >= 80 * 25)
        return;

    vga[cursor++] = (uint16_t)(0x0F00 | (uint8_t)c);
}

static void print(const char *s)
{
    while (*s)
        putc(*s++);
}

void orange_init(void)
{
    print("================================\n");
    print("        Orange OS 0.2.0\n");
    print("================================\n");
    print("Platform: xnu++\n");
    print("Architecture: i386\n");
    print("Userspace: Orange\n");
    print("\nOrange OS userspace initialized.\n");

    for (;;) {
        __asm__ volatile ("hlt");
    }
}
