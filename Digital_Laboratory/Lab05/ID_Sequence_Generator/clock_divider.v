module clk_divider (
    input sys_clk_in,
    input reset,
    output new_clk_out
);

parameter  period = 28'd50_000000; // 50MHz clock input
parameter  duty = 28'd25_000000; // 50% duty cycle
reg [28:0] count; // 29-bit counter to hold the count value
reg freq; // Frequency divider output

always @(posedge sys_clk_in or negedge reset) 
begin
    if(!reset) // Check for reset or if the counter has reached the maximum value
        count <= 28'd1; // Reset the counter to 0
    else if(count == period)
        count <= 28'd1;
    else
        count <= count + 28'd1; // Increment the counter
end    

always @(posedge sys_clk_in or negedge reset)
begin
    if(!reset) // Check for reset
        freq <= 1'b0; // Set the frequency divider output to 0
    else if(count > duty) // Check if the counter has reached the duty cycle value
        freq <= 1'b0; // Toggle the frequency divider output
    else 
        freq <= 1'b1; // Keep the frequency divider output high
end

assign new_clk_out = freq; // Assign the frequency divider output to the new clock output

endmodule