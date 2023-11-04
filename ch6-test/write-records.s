.include "linux.s"
.include "record-def.s"
.include "write-record.s"

.section .data

# Constant data section that we want to write

record1:
.ascii "Toyota \0"
.rept 32
.byte 0
.endr

.ascii "Supra \0"
.rept 33
.byte 0
.endr

.ascii "Nitro Yellow \0"
.rept 26
.byte 0
.endr

.long 2021

file_name:
.ascii "test.dat\0"

.equ FILE_DESCRIPTOR, -4
.globl _start
_start:
movl %esp, %ebp

# Allocate space to hold the file descriptor
subl $4, %ebp

# Open the file for writing
movl $SYS_OPEN, %eax
movl $file_name, %ebx
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, FILE_DESCRIPTOR(%ebp)

# Write the first file record
pushl FILE_DESCRIPTOR(%ebp)
pushl $record1
call write_record
addl $8, %esp

# Close the file descriptor
movl $SYS_CLOSE, %eax
movl FILE_DESCRIPTOR(%ebp), %ebx
int $LINUX_SYSCALL

movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
