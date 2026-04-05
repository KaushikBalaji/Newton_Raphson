`timescale 1ns/1ps

module top_pipelined #(
    parameter N = 8, 
    parameter W = 16,
    parameter N_ITERS = 3
)(
    input clk,
    input rst,
    input [W-1:0] x0,
    input [W-1:0] a_in,
    output [W-1:0] result
);

    wire [W-1:0] x_bus [0:N_ITERS];
    wire [W-1:0] a_bus [0:N_ITERS];

    assign x_bus[0] = x0;
    assign a_bus[0] = a_in;

    genvar i;
    generate
        for (i = 0; i < N_ITERS; i = i + 1) begin : NR_ITER
            NR_stage_pipeline #(N, W) stage_inst (
                .clk(clk), .rst(rst),
                .x_in(x_bus[i]), .a_in(a_bus[i]),
                .x_out(x_bus[i+1])
            );
            reg signed [W-1:0] d1, d2, d3;
            always @(posedge clk) begin
                if (rst) 
                    {d1, d2, d3} <= 0;
                else     
                    {d3, d2, d1} <= {d2, d1, a_bus[i]};
            end
            assign a_bus[i+1] = d3;
        end
    endgenerate
    assign result = x_bus[N_ITERS];
endmodule