`timescale 1ns/1ps

module tb_approx;
    parameter N = 16;
    
    reg clk, rst;
    reg [N-1:0] lod_in;
    wire [N-1:0] approx_out;
    

    initial clk = 0;
    always #5 clk = ~clk;

    initial_approx #(N) dut (
        .lod_in(lod_in),
        .approx_out(approx_out)
    );

    initial begin       
        lod_in = 16'd1024; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd512; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd256; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd64; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd2048; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd4096; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd16384; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd25600; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd36864; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        lod_in = 16'd57600; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, lod_in, approx_out);
        $finish;
    end

    initial begin
        $dumpfile("approx.vcd");   // output file
        $dumpvars(0, tb_approx); // dump entire testbench hierarchy
    end
endmodule