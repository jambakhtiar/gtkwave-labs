`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 06:25:27 PM
// Design Name: 
// Module Name: gen_tick_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module gen_tick_tb;

// Parameters
localparam SRC_FREQ = 5000;
localparam TICK_FREQ = 2;
localparam integer TICK_COUNT = SRC_FREQ / TICK_FREQ;

// Inputs
reg src_clk;
reg enable;

// Outputs
wire tick;

// Instantiate the Unit Under Test (UUT)
gen_tick #(
    .SRC_FREQ(SRC_FREQ),
    .TICK_FREQ(TICK_FREQ)
) uut (
    .src_clk(src_clk),
    .enable(enable),
    .tick(tick)
);

// Clock generation
initial begin
    src_clk = 0;
    forever #(1000000000 / (2 * SRC_FREQ)) src_clk = ~src_clk;  // Clock period is 1/SRC_FREQ seconds, half period is 1/(2*SRC_FREQ) seconds
end

// Test stimulus
initial begin
    // Initialize Inputs
    enable = 0;

    // Wait for the global reset to finish
    #100;

    // Test Case 1: Enable the tick generation
    enable = 1;
    #((TICK_COUNT * 1000000000 / SRC_FREQ) * 3);  // Wait for a few tick periods

    // Test Case 2: Disable the tick generation
    enable = 0;
    #((TICK_COUNT * 1000000000 / SRC_FREQ) * 3);  // Wait for a few tick periods

    // Test Case 3: Re-enable the tick generation
    enable = 1;
    #((TICK_COUNT * 1000000000 / SRC_FREQ) * 3);  // Wait for a few tick periods

    // Finish simulation
   #100000000000000;
   
    #100000000000000 $finish;
end

// Monitor the outputs
initial begin
    $monitor("Time=%0t, enable=%b, tick=%b", $time, enable, tick);
end

endmodule

