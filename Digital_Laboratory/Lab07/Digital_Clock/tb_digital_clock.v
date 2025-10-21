`timescale 1ns/1ns
module tb_digital_clock();
    reg sys_clk_in;
    reg reset;
    reg switch;
    reg freq_switch1;
    reg freq_switch2;
    reg pause_switch;
    reg direction_switch;
    wire [83:0] binary_out;
    wire [7:0] display_out;
    wire [7:0] seg_control;

parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter shift_freqHz = 28'd500_0000; // 5MHz shift frequency
parameter timer_freqHz = 28'd500_0000; // 1Hz timer frequency

digital_clock #(
    .clk_freq(clk_freq),
    .shift_freqHz(shift_freqHz),
    .timer_freqHz(timer_freqHz)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .switch(switch), // 0 for left shift, 1 for right shift
    .freq_switch1(freq_switch1), // 0 for slow, 1 for fast
    .freq_switch2(freq_switch2), // 0 for mid, 1 for super
    .pause_switch(pause_switch), // 0 for pause, 1 for run
    .direction_switch(direction_switch), // 0 for left, 1 for right
    .binary_out(binary_out),
    .display_out(display_out),
    .seg_control(seg_control)
);

initial 
begin
    begin
        sys_clk_in = 1'b0; // Initialize the clock input to 0
        switch = 1'b0; // Initialize the switch input to 0
        freq_switch1 = 1'b0; // Initialize the frequency1 switch input to 0
        freq_switch2 = 1'b0; // Initialize the frequency2 switch input to 0
        pause_switch = 1'b0; // Initialize the pause switch input to 0
        direction_switch = 1'b0; // Initialize the direction switch input to 0

    end
    #1  reset = 1'b1; 
    #1  reset = 1'b0; 
    #1  reset = 1'b1; 
    #22 direction_switch = 1'b1; // Change the direction switch to 1 (right shift)
    #60 direction_switch = 1'b0; // Change the direction switch back to 0 (left shift)
    #20 pause_switch = 1'b1; // Change the pause switch to 1 (pause)
    #60 pause_switch = 1'b0; // Change the pause switch back to 0 (run)
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule