# Fast Inverse Square Root using Newton-Raphson (Fixed-Point Verilog)

Hardware implementation of inverse square-root computation using the Newton-Raphson iterative method in Verilog/SystemVerilog.

The project implements a fixed-point pipelined inverse square-root architecture using:
- Leading One Detector (LOD) based initial approximation
- Newton-Raphson iterative refinement
- Q-format fixed-point arithmetic
- Parameterizable iterations and widths

---

# Features

- Fully pipelined architecture
- Parameterizable Q-format precision
- Q8.8 and Q16.16 support
- Python golden reference model
- Automatic test input generation
- Randomized verification support
- VCD waveform generation
- Vivado timing analysis support

---

# Directory Structure

```text
.
├── RTL/
│   ├── LOD.v
│   ├── initial_approx.v
│   ├── NR_stage_pipeline.v
│   ├── top_pipelined.v
│   ├── top_InvSqrt.v
│   └── tb_InvSqrt.v
│
├── Python/
│   ├── generate_inputs.py
│   ├── golden_model.py
│   └── compare_results.py
│
├── Scripts/
│   ├── run_q8_8.sh
│   ├── run_q16_16.sh
│   └── clean.sh
│
├── Inputs/
│   ├── NR_inputs.txt
│   └── NR_golden_values.txt
│
├── Waves/
│   └── top.vcd
│
├── Report/
│   └── report.pdf
│
└── README.md
````

---

# Modules

## LOD.v

Leading One Detector module.

Outputs:

* One-hot MSB representation
* Index of MSB

---

## initial_approx.v

Generates the initial approximation for inverse square-root using the LOD output.

---

## NR_stage_pipeline.v

Single Newton-Raphson pipeline stage.

Each stage performs:

1. (x^2)
2. (3 - ax^2)
3. (x(3-ax^2)/2)

---

## top_pipelined.v

Chains multiple NR stages together.

---

## top_InvSqrt.v

Top-level integrated module.

Includes:

* Initial approximation
* Delayed input alignment
* NR pipeline

---

# Fixed-Point Format

Supported formats:

* QN.N

Example:

* Q16.16 → 16 integer bits + 16 fractional bits

---

# Generating Random Inputs

```
python Inputs_generate.py
```
This:
1. Generates random inputs from 1 to 2<sup>N</sup>-1 integers
2. Includes powers of 2, test inputs for overflow conditions

---

# Generating Golden Outputs

Run:

```bash
python InverseSqrt_golden.py    # golden output generated with Python's math.pow()
python NR_golden.py             # golden output generated with same architecture as Verilog version 
```

This:

1. Reads `NR_inputs.txt`
2. Computes inverse square-root values
3. Writes outputs to:

```text
NR_golden_values.txt
```

---

# Running Simulation

## Compile

```bash
iverilog -o sim RTL/*.v
```

## Run

```bash
vvp sim > log.txt
```

## Open Waveform

```bash
gtkwave top.vcd
```

---

# Bash Automation Scripts

## Run different modules of the project with different options

```bash
./runner.sh top
./runner.sh approx
./runner.sh lod
./runner.sh nopipe  # for testing purpose
```

These scripts:

* Generate golden outputs
* Compile RTL
* Run simulation
* Generate waveforms

---

# Example Output

```text
Input A: 2048
Result : 370729
Golden : 370728
Diff   : 1
```

---

# Timing Results

Vivado timing analysis:

| Metric           | Value          |
| ---------------- | -------------- |
| Critical Path    | ~7 ns          |
| Pipeline Latency | 13 cycles      |
| Throughput       | 1 result/cycle |

---

# Tools Used

* Verilog/SystemVerilog
* Icarus Verilog
* GTKWave
* Vivado
* Python 3

---

# References

1. E. Libessart, M. Arzel, C. Lahuec and F. Andriulli,
   "A scaling-less Newton-Raphson pipelined implementation for a fixed-point inverse square root operator",
   IEEE NEWCAS, 2017.

2. Quake III Arena Fast Inverse Square Root Algorithm,
   id Software source release, 1999.

```
```
