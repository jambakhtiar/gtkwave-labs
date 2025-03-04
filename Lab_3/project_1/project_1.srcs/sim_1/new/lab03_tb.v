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

module datapath_tb;
    // Inputs
    reg clk; 
    reg [31:0] instruction;
    reg [31:0] A;
    reg [31:0] B;

    wire reg_dst;
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] alu_op;
    wire mem_write;
    wire alu_src;
    wire reg_write;

    wire zero;
    wire [31:0] result;
    wire [3:0] alu_ctrl;

    // -------------------------------------------------------
    // Setup output file for possible debugging uses
    // -------------------------------------------------------
    initial
    begin
        $dumpfile("lab03.vcd");
        $dumpvars(0);
    end
    
    // ---------------------------------------------------
    // Instantiate the Units Under Test (UUT)
    // --------------------------------------------------- 
    
    control control_uut (
        .instr_op(instruction[31:26]),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    alu_control alu_control_uut (
        .alu_op(alu_op),
        .funct(instruction[5:0]),
        .alu_control(alu_ctrl)
    );

    alu alu_uut (
        .alu_control(alu_ctrl),
        .A(A),
        .B(B),
        .zero(zero),
        .result(result)
    );

    initial begin 
        clk = 0; #50
        clk = 1; #50
        clk = 0; #50
        clk = 1; #50
        
        forever begin 
            clk = ~clk; #50; 
        end 
    end

    task test_case(
        input [31:0] instruction_val,
        input [31:0] A_val,
        input [31:0] B_val,
        input        zero_val,
        input [31:0] result_val,
        input        reg_dst_val,
        input        branch_val,
        input        mem_read_val,
        input        mem_to_reg_val,
        input [1:0]  alu_op_val,
        input        mem_write_val,
        input        alu_src_val,
        input        reg_write_val);
        begin
            totalTests = totalTests + 1;
            instruction = instruction_val;
            A = A_val;
            B = B_val;

            #100; // Wait 
            if (result_val     !== result       || 
                zero_val       !== zero         || 
                reg_dst_val    !== reg_dst      || 
                branch_val     !== branch       || 
                mem_read_val   !== mem_read     || 
                mem_to_reg_val !== mem_to_reg   || 
                alu_op_val     !== alu_op       || 
                mem_write_val  !== mem_write    || 
                alu_src_val    !== alu_src      || 
                reg_write_val  !== reg_write) 
            begin
                $write("\nfailed - expected: zero = %b, result = %h, reg_dst = %b, branch = %b, mem_read = %b, mem_to_reg = %b, alu_op = %b, mem_write = %b, alu_src = %b, reg_write = %b", 
                       zero_val, result_val, reg_dst_val, branch_val, mem_read_val, mem_to_reg_val, alu_op_val, mem_write_val, alu_src_val, reg_write_val);
                $write("\n       - actual  : zero = %b, result = %h, reg_dst = %b, branch = %b, mem_read = %b, mem_to_reg = %b, alu_op = %b, mem_write = %b, alu_src = %b, reg_write = %b\n", 
                       zero, result, reg_dst, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
                failedTests = failedTests + 1;
            end else begin
                $write("passed\n");
            end
            #10; // Wait 
        end
    endtask


    integer failedTests = 0;
    integer totalTests = 0;
    initial begin
        // Reset
        @(posedge clk); // Wait for first clock out of reset 
        #10; // Wait 

        // -------------------------------------------------------
        // More Control Unit tests jere
        // -------------------------------------------------------

        // -------------------------------------------------------
        // Test group 2: ALU Control Unit
        // -------------------------------------------------------
        
        //0x00000024 	0xFFFFFFFF 	0x0001 	0 	0x0001 	1 	0 	0 	0 	10 	0 	0 	1
        $write("\tTest Case 1: R-type (add) ...");
        test_case(32'h00000024, 32'hFFFFFFFF, 32'h0001, 1'b0, 32'h0001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // -------------------------------------------------------
        // More ALU Control Unit tests jere
        // -------------------------------------------------------
        
        //0x00000025 	0xFFFFFFFF 	0x0001 	0 	0xFFFFFFFF 	1 	0 	0 	0 	10 	0 	0 	1
        $write("\tTest Case 2 ...");
        test_case(32'h00000025, 32'hFFFFFFFF, 32'h0001, 1'b0, 32'hFFFFFFFF, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);
        
        //0x00000020 	0xFFFFFFFF 	0x0001 	1 	0x0000 	1 	0 	0 	0 	10 	0 	0 	1
        $write("\tTest Case 3....");
        test_case(32'h00000020, 32'hFFFFFFFF, 32'h0001, 1'b1, 32'h0000, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);
        
        //0x00000022 	0xFFFFFFFF 	0x0001 	0 	0xFFFFFFFE 	1 	0 	0 	0 	10 	0 	0 	1
        $write("\tTest Case 4....");
        test_case(32'h00000022, 32'hFFFFFFFF, 32'h0001, 1'b0, 32'hFFFFFFFE, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);
        
        //0x0000002A 	0xFFFFFFFF .	0x0001 	0 	0x0001 	1 	0 	0 	0 	10 	0 	0 	1
        $write("\tTest Case 5....");
        test_case(32'h0000002A, 32'h00000000, 32'h0001, 1'b0, 32'h0001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);
        
        //0x00000027 	0xFFFFFFFF 	0x0001 	1 	0x0000 	1 	0 	0 	0 	10 	0 	0 	1
        $write("\tTest Case 6....");
        test_case(32'h00000027, 32'hFFFFFFFF, 32'h0001, 1'b1, 32'h0000, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);
        
        //0x20000004 	0xfffffffb 	0x0004 	0 	0xffffffff 	? 	? 	? 	? 	?? 	? 	? 	?
        $write("\tTest Case 7....");
        test_case(32'h20000004, 32'hfffffffb, 32'h0004, 1'b0, 32'hffffffff, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1);
        
        //0x8C000020 	0x000000FF 	0x0020 	0 	0x011F 	0 	0 	1 	1 	00 	0 	1 	1
        $write("\tTest Case 8....");
        test_case(32'h8C000020, 32'h000000FF, 32'h0020, 1'b0, 32'h011F, 1'b0, 1'b0, 1'b1, 1'b1, 2'b00, 1'b0, 1'b1, 1'b1);
        
        //0xAC000064 	0x000000FF 	0x0064 	0 	0x0163 	0 	0 	0 	0 	00 	1 	1 	0
        $write("\tTest Case 9 ....");
        test_case(32'hAC000064, 32'h000000FF, 32'h0064, 1'b0, 32'h0163, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0);
        
        //0x10000025 	0x000000FF 	0x0025 	0 	0x00DA 	0 	1 	0 	0 	01 	0 	0 	0
        $write("\tTest Case 10 ....");
        test_case(32'h10000025, 32'h000000FF, 32'h0025, 1'b0, 32'h00DA, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 1'b0, 1'b0, 1'b0);
        // --------------------------------------------------------------
        // End testing
        // --------------------------------------------------------------
        $write("\n--------------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests",totalTests-failedTests,totalTests);
        $write("\n--------------------------------------------------------------\n");
        $finish();
    end
endmodule
