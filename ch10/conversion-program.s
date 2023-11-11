# Convert an integer number to a decimal number for display

# %ecx will hold the count of the characters processed
# %eax will hold the current value
# %edi will hold the base (10)

.equ ST_VALUE, 8
.equ ST_BUFFER, 12

.globl integer2string
.type integer2string, @function

integer2string:

pushl %ebp
movl %esp, %ebp

# Current character count
movl $0, %ecx

# Move the value into position
movl ST_VALUE(%ebp), %eax

# When we divide by 10, the 10 must be in a register or memory location
movl $10, %edi

conversion_loop:
# clearing the %edx register since the division is performed on the combined %edx:%eax register
xorl %edi, %edx

divl %edi

addl $'0', %edx
pushl %edx

incl %ecx

cmpl $0, %eax
je end_conversion_loop

jmp conversion_loop

end_conversion_loop:
movl ST_BUFFER(%ebp), %edx

copy_reversing_loop:
popl %eax
movb %al, (%edx)

decl %ecx

incl %edx

cmpl $0, %ecx

je end_copy_reversing_loop
jmp copy_reversing_loop

end_copy_reversing_loop:
movb $0, (%edx)
movl %ebp, %esp
popl %ebp
ret


.include "linux.s"

.section .data

tmp_buffer:
.ascii "\0\0\0\0\0\0\0\0\0\0\0"

.section .text

.globl _start

_start:
movl %esp, %ebp
pushl $tmp_buffer

pushl $824
call integer2string
addl $8, %esp

movl $4, %eax
movl $1, %ebx
movl $tmp_buffer, %ecx

int $0x80

movl $1, %eax
movl $0, %ebx
int $0x80
