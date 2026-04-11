`timescale 1ns/1ps

module tb_pipeline;

    parameter N = 8;
    parameter W = 16;
    parameter N_ITERS = 3;
    localparam LATENCY = N_ITERS * 3;

    reg clk, rst;
    reg [W-1:0] a_in, x0_in;
    wire [W-1:0] result;

    reg [W-1:0] a_history [0:LATENCY + N_ITERS];
    reg [W-1:0] x0_history [0:LATENCY + N_ITERS];

    initial clk = 0;
    always #5 clk = ~clk;

    top_pipelined #(N, W, N_ITERS) dut (
        .clk(clk), .rst(rst), .x0(x0_in), .a_in(a_in), .result(result)
    );

    integer j;
    always @(posedge clk) begin
        a_history[0] <= a_in;
        x0_history[0] <= x0_in;
        for (j = 1; j <= LATENCY + N_ITERS; j = j + 1) begin
            a_history[j] <= a_history[j-1];
            x0_history[j] <= x0_history[j-1];
        end
    end

    integer i;
    integer total_inputs = 36; // Total count of cases in your list

    initial begin
        // --- Setup ---
        rst = 1; a_in = 0; x0_in = 0;
        repeat(10) @(posedge clk);
        rst = 0;
        @(posedge clk);

        // --- Feeding your specific stream ---
        // 1. Boundary around 1.0
        @(posedge clk); a_in <= 16'd255;  x0_in <= 16'd260; 
        @(posedge clk); a_in <= 16'd256;  x0_in <= 16'd256; 
        @(posedge clk); a_in <= 16'd257;  x0_in <= 16'd250; 

        // 2. Transition edges
        @(posedge clk); a_in <= 16'd511;  x0_in <= 16'd130; 
        @(posedge clk); a_in <= 16'd513;  x0_in <= 16'd125; 
        @(posedge clk); a_in <= 16'd1023; x0_in <= 16'd100; 
        @(posedge clk); a_in <= 16'd1025; x0_in <= 16'd95;  

        // 3. Mid-range random
        @(posedge clk); a_in <= 16'd300;   x0_in <= 16'd200;
        @(posedge clk); a_in <= 16'd700;   x0_in <= 16'd140;
        @(posedge clk); a_in <= 16'd1500;  x0_in <= 16'd80;
        @(posedge clk); a_in <= 16'd3000;  x0_in <= 16'd60;
        @(posedge clk); a_in <= 16'd10000; x0_in <= 16'd30;

        // 4. Very small numbers
        @(posedge clk); a_in <= 16'd1;    x0_in <= 16'd4096;
        @(posedge clk); a_in <= 16'd3;    x0_in <= 16'd2048;
        @(posedge clk); a_in <= 16'd5;    x0_in <= 16'd2500;
        @(posedge clk); a_in <= 16'd7;    x0_in <= 16'd2000;
        @(posedge clk); a_in <= 16'd9;    x0_in <= 16'd1800;

        // 5. Large values
        @(posedge clk); a_in <= 16'd32767; x0_in <= 16'd20;
        @(posedge clk); a_in <= 16'd40000; x0_in <= 16'd18;
        @(posedge clk); a_in <= 16'd50000; x0_in <= 16'd17;
        @(posedge clk); a_in <= 16'd65535; x0_in <= 16'd16;

        // 6. Single-bit sweep
        @(posedge clk); a_in <= 16'd1;     x0_in <= 16'd4096;
        @(posedge clk); a_in <= 16'd2;     x0_in <= 16'd4096;
        @(posedge clk); a_in <= 16'd4;     x0_in <= 16'd2048;
        @(posedge clk); a_in <= 16'd8;     x0_in <= 16'd1500;
        @(posedge clk); a_in <= 16'd16;    x0_in <= 16'd1000;
        @(posedge clk); a_in <= 16'd32;    x0_in <= 16'd800;
        @(posedge clk); a_in <= 16'd64;    x0_in <= 16'd600;
        @(posedge clk); a_in <= 16'd128;   x0_in <= 16'd400;
        @(posedge clk); a_in <= 16'd256;   x0_in <= 16'd256;
        @(posedge clk); a_in <= 16'd512;   x0_in <= 16'd180;
        @(posedge clk); a_in <= 16'd1024;  x0_in <= 16'd128;
        @(posedge clk); a_in <= 16'd2048;  x0_in <= 16'd90;
        @(posedge clk); a_in <= 16'd4096;  x0_in <= 16'd64;
        @(posedge clk); a_in <= 16'd8192;  x0_in <= 16'd45;
        @(posedge clk); a_in <= 16'd16384; x0_in <= 16'd32;
        @(posedge clk); a_in <= 16'd32768; x0_in <= 16'd22;

        // --- End of Data ---
        @(posedge clk); a_in <= 0; x0_in <= 0;

        // --- Wait for last result to exit pipeline ---
        repeat (LATENCY + 5) @(posedge clk);
        $display("Simulation completed all cases.");
        $finish;
    end

    initial begin
        forever begin
            @(posedge clk);
            if (result !== 0 && a_history[8] !== 0) begin
                $display("Time: %t | Input A: %d | Start x0: %d | Result: %d", $time, a_history[8], x0_history[8], result);
            end
        end
    end

    initial begin
        $dumpfile("nr_pipeline.vcd");
        $dumpvars(0, tb_pipeline);
    end
endmodule