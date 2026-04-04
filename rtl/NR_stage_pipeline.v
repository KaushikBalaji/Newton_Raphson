module NR_stage_pipeline #(parameter N = 8, parameter W = 16)(
    input  clk, rst,
    input [W-1:0] x_in,
    input [W-1:0] a_in,
    output [W-1:0] x_out
);
    // Stage 1: x^2 (Q8.8 * Q8.8 = Q16.16)
    reg [W-1:0] x_reg1, a_reg1, x_sq_reg1;
    wire [(2*W)-1:0] x_sq_full = x_in * x_in;

    always @(posedge clk) begin
        if (rst) begin
            x_reg1 <= 0; a_reg1 <= 0; x_sq_reg1 <= 0;
        end else begin
            x_reg1 <= x_in;
            a_reg1 <= a_in;
            x_sq_reg1 <= x_sq_full >>> N;
        end
    end

    // Stage 2: (3 - a*x^2)
    reg [W-1:0] x_reg2, term_reg2;
    wire [(2*W)-1:0] ax2_full = a_reg1 * x_sq_reg1;

    always @(posedge clk) begin
        if (rst) begin
            x_reg2 <= 0; term_reg2 <= 0;
        end else begin
            x_reg2 <= x_reg1;
            term_reg2 <= (3 << N) - (ax2_full >>> N);
        end
    end

    // Stage 3: (x * term) / 2
    reg [W-1:0] x_final_reg;
    wire [(2*W)-1:0] mult_full = x_reg2 * term_reg2;

    always @(posedge clk) begin
        if (rst) x_final_reg <= 0;
        else begin
            x_final_reg <= mult_full >>> (N + 1);
        end
    end

    assign x_out = x_final_reg;
endmodule