.data
prompt_u: .asciiz "Please insert u: "
prompt_v: .asciiz "Please insert v: "
prompt_a: .asciiz "Please insert a: "
prompt_b: .asciiz "Please insert b: "
prompt_c: .asciiz "Please insert c: "
prompt_d: .asciiz "Please insert d: "
prompt_e: .asciiz "Please insert e: "
one:    .float 1.0
seven:  .float 7.0
six:    .float 6.0
two:    .float 2.0
zero:   .float 0.0
four:   .float 4.0
three:  .float 3.0

.text
    # Print prompt for u
    li $v0, 4             # syscall for print_string
    la $a0, prompt_u      # load address of prompt_u
    syscall

    # Read float input for u
    li $v0, 6             
    syscall
    mov.s $f1, $f0         # store input from $f0 into $f1 (u)

    # Print prompt for v
    li $v0, 4             # syscall for print_string
    la $a0, prompt_v      # load address of prompt_v
    syscall

    # Read float input for v
    li $v0, 6             
    syscall
    mov.s $f2, $f0         # store input from $f0 into $f2 (v)

    # Print prompt for a
    li $v0, 4             # syscall for print_string
    la $a0, prompt_a      # load address of prompt_a
    syscall

    # Read float input for a
    li $v0, 6             
    syscall
    mov.s $f3, $f0         # store input from $f0 into $f3 (a)

    # Print prompt for b
    li $v0, 4             # syscall for print_string
    la $a0, prompt_b      # load address of prompt_b
    syscall

    # Read float input for b
    li $v0, 6             
    syscall
    mov.s $f4, $f0         # store input from $f0 into $f4 (b)

    # Print prompt for c
    li $v0, 4             # syscall for print_string
    la $a0, prompt_c      # load address of prompt_c
    syscall

    # Read float input for c
    li $v0, 6             
    syscall
    mov.s $f5, $f0         # store input from $f0 into $f5 (c)

    # Print prompt for d
    li $v0, 4             # syscall for print_string
    la $a0, prompt_d      # load address of prompt_d
    syscall

    # Read float input for d
    li $v0, 6             
    syscall
    mov.s $f6, $f0         # store input from $f0 into $f6 (d)

    # Print prompt for e
    li $v0, 4             # syscall for print_string
    la $a0, prompt_e      # load address of prompt_e
    syscall

    # Read float input for e
    li $v0, 6             
    syscall
    mov.s $f7, $f0         # store input from $f0 into $f7 (e)

    # Copy u and v to temp registers
    mov.s $f10, $f1 # f10 = u
    mov.s $f11, $f2 # f11 = v

############# 
# $f1 u 
# $f2 v
# $f3 a
# $f4 b
# $f5 c
# $f6 d
# $f7 e
# f10 temp u for power 
# f11 temp v for power
#############

# Do the calculation
# (1 / (d^4 + e^3)) * ( (a * (u^7 - v^7)) / 7 + (b * (u^6 - v^6)) / 6 + (c * (u^2 - v^2)) / 2 )

# First term (1 / (d^4 + e^3))

# Compute d^4
mul.s $f8, $f6, $f6   # f8 = d^2
mul.s $f8, $f8, $f6   # f8 = d^3
mul.s $f6, $f8, $f6   # f6 = d^4

# Compute e^3
mul.s $f9, $f7, $f7   # f9 = e^2
mul.s $f7, $f9, $f7   # f7 = e^3

# Add d^4 and e^3
add.s $f9, $f6, $f7   # f9 = d^4 + e^3

# Compute 1 / (d^4 + e^3)
l.s $f8, one
div.s $f6, $f8, $f9  # f6 = 1 / (d^4 + e^3)

# Second term (c * (u^2 - v^2)) / 2

# Compute u^2 and v^2
mul.s $f1, $f10, $f10   # f1 = u^2
mul.s $f2, $f11, $f11   # f2 = v^2

# Compute u^2 - v^2
sub.s $f9, $f1, $f2  # f9 = u^2 - v^2

# Multiply by c
mul.s $f5, $f5, $f9  # f5 = c * (u^2 - v^2)

# Divide by 2
l.s $f8, two
div.s $f5, $f5, $f8  # f5 = (c * (u^2 - v^2)) / 2

# Third term (b * (u^6 - v^6)) / 6

# Compute u^6
mul.s $f1, $f1, $f1    # $f1 = u⁴
mul.s $f1, $f1, $f10   # $f1 = u⁵
mul.s $f1, $f1, $f10   # $f1 = u⁶

# Compute v^6
mul.s $f2, $f2, $f2    # $f2 = v⁴
mul.s $f2, $f2, $f11   # $f2 = v⁵
mul.s $f2, $f2, $f11   # $f2 = v⁶

# Compute u^6 - v^6
sub.s $f9, $f1, $f2  # f9 = u^6 - v^6

# Multiply by b
mul.s $f4, $f4, $f9  # f4 = b * (u^6 - v^6)

# Divide by 6
l.s $f8, six
div.s $f4, $f4, $f8  # f4 = (b * (u^6 - v^6)) / 6

# Final term (a * (u^7 - v^7)) / 7

# Compute u^7
mul.s $f1, $f1, $f10   # f1 = u^7

# Compute v^7
mul.s $f2, $f2, $f11   # f2 = v^7

# Compute u^7 - v^7
sub.s $f9, $f1, $f2  # f9 = u^7 - v^7

# Multiply by a
mul.s $f3, $f3, $f9  # f3 = a * (u^7 - v^7)

# Divide by 7
l.s $f8, seven
div.s $f3, $f3, $f8  # f3 = (a * (u^7 - v^7)) / 7

# Calculate the equation
add.s $f3, $f3, $f4  # f3 += f4
add.s $f3, $f3, $f5  # f3 += f5
mul.s $f3, $f3, $f6  # f3 *= f6

# Print the result 
mov.s $f12, $f3 
li $v0, 2
syscall

# Exit
li $v0, 10
syscall