# First assembly program - Will output an exit code
# %eax holds the system call number & %ebx holds the return status

.section .data

.section .text

.global _start
_start:
movl $1, %eax

movl $69, %ebx

int $0x80
