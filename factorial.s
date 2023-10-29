.section .data

.section .text

.globl _start
.globl factorial

_start:
pushl $3
call factorial
popl %ebx
movl %eax, %ebx
movl $1, %eax
int $0x80

.type factorial, @function
factorial:
pushl %ebp
movl %esp, %ebp
movl 8(%ebp), %eax		# 4(%ebp) holds the return address and 8(%ebp) holds the first argument set on line 9
cmpl $1, %eax
je end_factorial
decl %eax
pushl %eax			# Push it for our next call to factorial
call factorial
popl %eax
incl %ebx
imul %ebx, %eax

end_factorial:
movl %ebp, %esp
popl %ebp
ret
