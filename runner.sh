echo "Running Newton-Raphson testbench simulation..."

# Run the Verilog testbench simulation using Icarus Verilog

# Runner for pipelined version
# iverilog rtl/NR_stage_pipeline.v rtl/top_pipelined.v sim/tb_pipeline.v -o nr_pipeline
# vvp nr_pipeline
# gtkwave nr_pipeline.vcd


# Runner for non-pipelined version
# iverilog -o nr_nonpipe rtl/NR_stage.v rtl/inv_sqr_root.v sim/tb_nonpipeline.v
# vvp nr_nonpipe
# gtkwave nr_nonpipe.vcd


# LOD module checker
iverilog -o lod rtl/LOD.v rtl/initial_approx.v sim/tb_approx.v 
vvp lod
# gtkwave lod.vcd