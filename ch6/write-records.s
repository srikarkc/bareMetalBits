.include "linux.s"
.include "record-def.s"
.include "write-record.s"
.include "read-record.s"

.section .data

record1:
.ascii "Fredrick\0"
.rept 31 # Padding to 40 bytes
.byte 0
.endr

.ascii "Bartlett\0"
.rept 31 # Padding to 40 bytes
.byte 0
.endr

.ascii "4242 S Prairie\nTulsa, OK 55555\0"
.rept 209 # Padding to 240 bytes
.byte 0
.endr

.long 45

record2:
.ascii "Marilyn\0"
.rept 32 # Padding
.byte 0
.endr

.ascii "Taylor\0"
.rept 33
.byte 0
.endr

.ascii "2224 S Johannan St\nChicago, IL 12345\0"
.rept 203
.byte 0
.endr

.long 29

record3:
.ascii "Derrick\0"
.rept 32
.byte 0
.endr

.ascii "McIntire\0"
.rept 31
.byte 0
.endr

.ascii "500 W Oakland\nSan Diego, CA 54321\0"
.rept 206
.byte 0
.endr

.long 36

file_name:
.ascii "test.dat\0"

.equ FILE_DESCRIPTOR, -4	# Location on the stack to hold the file descriptor output from Linux on the stack

.globl _start
_start:
movl %esp, %ebp
subl $4, %esp		# Allocate space to hold the file descriptor

# Open the file
movl $SYS_OPEN, %eax
movl $file_name, %ebx
movl $0101, %ecx
movl $0666, %edx
int $LINUX_SYSCALL


# Store the file descriptor
movl %eax, FILE_DESCRIPTOR(%ebp)


# Write the first record
pushl FILE_DESCRIPTOR(%ebp)
pushl $record1
call write_record
addl $8, %esp		# Get rid of the stack values

# Write the second record
pushl FILE_DESCRIPTOR(%ebp)
pushl $record2
call write_record
addl $8, %esp

# Write the third record
pushl FILE_DESCRIPTOR(%ebp)
pushl $record3
call write_record
addl $8, %esp

# Close the file descriptor
movl $SYS_CLOSE, %eax
movl FILE_DESCRIPTOR(%ebp), %ebx
int $LINUX_SYSCALL

# Exit the program
movl $SYS_EXIT, %eax
movl $0, %ebx
int $LINUX_SYSCALL
