.data
buffer_a:   .space 4
buffer_b:	.space 4
a_msg:       .asciiz "a = "
b_msg:       .asciiz "b = "
GCD_msg:     .asciiz "GCD = "
comma:       .asciiz ", "
LCM_msg:     .asciiz "LCM = "
error_msg:   .asciiz "Invalid input!\n"
.text
main:
    # Read input a
    j read_a

read_a:
    li $v0, 4
    la $a0, a_msg
    syscall

    li $v0, 8      
    la $a0, buffer_a
    li $a1, 12
    syscall

    la $a0, buffer_a
    jal is_int
    beqz $v0, error_a  # If not an integer, retry

    la $a0, buffer_a
    jal str_to_int
    move $t8, $v0  # Store a in $t3

    # Read input b
    j read_b

error_a:
    li $v0, 4
    la $a0, error_msg
    syscall
    j read_a

read_b:
    li $v0, 4
    la $a0, b_msg
    syscall

    li $v0, 8      
    la $a0, buffer_b
    li $a1, 12
    syscall

    la $a0, buffer_b
    jal is_int
    beqz $v0, error_b  # If not an integer, retry

    la $a0, buffer_b
    jal str_to_int
    move $t9, $v0  # Store b in $t4
	
	li $v0, 11
	
	j calculate_GCD_LCM

error_b:
    li $v0, 4
    la $a0, error_msg
    syscall
    j read_b
    

calculate_GCD_LCM:
    move $a0, $t8
    move $a1, $t9
    jal find_GCD
    move $s0, $v0  # Store GCD in $s0

    # Calculate LCM: (a * b) / GCD
    mul $t0, $t8, $t9
    div $t0, $s0
    mflo $s3  # Store LCM in $s3

    # Print GCD
    li $v0, 4
    la $a0, GCD_msg
    syscall    

    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, comma
    syscall    
    
    # Print LCM
    li $v0, 4
    la $a0, LCM_msg
    syscall    
    
    li $v0, 1
    move $a0, $s3
    syscall
    
    j exit

# Function: is_int
# Checks if a given string represents a valid integer
is_int:
    li $v0, 1
    lb $t0, 0($a0)
    beq $t0, 45, check_digits  # Allow negative sign '-'
    blt $t0, 48, invalid_input
    bgt $t0, 57, invalid_input

check_digits:
    addi $a0, $a0, 1

digit_loop:
    lb $t0, 0($a0)
    beq $t0, 10, valid_input  # Newline means end of input
    blt $t0, 48, invalid_input
    bgt $t0, 57, invalid_input
    addi $a0, $a0, 1
    j digit_loop

valid_input:
    jr $ra

invalid_input:
    li $v0, 0
    jr $ra

# Function: str_to_int
# Converts a valid integer string to an integer value
str_to_int:
    li $v0, 0    # Initialize result to 0
    li $t1, 10   # Base 10 multiplier
    li $t2, 1    # Sign (1 = positive, -1 = negative)

    lb $t3, 0($a0)
    bne $t3, 45, convert_loop  # If not '-', jump to conversion

    li $t2, -1   # If '-', set sign to negative
    addi $a0, $a0, 1

convert_loop:
    lb $t3, 0($a0)
    beq $t3, 10, end_conversion  # Stop at newline

    sub $t3, $t3, 48  # Convert ASCII to integer
    blt $t3, 0, end_conversion
    bgt $t3, 9, end_conversion

    mul $v0, $v0, $t1  # v0 = v0 * 10
    add $v0, $v0, $t3  # v0 = v0 + digit

    addi $a0, $a0, 1
    j convert_loop

end_conversion:
    mul $v0, $v0, $t2  # Apply sign
    jr $ra

# Function: find_GCD
# Computes GCD using Euclidean Algorithm
find_GCD:
    subi $sp, $sp, 8      # Allocate stack space
    sw $ra, 0($sp)        # Save return address
    sw $a1, 4($sp)        # Save second operand

    beq $a1, $zero, gcd_done  # If b == 0, GCD is a

    div $a0, $a1          # Divide a by b
    mfhi $t0              # t0 = a % b

    move $a0, $a1         # a = b
    move $a1, $t0         # b = remainder
    jal find_GCD          # Recursive call

gcd_done:
    lw $ra, 0($sp)        # Restore return address
    lw $a1, 4($sp)        # Restore original b
    addi $sp, $sp, 8      # Deallocate stack
    move $v0, $a0         # Store result in v0
    jr $ra                # Return

# Exit program
exit:
    li $v0, 10
    syscall
