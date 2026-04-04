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
        @(posedge clk); a_in <= 16'd1024; x0_in <= 16'd128; // Exp 128
        @(posedge clk); a_in <= 16'd512;  x0_in <= 16'd181; // Exp 181
        @(posedge clk); a_in <= 16'd256;  x0_in <= 16'd256; // Exp 256
        @(posedge clk); a_in <= 16'd64;   x0_in <= 16'd512; // Exp 512
        @(posedge clk); a_in <= 16'd2048; x0_in <= 16'd90;  // Exp 90
        
        @(posedge clk); a_in <= 16'd4096; x0_in <= 16'd64;  // Exp 64
		@(posedge clk); a_in <= 16'd16384; x0_in <= 16'd32;	// Exp 32
		@(posedge clk); a_in <= 16'd25600; x0_in <= 16'd26;	// Exp 26
		@(posedge clk); a_in <= 16'd36864; x0_in <= 16'd21;	// Exp 21
		@(posedge clk); a_in <= 16'd57600; x0_in <= 16'd17;	// Exp 17
        @(posedge clk); a_in <= 0; x0_in <= 0;
        
        repeat(LATENCY + 5) begin
            if (result != 0) begin
                $display("Time: %t | Input A: %d | Result: %d", 
                         $time, a_history[LATENCY - 1], result);
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