`timescale 1ns/1ps

module initial_approx #(parameter N = 8, parameter W = 16) (
    input  [W-1:0] lod_in,
    output reg [W-1:0] approx_out
);

    integer j;
    integer target_idx;
    integer shift;
    reg next_bit;
    reg found;

    always @(*) begin
        approx_out = 0;
        found = 0;

        for (j = W-1; j >= 0; j = j - 1) begin
            if (lod_in[j] && !found) begin
                found = 1;

                if (j[0]) begin
                    // leading one in odd position

                    if (j >= N) begin
                        shift = (j - N + 1) >> 1;
                        if ((N - shift) >= 0 && (N - shift) < W)
                            approx_out[N - shift] = 1'b1;
                    end 
                    else begin
                        shift = (N - j) >> 1;
                        if ((N + shift) < W)
                            approx_out[N + shift] = 1'b1;
                    end

                end 
                
                else begin
                    // leading one in even position

                    if (j >= N) begin
                        shift = (j - N) >> 1;

                        if ((N - (shift+1)) >= 0 && (N - (shift+1)) < W)
                            approx_out[N - (shift+1)] = 1'b1;

                        if ((N - (shift+2)) >= 0 && (N - (shift+2)) < W)
                            approx_out[N - (shift+2)] = 1'b1;

                    end else begin
                        shift = (N - j) >> 1;

                        if ((N + shift) < W)
                            approx_out[N + shift] = 1'b1;
                    end
                end
            end
        end
    end
endmodule
