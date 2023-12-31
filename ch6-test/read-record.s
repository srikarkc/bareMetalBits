.include "record-def.s"
.include "linux.s"

# Reading function
.equ ST_READ_BUFFER, 8
.equ ST_FILEDES, 12

.globl read_record
.type read_record, @function
read_record:
pushl %ebp
movl %esp %ebp

# preserve %ebx data
pushl %ebx

movl ST_FILEDES(%ebp), %ebx
movl ST_READ_BUFFER(%ebp), %ecx
movl $RECORD_SIZE, %edx
movl $SYS_READ, %eax
int $LINUX_SYSCALL

# restore %ebx data
popl %ebx

movl %ebp %esp
popl %ebp
ret