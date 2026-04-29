`timescale 1ns/1ps

module initial_approx #(parameter N = 8, parameter W = 16) (
    input clk,
    input [W-1:0] a_in,
    // output [W-1:0] approx_out
    output reg [W-1:0] approx_out
);

    wire [W-1:0] lod_out;
    wire [$clog2(W)-1:0] lod_index;
    reg [W-1:0] approx_raw;
    integer i;

    LOD #(W) lod_inst (
        .x_in(a_in),
        .x_out(lod_out),
        .index_out(lod_index)
    );

    always @(*) begin
        approx_raw = 0;

        for (i = 0; i < W; i = i + 1) begin
            if (lod_out[i]) begin
                if (i & 1) begin
                    // ODD j
                    approx_raw[N - ((i+1)>>1)] = 1'b1;
                end else begin
                    // EVEN j
                    approx_raw[N - (i>>1) - 1] = 1'b1;
                    approx_raw[N - (i>>1) - 2] = 1'b1;
                end
            end
        end
    end

    always @(posedge clk) begin
        approx_out <= approx_raw << (N >> 1);
    end
endmodule
