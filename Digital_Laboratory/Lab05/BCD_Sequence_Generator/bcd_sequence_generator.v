module bcd_sequence_generator(
    input sys_clk_in,
    input reset,
    output new_clk_out,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output AN
);

parameter period = 28'd50_000000; // 50MHz clock input
parameter  duty = 28'd25_000000; // 50% duty cycle
parameter maximum = 4'd9;
reg [3:0] count;
wire [6:0] seg_out;
wire clk_out;

clk_divider #(
    .period(period),
    .duty(duty) 
)clk_div(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out)
); 

assign clk_out = new_clk_out; // Assign the new clock output to a wire

bcd_decoder bcd_dec(
    .bcd_in(count),
    .seg_out(seg_out)
);

always @(posedge clk_out or negedge reset) 
begin
    if(!reset)
        count <= 4'd0; // Reset the count to 0
    else if(count == maximum) // Check if the count has reached the maximum value
        count <= 4'd0; // Reset the count to 0
    else
        count <= count + 4'd1; // Increment the count
end


assign {CA, CB, CC, CD, CE, CF, CG} = seg_out; // Assign the segment outputs to the corresponding pins


assign DP = ~new_clk_out; // Set the decimal point to off
assign AN = 1'b0; // Set the anode to on

endmodule