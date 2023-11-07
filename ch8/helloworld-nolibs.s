# Purpose - This program prints "hello world" and exits

.section .data
helloworld:
  .ascii "hello world\n"
helloworld_end:

.equ helloworld_len, helloworld_end - helloworld

.equ STDOUT, 1
.equ EXIT, 1
.equ WRITE, 4
.equ LINUX_SYSCALL, 0x80

.section .text
.globl _start
_start:
movl $STDOUT, %ebx
movl $helloworld, %ecx
movl $helloworld_len, %edx
movl $4, %eax
int $LINUX_SYSCALL

movl $0, %ebx
movl $EXIT, %eax
int $LINUX_SYSCALL
