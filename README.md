
# 🧠 Verilog-Based Microprocessor Simulation

This project simulates a simple **microprocessor architecture** using Verilog. It includes an Arithmetic Logic Unit (ALU), a register file, a microprocessor top module, and two comprehensive testbenches to validate various instructions such as arithmetic, bitwise, and logic operations.

---

## 📁 Project Structure

```
.
├── alu.v              # ALU: Supports arithmetic and logic operations
├── regfile.v          # Register file: 32 registers, read/write logic
├── dff.v              # D Flip-Flop: Used for opcode delay
├── mp_top.v           # Microprocessor top module: Integrates all components
├── testbench1.v       # Test Bench 1: Validates each ALU operation once
├── testbench2.v       # Test Bench 2: Tests operations with more variation
└── README.md          # You're here!
```

---

## ⚙️ Components Overview

### 🔹 ALU (Arithmetic Logic Unit)
- **Inputs**: `opcode`, `a`, `b`
- **Output**: `result`
- **Supported Operations**:
  - `ADD` (opcode: `001000`)
  - `SUB` (opcode: `001001`)
  - `ABS` (opcode: `000010`)
  - `NEG` (opcode: `001010`)
  - `MAX`, `MIN`, `AVG`
  - Bitwise: `NOT`, `OR`, `AND`, `XOR`

### 🔹 Register File
- 32 general-purpose registers (`MyMeMory[0:31]`)
- Supports reading from two registers and writing to one register per clock cycle.

### 🔹 D Flip-Flop
- Simple flip-flop to delay the opcode by one clock cycle for synchronization.

### 🔹 Microprocessor Top Module (`mp_top`)
- Integrates: `ALU`, `Register File`, `DFF`
- Parses a 32-bit instruction into:
  - `opcode`
  - `read addr1`
  - `read addr2`
  - `write addr`
- Passes values through ALU and stores results.

---

## 🧪 Test Benches

### ✅ `MyTestBench1`
- Validates correct implementation of each ALU operation.
- Compares results to expected values and prints failures.

### 🔁 `MyTestBench2`
- Provides redundant tests to simulate multiple scenarios.
- Helps verify stability and correctness across repeated operations.

---

## 🧾 Sample Instruction Format

| Bits          | Purpose             |
|---------------|---------------------|
| `[5:0]`       | `opcode`            |
| `[10:6]`      | `read addr1`        |
| `[15:11]`     | `read addr2`        |
| `[20:16]`     | `write addr`        |
| `[31:21]`     | unused (set to `0`) |

> Example: `000000 00001 00010 00011 00000000000` → opcode = `000000`, read from R1, R2; write to R3

---

## ✅ Expected Output

For `MyTestBench1`, you should see:
```
Test Number 1 - Instruction Format: 0x000110c8,  Result: 0x000041b6
...
All Tests passed
```
If any mismatch occurs, it will report:
```
Test fail in X tests
```

---

## 📌 Key Features

- 🧮 **11+ ALU operations** with signed/unsigned handling
- 🧠 **Microprocessor-style instruction decoding**
- 📊 **Realistic Register File simulation**
- ⏱️ **Timing delay** through DFF for opcode synchronization
- 🧪 **Comprehensive validation** via two testbenches

---

## ✍️ Author
Yara Khattab

📧 Email: yarakhattab16@gmail.com

🔗 GitHub: github.com/yarakhattab


