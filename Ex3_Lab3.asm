.data
input_file:       .asciiz "raw_input.txt"
output_file:      .asciiz "formatted_result.txt"
header:           .asciiz "-----Student personal information-----\n"
name_label:       .asciiz "Name: "
id_label:         .asciiz "ID: "
address_label:    .asciiz "Address: "
age_label:        .asciiz "Age: "
religion_label:   .asciiz "Religion: "
newline:          .asciiz "\n"
buffer:           .space 256      # Temporary buffer

.text
main:
    # --- Step 1: Open file for reading ---
    li $v0, 13
    la $a0, input_file
    li $a1, 0           # Read mode
    li $a2, 0
    syscall
    bltz $v0, exit      # If error, exit
    move $s0, $v0       # Save file descriptor

    # --- Step 2: Read file contents ---
    li $v0, 14
    move $a0, $s0
    la $a1, buffer
    li $a2, 256
    syscall
    move $s1, $v0       # $s1 = number of bytes read

    # --- Step 3: Close input file ---
    li $v0, 16
    move $a0, $s0
    syscall

    # --- Step 4: Allocate heap memory dynamically ---
    li $v0, 9
    move $a0, $s1
    syscall
    move $s2, $v0       # $s2 = address of allocated memory

    # --- Step 5: Copy buffer to allocated memory ---
    la $t0, buffer      # source
    move $t1, $s2       # dest
    li $t2, 0           # counter
copy_loop:
    beq $t2, $s1, copy_done
    lb  $t3, 0($t0)
    sb  $t3, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    j copy_loop
copy_done:

    # --- Step 6: Print to terminal in formatted format ---
    li $v0, 4
    la $a0, header
    syscall

    move $t0, $s2       # pointer to string
    li $t1, 0           # field counter (0–4)

print_loop:
    beq $t1, 0, print_name
    beq $t1, 1, print_id
    beq $t1, 2, print_address
    beq $t1, 3, print_age
    beq $t1, 4, print_religion
    j print_done

print_name:
    li $v0, 4
    la $a0, name_label
    syscall
    j print_field
print_id:
    li $v0, 4
    la $a0, id_label
    syscall
    j print_field
print_address:
    li $v0, 4
    la $a0, address_label
    syscall
    j print_field
print_age:
    li $v0, 4
    la $a0, age_label
    syscall
    j print_field
print_religion:
    li $v0, 4
    la $a0, religion_label
    syscall
    j print_field

print_field:
    move $t2, $t0       # start of field
scan_loop:
    lb  $t3, 0($t0)
    beq $t3, 0, scan_end
    beq $t3, 44, scan_end   # ASCII for ','
    addi $t0, $t0, 1
    j scan_loop
scan_end:
    sb  $zero, 0($t0)   # null-terminate
    li $v0, 4
    move $a0, $t2
    syscall

    li $v0, 4           # print newline
    la $a0, newline
    syscall

    addi $t0, $t0, 1    # skip comma
    addi $t1, $t1, 1    # next field
    j print_loop

print_done:

    # --- Step 7: Write to file ---
    li $v0, 13
    la $a0, output_file
    li $a1, 1       # write mode
    li $a2, 0
    syscall
    move $s3, $v0   # file descriptor

    li $v0, 15
    move $a0, $s3
    la $a1, header
    li $a2, 38       # Length of header string
    syscall

    # newline
    li $v0, 15
    move $a0, $s3
    la $a1, newline
    li $a2, 1
    syscall

    move $t0, $s2
    li $t1, 0

write_loop:
    beq $t1, 0, write_name
    beq $t1, 1, write_id
    beq $t1, 2, write_address
    beq $t1, 3, write_age
    beq $t1, 4, write_religion
    j write_done

write_name:
    li $v0, 15
    move $a0, $s3
    la $a1, name_label
    li $a2, 6
    syscall
    j write_field
write_id:
    li $v0, 15
    move $a0, $s3
    la $a1, id_label
    li $a2, 4
    syscall
    j write_field
write_address:
    li $v0, 15
    move $a0, $s3
    la $a1, address_label
    li $a2, 9
    syscall
    j write_field
write_age:
    li $v0, 15
    move $a0, $s3
    la $a1, age_label
    li $a2, 5
    syscall
    j write_field
write_religion:
    li $v0, 15
    move $a0, $s3
    la $a1, religion_label
    li $a2, 10
    syscall
    j write_field

write_field:
    move $t2, $t0
field_scan:
    lb  $t3, 0($t0)
    beq $t3, 0, field_end
    beq $t3, 44, field_end
    addi $t0, $t0, 1
    j field_scan
field_end:
    sub $t4, $t0, $t2
    li  $v0, 15
    move $a0, $s3
    move $a1, $t2
    move $a2, $t4
    syscall

    # newline
    li $v0, 15
    move $a0, $s3
    la $a1, newline
    li $a2, 1
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j write_loop

write_done:

    # --- Step 8: Close file ---
    li $v0, 16
    move $a0, $s3
    syscall

exit:
    li $v0, 10
    syscall