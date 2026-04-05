`timescale 1ns/1ps

module initial_approx #(parameter W = 16, parameter FRAC = 8) (
    input  [W-1:0] lod_in,
    output reg [W-1:0] approx_out
);

    integer j;
    integer target_idx;
    reg next_bit;
    reg found;

always @(*) begin
    approx_out = 0;
    found = 0;

    for (j = W-1; j >= 0; j = j - 1) begin
        if (lod_in[j] && !found) begin
            found = 1;

            if (j % 2 == 1) begin
                target_idx = FRAC - (j - FRAC + 1) / 2;
                if (target_idx >= 0 && target_idx < W)
                    approx_out[target_idx] = 1'b1;

            end else begin
                target_idx = FRAC - (j - FRAC) / 2;

                if (target_idx - 1 >= 0)
                    approx_out[target_idx - 1] = 1'b1;

                if (target_idx - 2 >= 0)
                    approx_out[target_idx - 2] = 1'b1;

                if (j > 0 && lod_in[j-1] && target_idx - 3 >= 0)
                    approx_out[target_idx - 3] = 1'b1;
            end
        end
    end
end
endmodule