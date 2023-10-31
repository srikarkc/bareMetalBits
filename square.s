# Assembly program written by Srikar K. to square a number
.section .data

.section .text

.globl _start
_start:
pushl $3			# Pushes a number to be square onto the stack
call square
popl %ebx			# Removes the number that was pushed onto the stack
movl %eax, %ebx			# (%eax) register contains the return value of the function

movl $1, %eax
int $0x80

.type square, @function
square:
#Prologue
pushl %ebp
movl %esp, %ebp

# Core of the squaring function
movl 8(%ebp), %eax		# Storing the value on the stack into %eax register
imul %eax, %eax

# Epilogue
movl %ebp, %esp
popl %ebp
ret
