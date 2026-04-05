`timescale 1ns/1ps

module tb_InvSqrt;

    parameter N = 8;
    parameter W = 16;
    parameter N_ITERS = 3;
    // Total Latency: 1 (Approx) + (3 * N_ITERS) (Pipeline)
    localparam TOTAL_LATENCY = 1 + (N_ITERS * 3);
    localparam inputs_count = 33;
    reg clk, rst;
    reg [W-1:0] a_in;
    wire [W-1:0] result;

    reg [W-1:0] golden_mem [0:inputs_count - 1];
    integer out_ptr = 0;
    integer file, r, i;

    initial begin
        file = $fopen("NR_golden_values.txt", "r");
        for (i = 0; i < inputs_count; i = i + 1) begin
            r = $fscanf(file, "%d\n", golden_mem[i]);
        end
        $fclose(file);
    end

    reg [W-1:0] a_history [0:TOTAL_LATENCY + 2];

    initial clk = 0;
    always #5 clk = ~clk;

    // Instantiate the full integrated module
    top_InvSqrt #(N, W, N_ITERS) dut (
        .clk(clk), .rst(rst), .a_in(a_in), .result(result)
    );

    always @(posedge clk) begin
        a_history[0] <= a_in;
        for (integer j = 1; j <= TOTAL_LATENCY + 1; j = j + 1) begin
            a_history[j] <= a_history[j-1];
        end
    end

    initial begin
        // --- Initialization ---
        rst = 1; a_in = 0;
        repeat(10) @(posedge clk);
        rst = 0;
        @(posedge clk);

        // Boundary around 1.0 (Q8.8 transition)
        @(posedge clk); a_in <= 16'd254;
        @(posedge clk); a_in <= 16'd255;
        @(posedge clk); a_in <= 16'd256;
        @(posedge clk); a_in <= 16'd257;

        // Powers of 2
        @(posedge clk); a_in <= 16'd1;     
        @(posedge clk); a_in <= 16'd4;     
        @(posedge clk); a_in <= 16'd16;    
        @(posedge clk); a_in <= 16'd64;    
        @(posedge clk); a_in <= 16'd256;   
        @(posedge clk); a_in <= 16'd1024;  
        @(posedge clk); a_in <= 16'd4096;  
        @(posedge clk); a_in <= 16'd16384; 
        @(posedge clk); a_in <= 16'd32768; 

        // Perfect Squares (Easy verification)
        @(posedge clk); a_in <= 16'd576;   
        @(posedge clk); a_in <= 16'd2304;  
        @(posedge clk); a_in <= 16'd6400;  
        @(posedge clk); a_in <= 16'd16384; 
        @(posedge clk); a_in <= 16'd36864; 

        @(posedge clk); a_in <= 16'd511;   
        @(posedge clk); a_in <= 16'd512;   
        @(posedge clk); a_in <= 16'd513;   
        @(posedge clk); a_in <= 16'd2047;  
        @(posedge clk); a_in <= 16'd2048;  
        @(posedge clk); a_in <= 16'd2049;  

        @(posedge clk); a_in <= 16'hAAAA;  
        @(posedge clk); a_in <= 16'h5555;  
        @(posedge clk); a_in <= 16'd12345; 
        @(posedge clk); a_in <= 16'd54321; 
        @(posedge clk); a_in <= 16'd65535; 

        // Very Small Values
        @(posedge clk); a_in <= 16'd2;
        @(posedge clk); a_in <= 16'd3;
        @(posedge clk); a_in <= 16'd5;
        @(posedge clk); a_in <= 16'd7;

        // --- End of Stream ---
        @(posedge clk); a_in <= 0;
        
        // Wait for pipeline to empty (1 + 9 stages = 10 cycles total)
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
                        a_history[TOTAL_LATENCY-1], // This is a_history[9]
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