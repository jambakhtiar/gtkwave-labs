

module gen_tick # ( parameter SRC_FREQ = 5000, parameter TICK_FREQ = 1) (
    input src_clk,
    input enable,
    output tick
);

// Declare registers and wires here

always @(posedge src_clk) begin
    // put your code for the multiplier here
end

// Change this assign statement to the actual tick value
assign tick = src_clk;

endmodule
