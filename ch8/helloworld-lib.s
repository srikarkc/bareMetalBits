# Hello World with library

.section .data

helloworld:
  .ascii "Hello, World!\n\0"

.section .text:
.globl _start
_start:
pushl $helloworld
call printf

pushl $0
call exit
