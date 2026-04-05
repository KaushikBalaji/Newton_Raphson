#!/bin/bash

echo "Running Newton-Raphson simulation..."

case "$1" in

    pipe)
        echo "Running PIPELINED version..."
        iverilog rtl/NR_stage_pipeline.v rtl/top_pipelined.v sim/tb_pipeline.v -o nr_pipeline
        vvp nr_pipeline > logs/verilog/pipeline_output.txt
        cat logs/verilog/pipeline_output.txt
        mv nr_pipeline.vcd out/vcd/
        mv nr_pipeline out/bin/
        # gtkwave out/vcd/nr_pipeline.vcd
        ;;

    nopipe)
        echo "Running NON-PIPELINED version..."
        iverilog -o nr_nonpipe rtl/NR_stage.v rtl/inv_sqr_root.v sim/tb_nonpipeline.v
        vvp nr_nonpipe > logs/verilog/nonpipe_output.txt
        cat logs/verilog/nonpipe_output.txt
        mv nr_nonpipe.vcd out/vcd/
        mv nr_nonpipe out/bin/
        # gtkwave out/vcd/nr_nonpipe.vcd
        ;;

    lod)
        echo "Running LOD test..."
        iverilog -o lod rtl/LOD.v sim/tb_lod.v
        vvp lod > logs/verilog/lod_output.txt
        cat logs/verilog/lod_output.txt
        mv lod.vcd out/vcd/
        mv lod out/bin/
        # gtkwave out/vcd/lod.vcd
        ;;

    approx)
        echo "Running Approximation test..."
        iverilog -o approx rtl/LOD.v rtl/initial_approx.v sim/tb_approx.v 
        vvp approx > logs/verilog/approx_output.txt
        cat logs/verilog/approx_output.txt
        mv approx.vcd out/vcd/
        mv approx out/bin/
        # gtkwave out/vcd/approx.vcd
        ;;

    *)
        echo "Usage: $0 {pipe|nopipe|lod|approx}"
        exit 1
        ;;

esac