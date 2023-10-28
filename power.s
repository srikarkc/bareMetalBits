.section .data

.section .text

.globl _start

_start:

pushl $3	# pushing the second argument to the stack - i.e. the power
pushl $2	# pushing the first argument - i.e the base number
call power
addl $8, %esp
movl $1, %eax
int $0x80

.type power, @function
power:
pushl %ebp
movl %esp, %ebp
subl $4, %esp	# Making room for the local storage

movl 8(%ebp), %ebx	# Base number
movl 12(%ebp), %ecx	# Power

movl %ebx, -4(%ebp)

power_loop_start:
cmpl $1, %ecx
je end_power
movl -4(%ebp), %eax
imul %ebx, %eax
movl %eax, -4(%ebp)
decl %ecx
jmp power_loop_start

end_power:
movl -4(%ebp), %eax
movl %ebp, %esp
popl %ebp
ret
