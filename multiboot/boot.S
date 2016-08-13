/* boot.S - bootstrap the kernel */
/* Copyright (C) 1999, 2001  Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
 
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
 
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

#define ASM	1
#include <multiboot.h>
	
	.section .setup
	.globl	start, _start
start:
_start:
	jmp	multiboot_entry

	/* Align 32 bits boundary.  */
	.align	4
	
	/* Multiboot header.  */
multiboot_header:
	/* magic */
	.long	MULTIBOOT_HEADER_MAGIC
	/* flags */
	.long	MULTIBOOT_HEADER_FLAGS
	/* checksum */
	.long	-(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
#ifndef __ELF__
	/* header_addr */
	.long	multiboot_header
	/* load_addr */
	.long	_start
	/* load_end_addr */
	.long	_edata
	/* bss_end_addr */
	.long	_end
	/* entry_addr */
	.long	multiboot_entry
#endif /* ! __ELF__ */

multiboot_entry:
	/* Initialize the stack pointer.  */
	movl	$(stack + STACK_SIZE), %esp

	/* Reset EFLAGS.  */
	pushl	$0
	popf

	/* Push the pointer to the Multiboot information structure.  */
	//pushl	%ebx
	/* Push the magic value.  */
	//pushl	%eax	

	movl %ebx,mbi
	movl %eax,mva

	lgdt gdt_desc
	movw $0x10,%ax
   	movw %ax,%ds
        movw %ax,%es
   	movw %ax,%fs
   	movw %ax,%ss
	ljmp   $0x8,$here
.text
here:	
	movl	$(stack + STACK_SIZE), %esp
	/* Now enter the C main function...  */
	movl (mbi-0x40000000),%ebx	
	pushl %ebx
	movl (mva-0x40000000),%eax
	pushl %eax

	call	EXT_C(cmain)

	/* Halt.  */
	pushl	$halt_message
	call	EXT_C(printf)
	
loop:	hlt
	jmp	loop



halt_message:
	.asciz	"Halted."
.bss
	/* Our stack area.  */
	.comm	stack, STACK_SIZE


.section .setup

mbi: .long  0x00000000
mva: .long  0x00000000

	.p2align	2	/* force 4-byte alignment */
gdt:
	.word	0, 0
	.byte	0, 0, 0, 0

	/* code segment */
	.word	0xFFFF, 0
	.byte	0, 0x9A, 0xCF, 0x40

	/* data segment */
	.word	0xFFFF, 0
	.byte	0, 0x92, 0xCF, 0x40
	
	.word	0, 0
	.byte	0, 0, 0, 0


/* this is the GDT descriptor */
gdt_desc:
	.word	0x1F			/* limit */
	.long	gdt 		/* addr */	
