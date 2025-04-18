.data
msg_a:      .asciiz "Please insert a: "
msg_b:      .asciiz "Please insert b: "
msg_c:      .asciiz "Please insert c: "
msg_x:      .asciiz "There is one solution, x = "
msg_x1:     .asciiz "x1 = "
msg_x2:     .asciiz " x2 = "
msg_nosol:  .asciiz "There is no real solution"
msg_infsol: .asciiz "All coefficients are zero. There are infinitely many solutions."

# Constants used in calculations
zero:       .float 0.0
two:        .float 2.0
four:       .float 4.0
minus_one:  .float -1.0

.text

######################
# READ INPUT SECTION #
######################
read_input:
    # Prompt for 'a'
    li $v0, 4           # syscall for print_string
    la $a0, msg_a       # load address of msg_a
    syscall

    # Read float a into $f1
    li $v0, 6           # syscall for read_float
    syscall
    mov.s $f1, $f0      # move read value into $f1 (a)

    # Prompt for 'b'
    li $v0, 4
    la $a0, msg_b
    syscall

    # Read float b into $f2
    li $v0, 6
    syscall
    mov.s $f2, $f0      # move read value into $f2 (b)

    # Prompt for 'c'
    li $v0, 4
    la $a0, msg_c
    syscall

    # Read float c into $f3
    li $v0, 6
    syscall
    mov.s $f3, $f0      # move read value into $f3 (c)

##############################
# CALCULATE DISCRIMINANT (delta) #
##############################
# Check if a == 0.0
l.s $f4, zero
c.eq.s $f1, $f4
bc1f continue_check        # if a != 0, it's a quadratic → continue_check

# Now check b == 0.0
c.eq.s $f2, $f4
bc1f linear_case           # if b ≠ 0, it's a linear equation → handle separately

# Now check c == 0.0
c.eq.s $f3, $f4
bc1f no_sol                # a=0, b=0, c≠0 → no solution

# All a, b, c == 0 → infinite solutions
li $v0, 4
la $a0, msg_infsol
syscall
j exit

###########################
# CASE: LINEAR EQUATION   #
###########################
linear_case:
# x = -c / b
    l.s $f7, minus_one
    mul.s $f3, $f3, $f7     # -c
    div.s $f1, $f3, $f2     # x = -c / b

    li $v0, 4
    la $a0, msg_x
    syscall

    mov.s $f12, $f1
    li $v0, 2
    syscall
    j exit
#################
# Continue calculate delta
#################
continue_check:
# proceed to discriminant calculation
    # delta = b^2 - 4ac
    l.s $f7, four           # Load 4.0 into $f7
    mul.s $f5, $f2, $f2     # f5 = b^2
    mul.s $f4, $f1, $f7     # f4 = 4a
    mul.s $f4, $f4, $f3     # f4 = 4ac
    sub.s $f5, $f5, $f4     # f5 = b^2 - 4ac

    # Compare delta with 0
    l.s $f7, zero
    c.lt.s $f5, $f7         # if delta < 0
    bc1t no_sol             # → no real solution
    c.eq.s $f5, $f7         # if delta == 0
    bc1t one_sol            # -> one solution
    j two_sol               # otherwise -> two real solutions

###########################
# CASE: NO REAL SOLUTION  #
###########################
no_sol:
    li $v0, 4
    la $a0, msg_nosol       # Print "There is no real solution"
    syscall
    j exit

#########################
# CASE: ONE SOLUTION    #
#########################
one_sol:
    # x = -b / (2a)
    l.s $f7, minus_one
    mul.s $f2, $f2, $f7     # -b
    l.s $f7, two
    mul.s $f1, $f1, $f7     # 2a
    div.s $f1, $f2, $f1     # f1 = x = -b / (2a)

    # Print message for single root
    li $v0, 4
    la $a0, msg_x
    syscall

    # Print the result x
    mov.s $f12, $f1         # move result into $f12 for float print
    li $v0, 2               # syscall for print_float
    syscall
    j exit

#########################
# CASE: TWO SOLUTIONS   #
#########################
two_sol:
    sqrt.s $f6, $f5         # f6 = sqrt(delta)

    # Compute -b
    l.s $f7, minus_one
    mul.s $f10, $f7, $f2    # f10 = -b

    # Compute 2a
    l.s $f11, two
    mul.s $f11, $f11, $f1   # f11 = 2a

    # x1 = (-b + sqrt(Δ)) / (2a)
    sub.s $f8, $f10, $f6    # f8 = -b + sqrt(delta)
    div.s $f8, $f8, $f11    # f8 = x1

    # x2 = (-b - sqrt(Δ)) / (2a)
    add.s $f9, $f10, $f6    # f9 = -b - sqrt(delta)
    div.s $f9, $f9, $f11    # f9 = x2

    # Print x1
    li $v0, 4
    la $a0, msg_x1
    syscall

    mov.s $f12, $f8         # f12 = x1
    li $v0, 2
    syscall

    # Print x2
    li $v0, 4
    la $a0, msg_x2
    syscall

    mov.s $f12, $f9         # f12 = x2
    li $v0, 2
    syscall

#############
# PROGRAM END
#############
exit:
    li $v0, 10              # syscall to exit
    syscall
