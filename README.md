# Fast Inverse Square Root using Newton-Raphson (Fixed-Point Verilog)

Hardware implementation of inverse square-root computation using the Newton-Raphson iterative method in Verilog. This was done as a mini-project for Course **EE5516** (VLSI Architectures for Signal Processing and Machine Learning) at IIT Palakkad

The project implements a fixed-point pipelined inverse square-root architecture using:
- Leading One Detector (LOD) based initial approximation
- Newton-Raphson iterative refinement
- Q-format fixed-point arithmetic
- Parameterizable iterations and widths

---

# Features

- Fully pipelined architecture
- Parameterizable Q-format precision
- QN.N format support
- Python golden reference model
- Automatic test input generation with Random inputs and corner cases included
- VCD waveform generation

---

# Directory Structure

```text
├── 152502010_EndSem_MiniProjectReport.pdf
├── approx_golden.py
├── diff_checker.py
├── Inputs_generate.py
├── InverseSqrt_golden.py
├── lod_golden.py
├── logs
│   ├── python
│   │   └── golden_output.txt
│   └── verilog
│       ├── approx_output.txt
│       ├── lod_output.txt
│       ├── nonpipe_output.txt
│       ├── pipeline_output.txt
│       └── top_output.txt
├── NR_golden.py
├── NR_golden_values.txt
├── NR_inputs.txt
├── NR_inverse_square_root.pdf
├── out
│   ├── bin
│   │   ├── approx
│   │   ├── lod
│   │   ├── nr_nonpipe
│   │   ├── nr_pipeline
│   │   └── top
│   └── vcd
│       ├── approx.vcd
│       ├── lod.vcd
│       ├── nr_nonpipe.vcd
│       ├── nr_pipeline.vcd
│       └── top.vcd
├── rtl
│   ├── initial_approx.v
│   ├── inv_sqr_root.v
│   ├── LOD.v
│   ├── NR_stage_pipeline.v
│   ├── NR_stage.v
│   ├── top_InvSqrt.v
│   └── top_pipelined.v
├── runner.sh
└── sim
    ├── tb_approx.v
    ├── tb_inv_sqr_root.v
    ├── tb_InvSqrt.v
    ├── tb_lod.v
    ├── tb_nonpipeline.v
    ├── tb_nr_stage.v
    └── tb_pipeline.v
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

---

# Contributors

- [Kaushik Balaji](https://www.linkedin.com/in/kaushikbalajims/)  
M.Tech SoCD, IIT Palakkad
- [Priyesh Narayana](https://www.linkedin.com/in/priyesh-narayana-54a7982a4/)  
M.Tech SoCD, IIT Palakkad

