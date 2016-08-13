# 1 "boot.S"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "boot.S"
# 19 "boot.S"
# 1 "./include/asm/multiboot.h" 1
# 20 "boot.S" 2

 .section .setup
 .globl start, _start
start:
_start:
 jmp multiboot_entry


 .align 4


multiboot_header:

 .long 0x1BADB002

 .long 0x00000003

 .long -(0x1BADB002 + 0x00000003)
# 51 "boot.S"
multiboot_entry:

 movl $(stack + 0x4000), %esp


 pushl $0
 popf






 movl %ebx,mbi
 movl %eax,mva

 lgdt gdt_desc
 movw $0x10,%ax
    movw %ax,%ds
        movw %ax,%es
    movw %ax,%fs
    movw %ax,%ss
 ljmp $0x8,$here
.text
here:
 movl $(stack + 0x4000), %esp

 movl (mbi-0x40000000),%ebx
 pushl %ebx
 movl (mva-0x40000000),%eax
 pushl %eax

 call _cmain


 pushl $halt_message
 call _printf

loop: hlt
 jmp loop



halt_message:
 .asciz "Halted."
.bss

 .comm stack, 0x4000


.section .setup

mbi: .long 0x00000000
mva: .long 0x00000000

 .p2align 2
gdt:
 .word 0, 0
 .byte 0, 0, 0, 0


 .word 0xFFFF, 0
 .byte 0, 0x9A, 0xCF, 0x40


 .word 0xFFFF, 0
 .byte 0, 0x92, 0xCF, 0x40

 .word 0, 0
 .byte 0, 0, 0, 0



gdt_desc:
 .word 0x1F
 .long gdt
