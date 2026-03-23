`timescale 1ns/1ps

module tb_inv_sqr_root;

    parameter N = 16;
    parameter FRAC = 8;

    reg clk;
    reg rst;
    reg start;
    reg [N-1:0] a;
    reg [N-1:0] x0;

    wire [N-1:0] result;
    wire done;

    inv_sqr_root #(N, FRAC) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .x0(x0),
        .result(result),
        .done(done)
    );

    always #5 clk = ~clk;

    // Standard Verilog function
    function real fixed_to_real;
        input [N-1:0] val;
        begin
            // Handle as signed manually if necessary, or simple division
            fixed_to_real = val / (1.0 * (1 << FRAC));
        end
    endfunction

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        a = 0;
        x0 = 0;

        #50 rst = 0;

        // TEST 1: a = 4.0
        #10;
        a  = 16'd1024; // 4.0
        x0 = 16'd102;  // 0.4
        start = 1;
        #10 start = 0;

        wait(done);
        #1;
        $display("TEST 1 (a=4.0): Result = %f", fixed_to_real(result));
        
        #100;

        // TEST 2: a = 2.0
        a  = 16'd512;  // 2.0
        x0 = 16'd256;  // 1.0
        start = 1;
        #10 start = 0;

        wait(done);
        #1;
        $display("TEST 2 (a=2.0): Result = %f", fixed_to_real(result));

        #100;
        $finish;
    end

endmodule