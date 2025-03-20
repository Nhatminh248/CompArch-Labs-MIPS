.data
msg: .asciiz "Please enter a positive integer less than 16: "
msg1: .asciiz "Its binary form is: "
.text
#insert integer smaller than 16
li $v0, 4
la $a0, msg
syscall

#read the integer
li $v0, 5
syscall
move $t0, $v0  
   
#shift right 3 bits then AND the least significant bit with 1 and store into t1
srl $t1, $t0, 3  
andi $t1, $t1, 1 
#shift right 2 bits then AND the least significant bit with 1 and store into t2 
srl $t2, $t0, 2 
andi $t2, $t2, 1  
#shift right 1 bits then AND the least significant bit with 1 and store into t1
srl $t3, $t0, 1 
andi $t3, $t3, 1  
#perform the AND operation on the least significant bit with 1 and store into t1
andi $t4, $t0, 1 
    
#print the result
li $v0, 4
la $a0, msg1
syscall
#print out each bit
move $a0, $t1
li $v0, 1
syscall
move $a0, $t2
syscall
move $a0, $t3
syscall
move $a0, $t4
syscall
# Exit program
li $v0, 10
syscall