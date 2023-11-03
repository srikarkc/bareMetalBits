.include "linux.s"
.include "record-def.s"
.include "read-record.s"
.include "write-record.s"

.section .data
input_file_name:
.ascii "test.dat\0"

output_file_name:
.ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.equ INPUT_DESCRIPTOR, -4
.equ OUTPUT_DESCRIPTOR, -8

.section .text
.globl _start

_start:
movl %esp, %ebp
subl $8, %ebp

# Fist, open the file for reading
movl $SYS_OPEN, %eax
movl $input_file_name, %ebx
movl $0, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, INPUT_DESCRIPTOR(%ebp)

# Open file for writing
movl $SYS_OPEN, %eax
movl $output_file_name, %ebx
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL

movl %eax, OUTPUT_DESCRIPTOR(%ebp)


loop_begin:
pushl INPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call read_record
addl $8, %ebp

# The above returns the number of bytes read
cmpl $RECORD_SIZE, %eax
jne loop_end

incl record_buffer + RECORD_AGE		# incl - increment by 1 and record_buffer+RECORD_AGE tells you where to increment

pushl OUTPUT_DESCRIPTOR(%ebp)
pushl $record_buffer
call write_record
addl $8, %esp

jmp loop_begin

loop_end:
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
