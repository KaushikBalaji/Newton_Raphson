`timescale 1ns/1ps

module inv_sqr_root #(parameter N = 8, parameter W = 2*N)(
    input clk,
    input rst,
    input  signed [W-1:0] x0,
    input  signed [W-1:0] a,
    output signed [W-1:0] result
);

    localparam ITER = 4;

    // pipeline registers
    reg signed [W-1:0] x_pipe [0:ITER];

    // combinational outputs
    wire signed [W-1:0] x_next [0:ITER-1];

    // Stage 0 input
    always @(posedge clk) begin
        if(rst)
            x_pipe[0] <= 0;
        else
            x_pipe[0] <= x0;
    end

    // NR stages (combinational)
    genvar i;
    generate
        for (i = 0; i < ITER; i = i + 1) begin : NR

            NR_stage #(N, W) stage (
                .x_in(x_pipe[i]),
                .a(a),
                .x_out(x_next[i])
            );

            // pipeline register AFTER stage
            always @(posedge clk) begin
                if(rst)
                    x_pipe[i+1] <= 0;
                else
                    x_pipe[i+1] <= x_next[i];
            end

        end
    endgenerate

    assign result = x_pipe[ITER];

endmodule