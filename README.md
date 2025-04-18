# Computer Architecture Lab - MIPS (MARS)

## Overview
This branch contains the solutions for Lab 3 of the Computer Architecture course. The lab focuses on floating-point instructions and file input/output operations in MIPS assembly language.

## Exercises and Algorithms

### Exercise 1: Quadratic Equation Solver (`Ex1_Lab3.asm`)
**Objective:** Solve the quadratic equation $ax^2 + bx + c = 0$, where $a$, $b$, and $c$ are user-provided floating-point numbers, and output the solutions (two, one, or none).

**Algorithm:**
1. **Input Reading:**  
Prompt and read floating-point values for $a$, $b$, and $c$ using system calls (`li $v0, 6`).  
Store values in floating-point registers `$f1`, `$f2`, and `$f3`.

2. **Special Case Handling:**
   - Check if $a = 0$:
     - If $b \ne 0$, solve the linear equation $bx + c = 0$ → $x = -\frac{c}{b}$.
     - If $b = 0$:
       - If $c = 0$, output *"infinitely many solutions."*
       - If $c \ne 0$, output *"no real solution."*

3. **Discriminant Calculation:**  
Compute $\Delta = b^2 - 4ac$ using floating-point operations (`mul.s`, `sub.s`).

4. **Solution Determination:**
   - If $\Delta < 0$, output *"no real solution."*
   - If $\Delta = 0$, compute single solution:  
     $$
     x = \frac{-b}{2a}
     $$
   - If $\Delta > 0$, compute two solutions:  
     $$
     x_1 = \frac{-b + \sqrt{\Delta}}{2a}, \quad x_2 = \frac{-b - \sqrt{\Delta}}{2a}
     $$

**Output:**  
Print appropriate messages and solutions using system calls (`li $v0, 4` for strings, `li $v0, 2` for floats).

---

### Exercise 2: Integral Calculation (`Ex2_Lab3.asm`)
**Objective:** Compute the definite integral  
$$
f(x) = \int_v^u \frac{ax^6 + bx^5 + cx}{d^4 + e^3} \, dx
$$  
where $u$, $v$, $a$, $b$, $c$, $d$, and $e$ are user-provided floating-point numbers.

**Algorithm:**
1. **Input Reading:**  
Prompt and read floating-point values for $u$, $v$, $a$, $b$, $c$, $d$, and $e$.  
Store them in registers `$f1` to `$f7`.

2. **Denominator Calculation:**
   - Compute $d^4$ by successive multiplications.
   - Compute $e^3$ similarly.
   - Add to get $d^4 + e^3$.
   - Compute $\frac{1}{d^4 + e^3}$.

3. **Calculate Each Integral Term:**  
Evaluate antiderivative terms at $u$ and $v$:
   - First term: $\frac{a(u^7 - v^7)}{7}$
   - Second term: $\frac{b(u^6 - v^6)}{6}$
   - Third term: $\frac{c(u^2 - v^2)}{2}$  
Sum the three terms.

4. **Final Calculation:**  
Multiply the result by $\frac{1}{d^4 + e^3}$ to get the definite integral.

**Output:**  
Print the result as a floating-point number.

---

### Exercise 3: File Input/Output and Formatting (`Ex3_Lab3.asm`)
**Objective:** Read personal information from `raw_input.txt`, format it, print to the terminal, and write to `formatted_result.txt`.

**Algorithm:**
1. **File Reading:**  
Open `raw_input.txt` for reading (`li $v0, 13`, `$a1 = 0`).  
Read up to 256 bytes into a buffer.  
Close the input file.

2. **Dynamic Memory Allocation:**  
Allocate heap memory for the string using system call (`li $v0, 9`).  
Copy the buffer to the allocated memory.

3. **Parsing and Formatting:**  
Parse the comma-separated input (`name`, `ID`, `address`, `age`, `religion`).  
For each field:
   - Print the corresponding label (e.g., `"Name: "`).
   - Print the field content until a comma or null is encountered.
   - Add a newline.

4. **File Writing:**  
Open `formatted_result.txt` for writing (`li $v0, 13`, `$a1 = 1`).  
Write the header and each labeled field with newlines.  
Close the output file.

---

### Notes
- For Exercise 3, `raw_input.txt` must exist in the *same directory* as the *simulator’s working directory* (a.k.a MARS MIPS path).