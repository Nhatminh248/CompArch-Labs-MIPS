.data
	array:          .space 40        # Space for 10 integers (10 x 4 bytes)
    indexArray:     .space 40        # To hold up to 10 indexes
    prompt:         .asciiz "Please insert an element: "
    second_max_msg: .asciiz "Second largest value is "
    index_msg:      .asciiz ", found in index "
    newline:        .asciiz "\n"
    comma:          .asciiz ", "

.text
main:
    # Read 10 integers from user
    li $t0, 0              # Counter for reading input
    la $t1, array          # Base address of array

read_loop:
    li $v0, 4              # Print prompt
    la $a0, prompt
    syscall

    li $v0, 5              # Read integer syscall
    syscall
    sw $v0, 0($t1)         # Store integer in array

    addi $t1, $t1, 4       # Move pointer to next element
    addi $t0, $t0, 1       # Increment counter
    li $t7, 10             # Total number of elements (10)
    blt $t0, $t7, read_loop

    # Find the largest and second largest value
    la $s0, array          # Base address of the array (save in $s0)
    lw $t2, 0($s0)         # Initialize largest = array[0]
    li $t3, -2147483648    # Initialize second largest to smallest int

    li $t0, 0              # Counter for looping through array

find_max_loop:
    beq $t0, $t7, finish_find_max   # When counter reaches 10, exit loop
    sll $t8, $t0, 2        # Multiply index by 4 (word offset)
    add $t9, $s0, $t8      # Address of array[t0]
    lw $t4, 0($t9)         # Load array[t0]

    # Check if current element is greater than the largest found
    bgt $t4, $t2, update_new_largest
    # Otherwise, if current element is less than largest but greater than second largest,
    # update second largest. (We also skip if it equals the largest.)
    blt $t4, $t2, maybe_update_second
    j skip_max_update

update_new_largest:
    move $t3, $t2         # Old largest becomes second largest
    move $t2, $t4         # Update largest with new value
    j skip_max_update

maybe_update_second:
    bgt $t4, $t3, update_second
    j skip_max_update

update_second:
    move $t3, $t4         # Update second largest
skip_max_update:
    addi $t0, $t0, 1
    j find_max_loop

finish_find_max:
    # Collect indexes where element equals second largest
    li $t5, 0              # Counter for indexArray (number of found indexes)
    li $t0, 0              # Reset loop counter for array

collect_indexes:
    beq $t0, $t7, finish_collect   # Exit loop when t0 equals 10
    sll $t8, $t0, 2        # Compute offset for array index
    add $t9, $s0, $t8      # Address of array[t0]
    lw $t4, 0($t9)         # Load array[t0]
    beq $t4, $t3, store_index   # If element equals second largest, store index
    j skip_collect

store_index:
    la $t6, indexArray     # Base address of indexArray
    sll $t8, $t5, 2        # Offset for indexArray[t5]
    add $t6, $t6, $t8
    sw $t0, 0($t6)         # Store the index into indexArray
    addi $t5, $t5, 1       # Increment index counter

skip_collect:
    addi $t0, $t0, 1
    j collect_indexes

finish_collect:
    # Print the results after full array processing
    # Print "Second largest value is "
    li $v0, 4
    la $a0, second_max_msg
    syscall

    # Print second largest value
    li $v0, 1
    move $a0, $t3
    syscall

    # Print ", found in index "
    li $v0, 4
    la $a0, index_msg
    syscall

    # Loop through indexArray and print stored indexes
    li $t0, 0              # Reset counter for indexArray

print_indexes:
    beq $t0, $t5, print_newline   # If printed all stored indexes, finish printing
    la $t6, indexArray
    sll $t8, $t0, 2
    add $t6, $t6, $t8
    lw $a0, 0($t6)         # Load an index value to print
    li $v0, 1
    syscall

    addi $t0, $t0, 1

    # If not the last index, print a comma separator
    bne $t0, $t5, print_comma
    j print_indexes

print_comma:
    li $v0, 4
    la $a0, comma
    syscall
    j print_indexes

print_newline:
    li $v0, 4
    la $a0, newline
    syscall

    # 5. Exit the program
    li $v0, 10
    syscall
