`timescale 1ns/1ps

module tb_approx;
    parameter N = 8;
    parameter W = 16;
    
    reg clk, rst;
    reg [W-1:0] a_in;
    wire [W-1:0] approx_out;
    

    initial clk = 0;
    always #5 clk = ~clk;

    initial_approx #(N, W) dut (
        .a_in(a_in),
        .approx_out(approx_out)
    );

    initial begin       
        a_in = 16'd1024; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd512;  #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd256;  #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd64;   #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd2048; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd4096; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd16384;#10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);

        // Non power-of-2 values
        a_in = 16'd300;   #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd700;   #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd1500;  #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd25600; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd36864; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd57600; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);

        // Boundary around 1.0 (Q8.8)
        a_in = 16'd255; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd256; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd257; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);

        // Power-of-2 edges
        a_in = 16'd511;  #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd513;  #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd1023; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd1025; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);

        // very small
        a_in = 16'd1; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd2; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd3; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd4; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd8; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);

        // Upper range stress
        a_in = 16'd32768; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd40000; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd50000; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);
        a_in = 16'd65535; #10; $display("Time: %t | Input A: %d | Approx Output: %d ", $time, a_in, approx_out);        $finish;
    end

    initial begin
        $dumpfile("approx.vcd");   // output file
        $dumpvars(0, tb_approx); // dump entire testbench hierarchy
    end
endmodule