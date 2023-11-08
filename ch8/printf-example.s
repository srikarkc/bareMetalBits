.section .data

firststring:
  .ascii "Hello! %s is a %s who love the number %d\n\0"

name:
  .ascii "Srikar\0"

personstring:
  .ascii "person\0"

numberloved:
  .long 3

.equ EXIT, 1
.equ LINUX_SYSCALL, 0x80

.section .text
.globl _start
_start:
pushl numberloved
pushl $personstring
pushl $name
pushl $firststring
call printf

movl $0, %ebx
movl $EXIT, %eax
int $LINUX_SYSCALL
