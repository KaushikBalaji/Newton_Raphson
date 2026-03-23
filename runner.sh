echo "Running Newton-Raphson testbench simulation..."
echo "Number of Iterations: 4"

# Run the Verilog testbench simulation using Icarus Verilog
iverilog rtl/NR_stage.v rtl/inv_sqr_root.v sim/tb_top.v -o nr_top
vvp nr_top

gtkwave nr_pipe.vcd