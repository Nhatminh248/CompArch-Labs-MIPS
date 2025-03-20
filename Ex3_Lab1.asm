.data 
msga: .asciiz "Insert a: \n"
msgb: .asciiz "Insert b: \n"
msgc: .asciiz "Insert c: \n"
msgd: .asciiz "Insert d: \n"
msgf: .asciiz "F = "
msgr: .asciiz ", remainder "
.text
# Print message a
li $v0, 4
la $a0, msga
syscall
# Read a
li $v0, 5
syscall
add $t1, $0, $v0

# Print message b
li $v0, 4
la $a0, msgb
syscall
# Read b
li $v0, 5
syscall
add $t2, $0, $v0

# Print message c
li $v0, 4
la $a0, msgc
syscall
# Read c
li $v0, 5
syscall
add $t3, $0, $v0

# Print message d
li $v0, 4
la $a0, msgd
syscall
# Read d
li $v0, 5
syscall
add $t4, $0, $v0

# a = t1, b =t2, c =t3, d = t4
# Calculate the numerator (a + 10) × (b − d) × (c − 2 × a)
addi $t5, $t1, 10     # t5 = (a + 10)
sub  $t6, $t2, $t4    # t6 = (b - d)
sll  $t7, $t1, 1      # t7 = 2 × a
sub  $t7, $t3, $t7    # t7 = (c - 2 × a)
mul  $t5, $t5, $t6    # (a + 10) × (b - d)
mul  $t5, $t5, $t7    # (a + 10) × (b - d) × (c - 2 × a)

# Calculate the demoninator (a + b + c)
add $t8, $t1, $t2    # (a + b)
add $t8, $t8, $t3    # (a + b + c)

# Calculate F
div $t5, $t8 

mflo $t1 # Move the quotient to t1
mfhi $t0 # Move the remainder to t0

# Print message F = 
li $v0, 4
la $a0, msgf
syscall
# Print the value of quotient F
add $a0, $0, $t1 # Assign quotient at t1 to a0
li $v0, 1 
syscall

# Print the message of remainder
li $v0, 4
la $a0, msgr
syscall
# Print the value of the remainder
add $a0, $0, $t0 # Assign remainder at t0 to a0
li $v0, 1 
syscall

# Exit program
li $v0, 10
syscall