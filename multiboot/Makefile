
AS=as
INCLUDEASM=-I ./include/asm
INCLUDE=-I ./include
CFLAGS = -Wall -nostdlib -nostartfiles -nodefaultlibs
LD=ld
CC=gcc
CPP=$(CC) -E

all:	kernel.bin
	objcopy -O elf32-i386 kernel.bin kernel32.bin
	objcopy kernel32.bin --change-section-lma .text-0xC0000000
	objcopy kernel32.bin --change-section-lma .rdata-0xC0000000
	objcopy kernel32.bin --change-section-lma .bss-0xC0000000
	
kernel.bin: boot.o kernel.o
	$(LD) -T link.ld -o kernel.bin boot.o kernel.o   -cref -s -x -M > System.map

kernel.o: kernel.c 
	$(CC) -o kernel.o -c kernel.c $(CFLAGS) $(INCLUDEASM)
	
boot.o: boot.asm 
	$(AS) -o boot.o boot.asm
boot.asm: boot.S
	$(CPP) -D__KERNEL__ $(INCLUDEASM) boot.S -o boot.asm 
clean:
	del *.o
	del *.asm
	del *.bin
	

	
