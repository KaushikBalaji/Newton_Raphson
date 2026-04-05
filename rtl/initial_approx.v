`timescale 1ns/1ps

module initial_approx #(parameter N = 8, parameter W = 16) (
    input clk,
    input [W-1:0] a_in,
    // output [W-1:0] approx_out
    output reg [W-1:0] approx_out
);

    // integer j;
    // integer i;
    // integer shift;

    // wire [W-1:0] lod_out;

    // LOD #(W) lod_inst (
    //     .x_in(a_in),
    //     .x_out(lod_out)
    // );

    

    // always @(*) begin
    //     approx_out = 0;

    //     // extract index from one-hot
    //     j = 0;
    //     for (i = 0; i < W; i = i + 1) begin
    //         if (lod_out[i])
    //             j = i;
    //     end


    //     if (j[0]) begin
    //         // ODD
    //         if (j >= N) begin
    //             shift = (j - N + 1) >> 1;
    //             if ((N - shift) >= 0 && (N - shift) < W)
    //                 approx_out[N - shift] = 1'b1;
    //         end else begin
    //             shift = (N - j) >> 1;
    //             if ((N + shift) < W)
    //                 approx_out[N + shift] = 1'b1;
    //         end

    //     end 
    //     else begin
    //         // EVEN
    //         if (j >= N) begin
    //             shift = (j - N) >> 1;
    //             if ((N - (shift+1)) >= 0 && (N - (shift+1)) < W)
    //                 approx_out[N - (shift+1)] = 1'b1;

    //             if ((N - (shift+2)) >= 0 && (N - (shift+2)) < W)
    //                 approx_out[N - (shift+2)] = 1'b1;

    //         end else begin
    //             shift = (N - j) >> 1;
    //             if ((N + shift) < W)
    //                 approx_out[N + shift] = 1'b1;
    //         end
    //     end
    // end


    wire [W-1:0] lod_out;
    reg [W-1:0] approx_raw;
    integer i;

    LOD #(W) lod_inst (
        .x_in(a_in),
        .x_out(lod_out)
    );

    always @(*) begin
        approx_raw = 0;

        for (i = 0; i < W; i = i + 1) begin
            if (lod_out[i]) begin
                if (i % 2 == 1) begin
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
        approx_out <= approx_raw << 4;
    end
endmodule
