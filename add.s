.section .data

# Define two numbers to be added
number1: .quad 5  # First number (change value as needed)
number2: .quad 3  # Second number (change value as needed)

.section .text

.globl _start
_start:

    # Load the numbers into registers
    movq number1(%rip), %rdi  # Load first number into %rdi
    movq number2(%rip), %rsi  # Load second number into %rsi

    # Add the numbers
    addq %rsi, %rdi           # Result is now in %rdi

    # For the sake of demonstration, let's exit the program using the sum as the exit code
    movq %rdi, %rdi           # Put the sum in %rdi, which is the argument to the exit syscall
    movq $60, %rax            # 60 is the syscall number for exit in x86-64
    syscall                   # Make the syscall to exit


