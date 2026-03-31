`timescale 1ns/1ps

module NR_stage #(parameter N = 8, parameter W = 2*N)(
	input clk,
	input rst,
    input  signed [W-1:0] x_in,
    input  signed [W-1:0] a,
    output reg  signed [W-1:0] x_out
);

	
	
    wire signed [2*W-1:0] x_sq_full;
    assign x_sq_full = x_in * x_in;

    wire signed [W-1:0] x_sq;
    wire signed [2*W-1:0] x_sq_shifted;
    assign x_sq_shifted = x_sq_full >>> N;

    assign x_sq = x_sq_shifted[W-1:0];
    wire signed [2*W-1:0] ax2_full;
    assign ax2_full = a * x_sq;

    wire signed [W-1:0] ax2;
    wire signed [2*W-1:0] ax2_shifted;
    assign ax2_shifted = ax2_full >>> N;
    assign ax2 = ax2_shifted[W-1:0];


    wire signed [W-1:0] term;
    assign term = (3 <<< N) - ax2;

    wire signed [2*W-1:0] mult_full;
    assign mult_full = x_in * term;

    wire signed [W-1:0] mult;
    wire signed [2*W-1:0] mult_shifted;
    assign mult_shifted = mult_full >>> N;
    assign mult = mult_shifted[W-1:0];


    assign x_out = mult >>> 1;

endmodule
