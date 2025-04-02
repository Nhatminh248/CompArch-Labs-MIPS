.data
    buffer:         .space 20      # Buffer for input string (max 99 chars)
    freq:           .space 512      # 128 ASCII characters x 4 bytes each (to store frequencies)
    sorted:         .space 1024       # 128 ASCII x 4 bytes characters and 4 bytes frequencies (for sorting)

    input_prompt:   .asciiz "Enter a string: "
    newline:        .asciiz "\n"
    comma_space:    .asciiz ", "
    semicolon:      .asciiz "; "
.text
main: 
    # Print input prompt
    li $v0, 4
    la $a0, input_prompt
    syscall

    # Read user input string
    li $v0, 8
    la $a0, buffer
    li $a1, 20
    syscall

 # Count character frequencies
    la $t0, buffer      # Load string base address
    la $t1, freq        # Base of frequency array

count_loop:
    lb $t2, 0($t0)      # Load a character (byte)
    beqz $t2, sort_chars    # If null terminator, go to sorting
	beq $t2, 10, skip_newline   # Ignore newline '\n'

    sub $t3, $t2, 0     # Convert char to index (ASCII value)
    sll $t3, $t3, 2     # Multiply by 4 (word offset)
    add $t4, $t1, $t3   # Address of freq[char]
    
    lw $t5, 0($t4)      # Load current frequency
    addi $t5, $t5, 1    # Increment frequency
    sw $t5, 0($t4)      # Store updated frequency

    addi $t0, $t0, 1    # Move to next character
    j count_loop        # Repeat loop

skip_newline:
    addi $t0, $t0, 1    # Move to next character
    j count_loop        # Repeat loop

# Sorting characters by frequency (ascending) and ASCII order
sort_chars:
    li $t6, 0          # Counter for sorted array
    la $t7, sorted     # Base address of sorted array
    la $t1, freq       # Base address of frequency array

sort_outer:
    li $t3, 2147483647  # Set min frequency to large number
    li $t4, -1          # Reset min character
    li $t8, 0           # Reset index

sort_inner:
    bge $t8, 128, sort_found  # Stop when exceeding ASCII range
    sll $t9, $t8, 2           # Multiply by 4 (word offset)
    add $t2, $t1, $t9         # Address of freq[index]
    lw $t5, 0($t2)            # Load frequency

    beqz $t5, skip_sort       # Ignore if frequency is 0

    # If found a smaller frequency OR same frequency with smaller ASCII
    blt $t5, $t3, update_sort
    beq $t5, $t3, check_ascii
    j skip_sort

check_ascii:
    blt $t8, $t4, update_sort
    j skip_sort

update_sort:
    move $t3, $t5  # Update min frequency
    move $t4, $t8  # Update min ASCII char

skip_sort:
    addi $t8, $t8, 1
    j sort_inner

sort_found:
    beq $t4, -1, print_chars  # If no character found, go print

    # Store sorted character and frequency
    sll $t9, $t6, 3
    add $t7, $t7, $t9
    sw $t4, 0($t7)
    sw $t3, 4($t7)

    # Reset frequency in original array to avoid duplicates
    sll $t9, $t4, 2
    add $t2, $t1, $t9
    sw $zero, 0($t2)

    addi $t6, $t6, 1
    j sort_outer

# Printing the sorted results
print_chars:
    li $t8, 0
    la $t7, sorted

print_loop:
    bge $t8, $t6, exit_program  # If all characters printed, exit

    sll $t9, $t8, 3
    add $t7, $t7, $t9
    lw $a0, 0($t7)  # Load character
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, comma_space
    syscall

    lw $a0, 4($t7)  # Load frequency
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, semicolon
    syscall

    addi $t8, $t8, 1
    j print_loop

exit_program:
    li $v0, 10
    syscall


