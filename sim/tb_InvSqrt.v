`timescale 1ns/1ps

module tb_InvSqrt;

    parameter N = 16;
    parameter W = 32;
    parameter N_ITERS = 4;
    // Total Latency: 1 (Approx) + (3 * N_ITERS) (Pipeline)
    localparam TOTAL_LATENCY = 1 + (N_ITERS * 3);
    localparam inputs_count = 33;
    reg clk, rst;
    reg [W-1:0] a_in;
    wire [W-1:0] result;
    reg [W-1:0] a_history [0:TOTAL_LATENCY + 1];

    reg [W-1:0] golden_mem [0:inputs_count - 1];
    reg [W-1:0] input_mem [0:inputs_count-1];
    integer out_ptr = 0;
    integer inp_file,golden_out_file, r, i;


    initial begin
        inp_file = $fopen("NR_inputs.txt", "r");
        for (i = 0; i < inputs_count; i = i + 1) begin
            r = $fscanf(inp_file, "%d\n", input_mem[i]);
        end
        $fclose(inp_file);

    end
    initial begin
        golden_out_file = $fopen("NR_golden_values.txt", "r");
        for (i = 0; i < inputs_count; i = i + 1) begin
            r = $fscanf(golden_out_file, "%d\n", golden_mem[i]);
        end
        $fclose(golden_out_file);
    end


    initial clk = 0;
    always #5 clk = ~clk;

    // Instantiate the full integrated module
    top_InvSqrt #(N, W, N_ITERS) dut (
        .clk(clk), .rst(rst), .a_in(a_in), .result(result)
    );
    
	integer j, k;
    always @(posedge clk) begin
        a_history[0] <= a_in;
        for (j = 1; j <= TOTAL_LATENCY + 1; j = j + 1) begin
            a_history[j] <= a_history[j-1];
        end
    end

    initial begin
        // --- Initialization ---
        rst = 1; a_in = 0;
        repeat(10) @(posedge clk);
        rst = 0;
        @(posedge clk);

        // --- Test Stream ---

        for (k = 0; k < inputs_count; k = k + 1) begin
            @(posedge clk); 
            a_in <= input_mem[k];
        end

        // --- End of Stream ---
        @(posedge clk); a_in <= 0;
        
        repeat (20) @(posedge clk);
        $display("Testbench complete.");
        $finish;
    end

initial begin
        out_ptr = 0;
        
        wait (rst == 0);
        
        repeat (TOTAL_LATENCY + 2) @(posedge clk);
        
        forever begin
            @(posedge clk);
            if (out_ptr < inputs_count) begin
                $display("Time: %t | Input A: %d | Result: %d | Golden: %d | Diff: %d", 
                        $time, 
                        a_history[TOTAL_LATENCY-1],
                        result, 
                        golden_mem[out_ptr], 
                        (result > golden_mem[out_ptr]) ? result - golden_mem[out_ptr] : golden_mem[out_ptr] - result
                );
                out_ptr = out_ptr + 1;
            end
        end
    end

    initial begin
        $dumpfile("top.vcd");
        $dumpvars(0, tb_InvSqrt);
    end
endmodule