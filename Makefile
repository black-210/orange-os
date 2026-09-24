CC := clang
LD := ld.lld

SRC := userspace/init.c

CFLAGS32 := -m32 -target i386-unknown-none \
-ffreestanding -fno-pic -fno-stack-protector -fno-builtin

CFLAGS64 := -m64 -target x86_64-unknown-none \
-ffreestanding -fno-pic -fno-stack-protector -fno-builtin

.PHONY: all build32 build64 clean

all: build32 build64

build32: build/orange_init.elf

build64: build64/orange_init.elf

build/orange_init.o: $(SRC)
mkdir -p build
$(CC) $(CFLAGS32) -c $(SRC) -o $@

build/orange_init.elf: build/orange_init.o
$(LD) -m elf_i386 --image-base=0x100000 -e orange_init -o $@ $<

build64/orange_init.o: $(SRC)
mkdir -p build64
$(CC) $(CFLAGS64) -c $(SRC) -o $@

build64/orange_init.elf: build64/orange_init.o
$(LD) -m elf_x86_64 --image-base=0x200000 -e orange_init -o $@ $<

clean:
rm -rf build build64
