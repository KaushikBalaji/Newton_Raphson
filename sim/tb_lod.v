`timescale 1ns/1ps

module tb_lod;
    parameter N = 16;
    
    reg clk, rst;
    reg [N-1:0] x_in;
    wire [N-1:0] x_out;
    

    initial clk = 0;
    always #5 clk = ~clk;

    LOD #(N) dut (
        .x_in(x_in),
        .x_out(x_out)
    );

    initial begin       
        x_in = 16'd1024; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd512; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd256; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd64; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd2048; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd4096; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd16384; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd25600; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        x_in = 16'd57600; #10; $display("Time: %t | Input A: %d | LOD Output: %d ", $time, x_in, x_out);
        $finish;
    end

    initial begin
        $dumpfile("lod.vcd");   // output file
        $dumpvars(0, tb_lod); // dump entire testbench hierarchy
    end
endmodule