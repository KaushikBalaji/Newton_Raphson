`timescale 1ns/1ps

module tb_nonpipeline;

    parameter N = 8;
    parameter W = 16;

    reg [W-1:0] a;
    reg [W-1:0] x0;
    reg clk;
    reg rst;
    wire [W-1:0] result;

    localparam ITER = 4;

     // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end
    
    inv_sqr_root #(N, W) dut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .x0(x0),
        .result(result)
    );

    initial begin
        // TEST 1: a = 4.0, x0 = 0.4
        rst = 1;
        #10;
        rst = 0;

        a = 16'd1024; // 4.0 in fixed-point
        x0 = 16'd50;  // 0.4 in fixed-point

        repeat(ITER+2) @(posedge clk);
        $display("TEST 1 (a=4.0, x0=0.4): Result = %d -- Expected: 128", result);

        // TEST 2: a = 8.0, x0 = 0.33
        a = 16'd2048; // 8.0 in fixed-point
        x0 = 16'd50;  // 0.33 in fixed-point
        #(ITER * 10); // Wait for all iterations to complete

        repeat(ITER+2) @(posedge clk);
        $display("TEST 2 (a=8.0, x0=0.33): Result = %d -- Expected: 91", result);

        
        // TEST 3: a = 2.0, x0 = 0.7
        a = 16'd512; // 2.0 in fixed-point
        x0 = 16'd120; // 0.7 in fixed-point
        #(ITER * 10); // Wait for all iterations to complete

        repeat(ITER+2) @(posedge clk);
        $display("TEST 3 (a=2.0, x0=0.7): Result = %d -- Expected: 181", result);

        $finish;
    end


    initial begin
        $dumpfile("nr_nonpipe.vcd");   // output file
        $dumpvars(0, tb_nonpipeline); // dump entire testbench hierarchy
    end




endmodule



