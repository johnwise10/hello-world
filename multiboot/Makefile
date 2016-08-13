
AS=as --32
INCLUDEASM=-I ./include/asm
INCLUDE=-I ./include
CFLAGS = -Wall -nostdlib -nostartfiles -nodefaultlibs
LD=ld -melf_i386
CC=gcc -m32
CPP=$(CC) -E

all:	kernel.bin
	objcopy -O elf32-i386 kernel.bin kernel32.bin
	
kernel.bin: boot.o kernel.o
	$(LD) -T link.ld -o kernel.bin boot.o kernel.o   -cref -s -x -M > System.map

kernel.o: kernel.c 
	$(CC) -o kernel.o -c kernel.c $(CFLAGS) $(INCLUDEASM)
	
boot.o: boot.asm 
	$(AS) -o boot.o boot.asm
boot.asm: boot.S
	$(CPP) -D__KERNEL__ $(INCLUDEASM) boot.S -o boot.asm 
clean:
	rm *.o
	rm *.asm
	rm *.bin
	

	
