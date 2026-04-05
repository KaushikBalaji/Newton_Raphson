`timescale 1ns/1ps

module LOD #(parameter N = 16)(
    input  [N-1:0] x_in,
    output [N-1:0] x_out
);

    wire [N-1:0] BR_x;
    wire [N-1:0] NOT_out;
    wire [N-1:0] adder_out;
    wire [N-1:0] AND_out;

    // step 1: bit reversal of x_in
    genvar i;
    generate
        for(i = 0; i < N; i = i+1) begin
            assign BR_x[N-i-1] = x_in[i];
        end
    endgenerate

    // step 2: NOT of BR_x
    assign NOT_out = ~BR_x;

    // step 3: 2's complement = NOT + 1
    assign adder_out = NOT_out + 1;

    // step 4: AND between BR_x and its 2's complement
    assign AND_out = BR_x & adder_out;

    // step 5: bit reverse AND_out to get LOD(x_in)
    generate
        for(i = 0; i < N; i = i+1) begin
            assign x_out[N-i-1] = AND_out[i];
        end
    endgenerate

endmodule