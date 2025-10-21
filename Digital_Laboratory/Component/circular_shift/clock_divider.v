module clk_divider (
    input sys_clk_in,
    input reset,
    output new_clk_out
);

// Clock divider module to generate a new clock signal with a specified frequency
parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter Hz = 28'd100_000000; // Target clock frequency
localparam timeCount = clk_freq / Hz; // Calculate the time count for the target frequency
parameter dutyCycle = timeCount / 2; // 50% duty cycle

reg [28:0] count; // 29-bit counter to hold the count value
reg freq; // Clock divider output

always @(posedge sys_clk_in or negedge reset) 
begin
        if(!reset) // Check for reset or if the counter has reached the maximum value
            count <= 28'd1; // Reset the counter to 0
        else if(count == timeCount && timeCount != dutyCycle)
            count <= 28'd1;
        else if(timeCount != dutyCycle)
            count <= count + 28'd1; // Increment the counter
        else if(timeCount == dutyCycle)
            count <= 28'd1;
end    

always @(posedge sys_clk_in or negedge reset)
begin
    
        if(!reset) // Check for reset
            freq <= 1'b0; // Set the frequency divider output to 0
        else if(count > dutyCycle && timeCount != dutyCycle) // Check if the counter has reached the duty cycle value
            freq <= 1'b0; // Toggle the frequency divider output
        else if(timeCount != dutyCycle) // Check if the counter is less than the duty cycle value
            freq <= 1'b1; // Keep the frSequency divider output high
        else if(timeCount == dutyCycle) // Check if the counter has reached the maximum value
            freq = ~freq;  // If the time count is equal to the duty cycle, set the frequency divider output to the clock input
end

assign new_clk_out = freq; // Assign the frequency divider output to the new clock output

endmodule