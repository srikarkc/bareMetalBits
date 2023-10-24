# This program finds the maximum number from a set of numbers

# %edi -> Holds the index of number being examined, %eax -> Current data item, %ebx -> Largest item found

.section .data

data_items:
.long 3,97,21,42,89,222,43,32,1,53,5,29,39,66,0

.section .text

.globl _start

_start:
movl $0, %edi	                # move 0 to the index register
movl data_items(,%edi,4), %eax	# load the first byte of the data
movl %eax, %ebx	                # since this is the first item, %eax is the biggest

start_loop:
cmpl $0, %eax                   # Compares 0 to the number stored in the %eax register
je loop_exit                    # Jump if the second value is equal to the first i.e. both values are equal
incl %edi
movl data_items(,%edi,4), %eax
cmpl %ebx, %eax
jle start_loop                  # Jump if the second value is larger or equal to the first value
movl %eax, %ebx
jmp start_loop

loop_exit:
movl $1, %eax
int $0x80
