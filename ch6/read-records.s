# Count the character until null byte is reached
# Returns the count in %eax
# %ecx - character count
# %al - current character
# %edx - current character address

.type count_chars, @function
.globl count_chars

.equ DATA_START_ADDRESS, 8

count_chars:
pushl %ebp
movl %esp, %ebp

movl $0, %ecx

movl DATA_START_ADDRESS(%ebp), %edx

count_loop_begin:
movb (%edx), %al
cmpb $0, %al
je count_loop_end
incl %ecx
incl %edx
jmp count_loop_begin

count_loop_end:
movl %ecx, %eax
movl %ebp, %esp
popl %ebp
ret

.include "linux.s"
.include "record-def.s"
.include "read-record.s"
.include "write-record.s"

.section .data
file_name:
.ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text
.globl _start
_start:
.equ INPUT_DESCRIPTOR, -4
.equ OUTPUT_DESCRIPTOR, -8

movl %esp, %ebp
subl $8, %ebp

movl $SYS_OPEN, %eax
movl $file_name, %ebx
movl $0, %ecx		# This is open read-only
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, INPUT_DESCRIPTOR(%ebp)

movl $STDOUT, OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
pushl INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call read_record
addl $8, %ebp

cmpl $RECORD_SIZE, %eax
jne finished_reading

pushl $RECORD_FIRSTNAME + record_buffer
call count_chars
addl $4, %esp

movl %eax, %edx
movl OUTPUT_DESCRIPTOR(%ebp), %ebx
movl $SYS_WRITE, %eax
movl $RECORD_FIRSTNAME + record_buffer, %ecx
int $LINUX_SYSCALL

pushl OUTPUT_DESCRIPTOR(%ebp)
call write_newline
addl $4, %esp

jmp record_read_loop

finished_reading:
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
