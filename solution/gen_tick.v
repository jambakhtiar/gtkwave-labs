`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 06:17:18 PM
// Design Name: 
// Module Name: gen_tick
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

module gen_tick #(
    parameter SRC_FREQ = 5000,   // Source clock frequency in Hz
    parameter TICK_FREQ = 1      // Output tick frequency in Hz
)(
    input src_clk,    // Source clock input
    input enable,     // Enable signal
    output tick       // Output tick signal
);

// Calculate the number of source clock cycles per tick
localparam integer TICK_COUNT = SRC_FREQ / TICK_FREQ;

// Declare registers and wires here
reg [31:0] counter = 0;
reg tick_reg = 0;

always @(posedge src_clk) begin
    if (!enable) begin
        counter <= 0;
        tick_reg <= 0;  // No tick if not enabled
    end else begin
        if (counter == TICK_COUNT - 1) begin
            counter <= 0;
            tick_reg <= ~tick_reg;  // Toggle the tick signal
        end else begin
            counter <= counter + 1;
        end
    end
end

// Assign the tick register to the output tick signal
assign tick = tick_reg;

endmodule
