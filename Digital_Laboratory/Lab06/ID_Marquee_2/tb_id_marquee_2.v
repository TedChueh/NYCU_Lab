`timescale 1ns/1ns
module tb_id_marquee_2();
    reg sys_clk_in;
    reg reset;
    reg switch; // Number of bits to shift
    wire [63:0] binary_out;
    wire [7:0] display_out;
    wire [7:0] seg_control;


parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter shift_freqHz = 28'd500_0000; // 5MHz shift frequency

id_marquee_2 #(
    .clk_freq(clk_freq),
    .shift_freqHz(shift_freqHz)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .switch(switch), // 0 for left shift, 1 for right shift
    .binary_out(binary_out),
    .display_out(display_out),
    .seg_control(seg_control)
);

initial 
begin
    begin
        sys_clk_in = 1'b0; // Initialize the clock input to 0
        switch = 1'b0; // Initialize the reset input to 0
    end
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  reset = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule