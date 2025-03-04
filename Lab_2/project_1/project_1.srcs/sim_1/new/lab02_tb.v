//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: 
// Email: 
// 
// Assignment name: 
// Lab section: 
// TA: 
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module myalu_tb;
    parameter NUMBITS = 32;

    // Inputs
    reg clk;
    reg reset;
    reg [NUMBITS-1:0] A;
    reg [NUMBITS-1:0] B;
    reg [1:0] alu_op;
    reg [5:0] instr_5_0;
    
    
    // Outputs
    wire [NUMBITS-1:0] result;
    reg [NUMBITS-1:0] expected_result;
    wire [3:0] alu_contr;
    wire zero;


    // -------------------------------------------------------
    // Setup output file for possible debugging uses
    // -------------------------------------------------------
    initial
    begin
        $dumpfile("lab02.vcd");
        $dumpvars(0);
    end

    // -------------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // -------------------------------------------------------

    alu_control control(
        .alu_op(alu_op),
        .funct(instr_5_0),
        .alu_control(alu_contr)
    );

    alu uut (
        .alu_control(alu_contr),
        .A(A), 
        .B(B), 
        .result(result), 
        .zero(zero)
    );

    initial begin 
    
        clk = 0; reset = 1; #50; 
        clk = 1; reset = 1; #50; 
        clk = 0; reset = 0; #50; 
        clk = 1; reset = 0; #50; 
         
        forever begin 
            clk = ~clk; #50; 
        end 
    end 
    
    integer totalTests = 0;
    integer failedTests = 0;
    
    task test_case(
        input [1:0] alu_op_val, 
        input [5:0] instr_5_0_val,
        input [NUMBITS-1:0] A_val,
        input [NUMBITS-1:0] B_val,
        input expected_zero_val,
        input [NUMBITS-1:0] expected_result_val);
        begin
            totalTests = totalTests + 1;
            alu_op = alu_op_val;
            instr_5_0 = instr_5_0_val;
            A = A_val;
            B = B_val;
            expected_result = expected_result_val;

            #100; // Wait 
            if (expected_result !== result || zero !== expected_zero_val) begin
                $write("failed\n");
                failedTests = failedTests + 1;
            end else begin
                $write("passed\n");
            end
            #10; // Wait 
        end

    endtask

    initial begin // Test suite
        // Reset
        @(negedge reset); // Wait for reset to be released (from another initial block)
        @(posedge clk);   // Wait for first clock out of reset 
        #10; // Wait 10 cycles 

        // Additional test cases
        // ---------------------------------------------
        // Testing unsigned additions 
        // --------------------------------------------- 

        // Code necessary for each test case 
        $write("\tTest Case 1: And ... ");
        test_case(2, 6'h24, 32'h1111, 32'hffff, 1'b0, 32'h1111);


        // Copy the code above and change params to do tests from table        
        // Code necessary for each test case 
        $write("\tTest Case 2:  ... ");
        test_case(2, 6'h24, 32'h0000, 32'hffff, 1'b1, 32'h0000);
        
        $write("\tTest Case 3:  ... ");
        test_case(2, 6'h25, 32'h1111, 32'hffff, 1'b0, 32'hffff);
        
        $write("\tTest Case 4:  ... ");
        test_case(2, 6'h25, 32'h0000, 32'h0000, 1'b1, 32'h0000);
        
        $write("\tTest Case 5:  ... ");
        test_case(2, 6'h20, 32'h0001, 32'hffff, 1'b0, 32'h10000);

        $write("\tTest Case 6:  ... ");
        test_case(2, 6'h20, 32'h1111, 32'hffff, 1'b0, 32'h11110);
  
        $write("\tTest Case 7:  ... ");
        test_case(2, 6'h20, 32'h0001, 32'hffffffff, 1'b1, 32'h0000);
  
        //2 	0x20 	0x0001 	0xfffffffe 	0 	0xffffffff
        $write("\tTest Case 8:  ... ");
        test_case(2, 6'h20, 32'h0001, 32'hfffffffe, 1'b0, 32'hffffffff);
        
        //2 	0x22 	0x0001 	0xffffffff 	0 	0x0002
        $write("\tTest Case 9:  ... ");
        test_case(2, 6'h22, 32'h0001, 32'hffffffff, 1'b0, 32'h0002);
        
        //2 	0x22 	0xffffffff 	0x0001 	0 	0xfffffffe
        $write("\tTest Case 10:  ... ");
        test_case(2, 6'h22, 32'hffffffff, 32'h0001, 1'b0, 32'hfffffffe);
        
        //2 	0x22 	0xffffffff 	0xffffffff 	1 	0x0000
        $write("\tTest Case 11:  ... ");
        test_case(2, 6'h22, 32'hffffffff, 32'hffffffff, 1'b1, 32'h0000);
        
        //2 	0x22 	0x0001 	0x0001 	1 	0x0000
        $write("\tTest Case 12:  ... ");
        test_case(2, 6'h22, 32'h0001, 32'h0001, 1'b1, 32'h0000);
        
         //2 	0x2A 	0x0002 	0x0002 	1 	0x0000
        $write("\tTest Case 13:  ... ");
        test_case(2, 6'h2A, 32'h0002, 32'h0002, 1'b1, 32'h0000);
        
         //2 	0x2A 	0x0002 	0x0001 	1 	0x0000
        $write("\tTest Case 14:  ... ");
        test_case(2, 6'h2A, 32'h0002, 32'h0001, 1'b1, 32'h0000);
        
         //2 	0x2A 	0x0001 	0x0002 	0 	0x0001
        $write("\tTest Case 15:  ... ");
        test_case(2, 6'h2A, 32'h0001, 32'h0002, 1'b0, 32'h0001);
        
         //2 	0x2A 	0xffffffff 	0x0001 	0 	0x0001
        $write("\tTest Case 16:  ... ");
        test_case(2, 6'h2A, 32'h0001, 32'h0002, 1'b0, 32'h0001);
        
        //2 	0x2A 	0x0001 	0xffffffff 	1 	0x0000
        //2 	0x2A 	0x0001 	0xffffffff 	1 	0x0000
        $write("\tTest Case 17:  ... ");
        test_case(2, 6'h27, 32'h0001, 32'hffffffff, 1'b1, 32'h0000);
        
        //2 	0x27 	0x1111 	0xffff 	0 	0xffff0000
        $write("\tTest Case 18:  ... ");
        test_case(2, 6'h27, 32'h1111, 32'hffff, 1'b0, 32'hffff0000);
        
        //2 	0x27 	0x0000 	0x0000 	0 	0xffffffff
        $write("\tTest Case 19:  ... ");
        test_case(2, 6'h27, 32'h0000, 32'h0000, 1'b0, 32'hffffffff);
        
        //0 	0x27 	0x0001 	0xffff 	0 	0x10000
        $write("\tTest Case 20:  ... ");
        test_case(0, 6'h27, 32'h0001, 32'hffff, 1'b0, 32'h10000);
        
        //1 	0x2A 	0xffff 	0x0001 	0 	0xfffe
        $write("\tTest Case 21:  ... ");
        test_case(1, 6'h2A, 32'hffff, 32'h0001, 1'b0, 32'hfffe);
        
        //1 	0x24 	0x0001 	0x0001 	1 	0x0000
        $write("\tTest Case 22:  ... ");
        test_case(1, 6'h24, 32'h0001, 32'h0001, 1'b1, 32'h0000);
        // -------------------------------------------------------
        // End testing
        // -------------------------------------------------------
        $write("\n-------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests", totalTests-failedTests,totalTests);
        $write("\n-------------------------------------------------------\n");
        $finish;
    end
endmodule