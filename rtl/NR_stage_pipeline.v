`timescale 1ns/1ps

module NR_stage_pipeline #(
    parameter N = 16, 
    parameter FRAC = 8
)(
    input clk,
    input rst,
    input [N-1:0] a_in,      // Input 'a'
    input [N-1:0] x_in,      // Input 'xi'
    output reg [N-1:0] x_out // Output 'xi+1'
);

    // Internal signed signals
    wire signed [N-1:0] const3 = 3 <<< FRAC;
    
    // Stage 1 Registers: Compute x^2
    reg signed [N-1:0] x_s1, a_s1;
    reg signed [2*N-1:0] mul_x2;
    
    always @(posedge clk) begin
        x_s1   <= x_in;
        a_s1   <= a_in;
        mul_x2 <= $signed(x_in) * $signed(x_in);
    end

    // Stage 2 Registers: Compute a * x^2
    reg signed [N-1:0] x_s2, t_x2;
    reg signed [2*N-1:0] mul_ax2;
    
    always @(posedge clk) begin
        x_s2    <= x_s1;
        t_x2    <= mul_x2[FRAC +: N]; // Truncate to N bits
        mul_ax2 <= $signed(a_s1) * $signed(mul_x2[FRAC +: N]);
    end

    // Stage 3 Registers: Compute (3 - ax^2)
    reg signed [N-1:0] x_s3, t_3_ax2;
    
    always @(posedge clk) begin
        x_s3      <= x_s2;
        t_3_ax2   <= const3 - mul_ax2[FRAC +: N];
    end

    // Stage 4 Registers: Compute x * (3 - ax^2)
    reg signed [2*N-1:0] mul_final;
    
    always @(posedge clk) begin
        mul_final <= $signed(x_s3) * $signed(t_3_ax2);
    end

    // Stage 5: Final Result (x/2) * (3 - ax^2)
    always @(posedge clk) begin
        // (mul_final >> FRAC) is the multiplication result
        // The additional >> 1 performs the division by 2
        x_out <= mul_final[FRAC+1 +: N]; 
    end

endmodule