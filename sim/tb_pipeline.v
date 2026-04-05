`timescale 1ns/1ps

module tb_pipeline;

    parameter N = 8;
    parameter W = 16;
    parameter N_ITERS = 4;
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

    initial begin
        rst = 1; a_in = 0; x0_in = 0;
        repeat(5) @(posedge clk);
        rst = 0;
        
        // Feeding continuous stream
        // =========================
        // 1. Boundary around 1.0 (VERY IMPORTANT)
        // =========================
        @(posedge clk); a_in <= 16'd255;  x0_in <= 16'd260;  // just below 1.0
        @(posedge clk); a_in <= 16'd256;  x0_in <= 16'd256;  // exactly 1.0
        @(posedge clk); a_in <= 16'd257;  x0_in <= 16'd250;  // just above 1.0

        // =========================
        // 2. Around powers of 2 (transition edges)
        // =========================
        @(posedge clk); a_in <= 16'd511;  x0_in <= 16'd130;  // just below 512
        @(posedge clk); a_in <= 16'd513;  x0_in <= 16'd125;  // just above 512

        @(posedge clk); a_in <= 16'd1023; x0_in <= 16'd100;  // just below 1024
        @(posedge clk); a_in <= 16'd1025; x0_in <= 16'd95;   // just above 1024

        // =========================
        // 3. Mid-range random (non power-of-2)
        // =========================
        @(posedge clk); a_in <= 16'd300;  x0_in <= 16'd200;
        @(posedge clk); a_in <= 16'd700;  x0_in <= 16'd140;
        @(posedge clk); a_in <= 16'd1500; x0_in <= 16'd80;
        @(posedge clk); a_in <= 16'd3000; x0_in <= 16'd60;
        @(posedge clk); a_in <= 16'd10000;x0_in <= 16'd30;

        // =========================
        // 4. Very small numbers (j << N)
        // =========================
        @(posedge clk); a_in <= 16'd1;    x0_in <= 16'd4096;
        @(posedge clk); a_in <= 16'd3;    x0_in <= 16'd3000;
        @(posedge clk); a_in <= 16'd5;    x0_in <= 16'd2500;
        @(posedge clk); a_in <= 16'd7;    x0_in <= 16'd2000;
        @(posedge clk); a_in <= 16'd9;    x0_in <= 16'd1800;

        // =========================
        // 5. Large values near limit
        // =========================
        @(posedge clk); a_in <= 16'd32767; x0_in <= 16'd20;
        @(posedge clk); a_in <= 16'd40000; x0_in <= 16'd18;
        @(posedge clk); a_in <= 16'd50000; x0_in <= 16'd17;
        @(posedge clk); a_in <= 16'd65535; x0_in <= 16'd16;

        // =========================
        // 6. Alternating bit patterns (stress LOD)
        // =========================
        @(posedge clk); a_in <= 16'b1010101010101010; x0_in <= 16'd50;
        @(posedge clk); a_in <= 16'b0101010101010101; x0_in <= 16'd50;

        // =========================
        // 7. Single-bit sweep (VERY IMPORTANT)
        // =========================
        @(posedge clk); a_in <= 16'd1;     x0_in <= 16'd4096;  // 2^0
        @(posedge clk); a_in <= 16'd2;     x0_in <= 16'd4096;  // 2^1
        @(posedge clk); a_in <= 16'd4;     x0_in <= 16'd2048;  // 2^2
        @(posedge clk); a_in <= 16'd8;     x0_in <= 16'd1500;  // 2^3
        @(posedge clk); a_in <= 16'd16;    x0_in <= 16'd1000;  // 2^4
        @(posedge clk); a_in <= 16'd32;    x0_in <= 16'd800;   // 2^5
        @(posedge clk); a_in <= 16'd64;    x0_in <= 16'd600;   // 2^6
        @(posedge clk); a_in <= 16'd128;   x0_in <= 16'd400;   // 2^7
        @(posedge clk); a_in <= 16'd256;   x0_in <= 16'd256;   // 2^8
        @(posedge clk); a_in <= 16'd512;   x0_in <= 16'd180;   // 2^9
        @(posedge clk); a_in <= 16'd1024;  x0_in <= 16'd128;   // 2^10
        @(posedge clk); a_in <= 16'd2048;  x0_in <= 16'd90;    // 2^11
        @(posedge clk); a_in <= 16'd4096;  x0_in <= 16'd64;    // 2^12
        @(posedge clk); a_in <= 16'd8192;  x0_in <= 16'd45;    // 2^13
        @(posedge clk); a_in <= 16'd16384; x0_in <= 16'd32;    // 2^14
        @(posedge clk); a_in <= 16'd32768; x0_in <= 16'd22;    // 2^15
        @(posedge clk); a_in <= 0; x0_in <= 0;
        
        repeat(LATENCY + 5) begin
            if (result != 0) begin
                $display("Time: %t | Input A: %d | Start Value: %d | Result: %d", 
                         $time, a_history[LATENCY - 1], x0_history[LATENCY - 1], result);
            end
            @(posedge clk);
        end
        $finish;
    end

    initial begin
        $dumpfile("nr_pipeline.vcd");
        $dumpvars(0, tb_pipeline);
    end
endmodule