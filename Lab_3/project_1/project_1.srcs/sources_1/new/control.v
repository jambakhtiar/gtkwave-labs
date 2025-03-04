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

// --------------------------------------
// Opcodes 
// --------------------------------------

`define OPCODE_R_TYPE       6'b000000
`define OPCODE_LOAD_WORD    6'b100011
`define OPCODE_STORE_WORD   6'b101011
`define OPCODE_BRANCH_EQ    6'b000100
`define OPCODE_ADDI         6'b001000

module control  (
    input  wire [5:0] instr_op, 
    output reg       reg_dst,   
    output reg       branch,     
    output reg       mem_read,  
    output reg       mem_to_reg,
    output reg [1:0] alu_op,        
    output reg       mem_write, 
    output reg       alu_src,    
    output reg       reg_write
    );

// ------------------------------
// Insert your solution below
// ------------------------------ 
always @(instr_op)
begin 
   // Put your solution here
   case(instr_op)
        `OPCODE_R_TYPE: begin 
                        reg_dst     = 1'b1 ;   
                        alu_src     = 1'b0;
                        mem_to_reg  = 1'b0;
                        reg_write   = 1'b1;
                        mem_read    = 1'b0;
                        mem_write   = 1'b0;
                        branch      = 1'b0;                                                     
                        alu_op      = 2'b10;                                      
                end
        
        `OPCODE_LOAD_WORD: begin
                        reg_dst     = 1'b0 ;   
                        alu_src     = 1'b1;
                        mem_to_reg  = 1'b1;
                        reg_write   = 1'b1;
                        mem_read    = 1'b1;
                        mem_write   = 1'b0;
                        branch      = 1'b0;                                                     
                        alu_op      = 2'b00;                                              
                end
        
        `OPCODE_STORE_WORD: begin
                        reg_dst     = 1'b0 ;   
                        alu_src     = 1'b1;
                        mem_to_reg  = 1'b0;
                        reg_write   = 1'b0;
                        mem_read    = 1'b0;
                        mem_write   = 1'b1;
                        branch      = 1'b0;                                                     
                        alu_op      = 2'b00;                                              
                end

        `OPCODE_BRANCH_EQ: begin
                        reg_dst     = 1'b0 ;   
                        alu_src     = 1'b0;
                        mem_to_reg  = 1'b0;
                        reg_write   = 1'b0;
                        mem_read    = 1'b0;
                        mem_write   = 1'b0;
                        branch      = 1'b1;                                                     
                        alu_op      = 2'b01;                                              
                end
         `OPCODE_ADDI: begin
                        reg_dst     = 1'b0;   
                        alu_src     = 1'b1;
                        mem_to_reg  = 1'b0;
                        reg_write   = 1'b1;
                        mem_read    = 1'b0;
                        mem_write   = 1'b0;
                        branch      = 1'b0;                                                     
                        alu_op      = 2'b00;                                              
                    end
                    
           default:
                    begin
                        reg_dst     = 1'bx;   
                        alu_src     = 1'bx;
                        mem_to_reg  = 1'bx;
                        reg_write   = 1'bx;
                        mem_read    = 1'bx;
                        mem_write   = 1'bx;
                        branch      = 1'bx;                                                     
                        alu_op      = 2'bxx;                                              
                    end 
                
                                                     
   endcase
   
end 
endmodule