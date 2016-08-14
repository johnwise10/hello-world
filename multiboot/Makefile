
LDFLAGS = -cref -s -x -M 
LD=-i686-elf-ld 

Kernel.bin: boot.o kernel.o
	#i686-elf-gcc -T link.ld -o kernel.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
	$(LD) -T link.ld -o kernel.bin boot.o kernel.o $(LDFLAGS) > System.map	
boot.o: boot.s
	i686-elf-as boot.s -o boot.o
kernel.o: kernel.c
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
clean:
	rm *.o
	rm *.bin
