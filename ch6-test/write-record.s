.include "record-def.s"
.include "linux.s"

# Writing function
.equ ST_FILEDES, 12
.equ ST_WRITE_BUFFER, 8

.globl write_record
.type write_record, @function
write_record:
pushl %ebp
movl %esp, %ebp

# preserve %ebx data
pushl %ebx

movl $SYS_WRITE, %eax
movl ST_FILEDES(%ebp), %ebx
movl ST_WRITE_BUFFER(%ebp), %ecx
movl $RECORD_SIZE, %edx
int $LINUX_SYSCALL

# restore %ebx data
popl %ebx

movl %ebp, %esp
popl %ebp
ret
