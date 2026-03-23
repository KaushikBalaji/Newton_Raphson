`timescale 1ns/1ps

module tb_nr_stage;

    parameter N = 8;
    parameter W = 2*N;

    reg  [W-1:0] x_in;
    reg  [W-1:0] a;
    wire [W-1:0] x_out;
    // reg clk;

    // initial begin
    //     clk = 0;
    //     forever #5 clk = ~clk; // 100 MHz clock
    // end

    NR_stage #(N,W) dut (
        // .clk(clk),
        .x_in(x_in),
        .a(a),
        .x_out(x_out)
    );

    //  Newton Raphson iteration for inverse square root

    initial begin
        // TEST 1: a = 4.0, x_in = 0.4
        a = 16'd1024; // 4.0 in fixed-point
        x_in = 16'd50; // 0.4 in fixed-point
        // wait 1 clock cycle for x_out to get the output
        // @(posedge clk);
        #50;

        $display("TEST 1 Iteration 1 (a=4.0, x_in=0.4): x_out = %d, Expected: 128" , x_out);

        x_in = x_out; // Use the output from the first test as input for the second iteration
        #50;
        $display("TEST 1 Iteration 2 (a=4.0, x_in=0.5): x_out = %d, Expected: 128" , x_out); 

        x_in = x_out; // Use the output from the second test as input for the third iteration
        #50;
        $display("TEST 1 Iteration 3 (a=4.0, x_in=0.5): x_out = %d, Expected: 128" , x_out);

        // // TEST 2: a = 2.0, x_in = 0.7
        // a = 16'd512; // 2.0 in fixed-point
        // x_in = 16'd179; // 0.7 in fixed-point
        // #10;
        // $display("TEST 2 (a=2.0, x_in=0.7): x_out = %d, Expected: 181" , x_out);

        // // TEST 3: a = 1.0, x_in = 1.0
        // a = 16'd256; // 1.0 in fixed-point
        // x_in = 16'd256; // 1.0 in fixed-point
        // #10;
        // $display("TEST 3 (a=1.0, x_in=1.0): x_out = %d, Expected: 256", x_out);

        // // Test 4: a = 16.0, x_in = 0.25
        // a = 16'd4096; // 16.0 in fixed-point
        // x_in = 16'd61; // 0.25 in fixed-point
        // #10;
        // $display("TEST 4 (a=16.0, x_in=0.24): x_out = %d, Expected: 64", x_out);

        $finish;
    end

    initial begin
        $dumpfile("nr_wave.vcd");   // output file
        $dumpvars(0, tb_nr_stage); // dump entire testbench hierarchy
    end

endmodule