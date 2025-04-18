# 🧠 Computer Architecture Lab – MIPS (MARS)

## 🔍 Overview
This repository contains solutions to **Lab 3** of the Computer Architecture course. The lab explores **floating-point arithmetic**, **numerical integration**, and **file I/O operations** in MIPS assembly using the MARS simulator.

---

## 📘 Lab Exercises

### 🧮 Exercise 1: Quadratic Equation Solver (`Ex1_Lab3.asm`)
**Goal:** Solve the quadratic equation $ax^2 + bx + c = 0$ using user-input floating-point coefficients.

#### Steps:
1. **Input:**  
   Read values for $a$, $b$, and $c$ via `li $v0, 6`.  
   Store them in `$f1`, `$f2`, and `$f3`.

2. **Special Cases:**
   - If $a = 0$:
     - If $b \ne 0$, solve as linear → $x = -\frac{c}{b}$
     - If $b = 0$: 
       - If $c = 0$ → infinite solutions.
       - Else → no real solution.

3. **Discriminant:**  
   Compute $\Delta = b^2 - 4ac$ using `mul.s`, `sub.s`.

4. **Solutions:**
   - If $\Delta < 0$ → No real roots.
   - If $\Delta = 0$ → One solution:  
     $$
     x = \frac{-b}{2a}
     $$
   - If $\Delta > 0$ → Two solutions:  
     $$
     x_1 = \frac{-b + \sqrt{\Delta}}{2a}, \quad x_2 = \frac{-b - \sqrt{\Delta}}{2a}
     $$

5. **Output:**  
   Print roots using `li $v0, 2` (float), and messages using `li $v0, 4`.

---

### 📐 Exercise 2: Definite Integral Calculation (`Ex2_Lab3.asm`)
**Goal:** Compute the definite integral:

$$
f(x) = \int_v^u \frac{ax^6 + bx^5 + cx}{d^4 + e^3} \, dx
$$

User provides floating-point values for $a$, $b$, $c$, $d$, $e$, $u$, and $v$.

#### Steps:
1. **Input:**  
   Read all inputs into `$f1`–`$f7`.

2. **Denominator:**  
   Compute $d^4 + e^3$, then invert to get $\frac{1}{d^4 + e^3}$.

3. **Antiderivative Terms:**  
   - $\frac{a(u^7 - v^7)}{7}$
   - $\frac{b(u^6 - v^6)}{6}$
   - $\frac{c(u^2 - v^2)}{2}$  
   Sum all three.

4. **Final Result:**  
   Multiply sum by $\frac{1}{d^4 + e^3}$ to get the integral value.

5. **Output:**  
   Display the floating-point result.

---

### 📂 Exercise 3: File I/O and String Formatting (`Ex3_Lab3.asm`)
**Goal:** Read personal data from `raw_input.txt`, format it, display it, and write to `formatted_result.txt`.

#### Steps:
1. **File Read:**
   - Open `raw_input.txt` (mode: read).
   - Read up to 256 bytes into a buffer.
   - Close file.

2. **Memory Allocation:**
   - Use syscall `9` to allocate heap space.
   - Copy data to allocated memory.

3. **Parsing and Formatting:**
   - Split comma-separated fields: `Name`, `ID`, `Address`, `Age`, `Religion`.
   - Print each field with its label and a newline.

4. **File Write:**
   - Open `formatted_result.txt` (mode: write).
   - Write the labeled fields with newlines.
   - Close file.

---

## ⚠️ Notes
- Ensure `raw_input.txt` is located in the **same directory** as MARS’ working directory.