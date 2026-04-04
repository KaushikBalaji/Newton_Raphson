echo "Running Newton-Raphson testbench simulation..."

# Run the Verilog testbench simulation using Icarus Verilog
iverilog rtl/NR_stage_pipeline.v rtl/top_pipelined.v sim/tb_pipeline.v -o nr_pipeline
vvp nr_pipeline
# gtkwave nr_pipeline.vcd


# iverilog -o nr_normal rtl/NR_stage.v rtl/inv_sqr_root.v sim/tb_top.v
# vvp nr_normal


