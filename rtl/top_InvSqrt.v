`timescale 1ns/1ps

module top_InvSqrt #(
    parameter N = 8, 
    parameter W = 16,
    parameter N_ITERS = 3
)(
    input clk,
    input rst,
    input [W-1:0] a_in,
    output [W-1:0] result
);

    wire [W-1:0] generated_x0;
    reg [W-1:0] a_delayed;

    // 1. Generate the initial guess automatically
    initial_approx #(N, W) approx_unit (
        .clk(clk),
        .a_in(a_in),
        .approx_out(generated_x0)
    );

    // 2. Delay 'a_in' by 1 cycle to match approx_out's register delay
    always @(posedge clk) begin
        if (rst) a_delayed <= 0;
        else     a_delayed <= a_in;
    end

    // 3. Feed the generated x0 and delayed 'a' into the NR pipeline
    top_pipelined #(N, W, N_ITERS) nr_pipeline (
        .clk(clk),
        .rst(rst),
        .x0(generated_x0),
        .a_in(a_delayed),
        .result(result)
    );

endmodule