.data
inE0: .asciiz "Please input element 0: \n"
inE1: .asciiz "Please input element 1: \n"
inE2: .asciiz "Please input element 2: \n"
inE3: .asciiz "Please input element 3: \n"
inE4: .asciiz "Please input element 4: \n"
outE: .asciiz "Please enter index: \n"
array: .space 20 # 20 bytes for 5 int x 4 byte
.text
# Load base address of array
la $t2, array
         
# Print message 0
li $v0, 4
la $a0, inE0
syscall
# Read int value 0
li $v0, 5
syscall
sw $v0, 0($t2)
addi $t2, $t2, 4 # move to the next index of array

# Print message 1
li $v0, 4
la $a0, inE1
syscall
# Read int value 1
li $v0, 5
syscall
sw $v0, 0($t2)
addi $t2, $t2, 4 # move to the next index of array

# Print message 2
li $v0, 4
la $a0, inE2
syscall
# Read int value 2
li $v0, 5
syscall
sw $v0, 0($t2)
addi $t2, $t2, 4 # move to the next index of array

# Print message 3
li $v0, 4
la $a0, inE3
syscall
# Read int value 3
li $v0, 5
syscall
sw $v0, 0($t2)
addi $t2, $t2, 4 # move to the next index of array

# Print message 4
li $v0, 4
la $a0, inE4
syscall
# Read int value 4
li $v0, 5
syscall
sw $v0, 0($t2)

# Print index request message
li $v0, 4
la $a0, outE
syscall
# Read input for index
li $v0, 5
syscall
add $t3, $0, $v0 

# Calculate the address
la $t2, array # load the base index of array back to $t2 to calculate 
sll $t3, $t3, 2 # shift left 2 bits by multiply by 4 to get the desired index
add $t2, $t2, $t3 # store the adress of the index value into $t2 

# Load value
lw $t4, 0($t2)

# Print output 
li $v0, 1
add $a0, $0, $t4
syscall

# Exit program
li $v0, 10
syscall