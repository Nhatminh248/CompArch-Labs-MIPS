.data
msg: .asciiz "Please input your name: \n"
hello: .asciiz "\nHello, " 
name: .space 20
.text 
main: 
# Print input name request
li $v0, 4
la $a0, msg
syscall
 
# Read string input
la $a0, name
addi $a1, $0, 20
li $v0, 8
syscall

# Print string output "Hello, " + name
li $v0, 4
la $a0, hello 
syscall 

li $v0, 4 
la $a0, name 
syscall 

# Exit program
li $v0, 10
syscall