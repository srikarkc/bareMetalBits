# This function writes an output to a file

.section .data
filename: .asciz "heynow.txt"
content: .asciz "hey diddle diddle"
file_mode: .int 03101
file_permissions: .int 0666

.section .bss
file_descriptor: .space 4

.section .text
.globl _start
_start:

# First open the file and get the FD
movl $5, %eax
movl $filename, %ebx
movl $file_mode, %ecx
movl $file_permissions, %edx
int $0x80
movl %eax, file_descriptor

# Exit if there's an error
cmpl $-1, %eax
je _exit

# Write the content to the file
movl $4, %eax
movl file_descriptor, %ebx
movl $content, %ecx
movl $17, %edx
int $0x80

# Close the file
movl $6, %eax
movl file_descriptor, %ebx
int $0x80

# End the program
_exit:
movl $1, %eax
movl $0, %ebx
int $0x80
