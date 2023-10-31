# This program converts input file to output file with all letters converted to uppercase

.section .data

# CONSTANTS

.equ OPEN, 5
.equ WRITE, 4
.equ READ, 3
.equ CLOSE, 6
.equ EXIT, 1

# Options for open
.equ O_READONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101 # CREAT - Create file if it doesn't exist, WRONLY - Write only, TRUNC - destroy current file contents, if exist

.equ LINUX_SYSCALL, 0x80
.equ END_OF_FILE, 0


# BUFFERS 

.section .bss
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE


# PROGRAM

.section .text

.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, 0
.equ ST_FD_OUT, 4
.equ ST_ARGC, 8		# Number of arguments
.equ ST_ARGV_0, 12	# Name of the program
.equ ST_ARGV_1, 16	# Input file name
.equ ST_ARGV_2, 20	# Output file name

.globl _start
_start:
subl $ST_SIZE_RESERVE, %esp
movl %esp, %ebp

open_files:
open_fd_in:
movl ST_ARGV_1(%ebp), %ebx	# input filename into %ebx
movl $O_READONLY, %ecx		# read-only flag
movl $0666, %edx		# permissions
movl $OPEN, %eax
int $LINUX_SYSCALL

store_fd_in:
movl %eax, ST_FD_IN(%ebp)	# save the given file descriptor

open_fd_out:
movl ST_ARGV_2(%ebp), %ebx	# output filename into %ebx
movl $O_CREAT_WRONLY_TRUNC, %ecx	# flags for writing to the file
movl 0666, %edx
movl $OPEN, %eax
int $LINUX_SYSCALL

store_fd_out:
movl %eax, ST_FD_OUT(%ebp)

read_loop_begin:
movl ST_FD_IN(%ebp), %ebx	# get the input file descriptor
movl $BUFFER_DATA, %ecx		# the location to read into
movl $BUFFER_SIZE, %edx		# the size of the buffer
movl $READ, %eax
int $LINUX_SYSCALL

cmpl $END_OF_FILE, %eax		# check for end of file marker
jle end_loop

continue_read_loop:
pushl $BUFFER_DATA
pushl %eax
call convert_to_upper
popl %eax
popl %ebx

movl ST_FD_OUT(%ebp), %ebx	# file to use
movl $BUFFER_DATA, %ecx
movl %eax, %edx			# size of the buffer
movl $WRITE, %eax
int $LINUX_SYSCALL

jmp read_loop_begin

end_loop:
movl ST_FD_OUT(%ebp), %ebx
movl $CLOSE, %eax
int $LINUX_SYSCALL

movl ST_FD_IN(%ebp), %ebx
movl $CLOSE, %eax
int $LINUX_SYSCALL

movl $0, %ebx
movl $EXIT, %eax
int $LINUX_SYSCALL


# Function to cover_to_upper

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert_to_upper:
pushl %ebp
movl %esp, %ebp

# Set up variables
movl ST_BUFFER(%ebp), %eax
movl ST_BUFFER(%ebp), %ebx
movl $0, %edi

cmpl $0, %ebx
je end_convert_loop

convert_loop:
movb (%eax,%edi,1), %cl

cmpb $LOWERCASE_A, %cl
jl next_byte
cmpb $LOWERCASE_Z, %cl
jg next_byte

# Otherwise convert the byte to uppercase
addb $UPPER_CONVERSION, %cl
# and store it back
movb %cl, (%eax,%edi,1)

next_byte:
incl %edi
cmpl %edi, %ebx
jne convert_loop

end_convert_loop:
movl %ebp, %esp
popl %ebp
ret
