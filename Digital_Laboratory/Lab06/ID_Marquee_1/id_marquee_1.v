module id_marquee_1(
    input sys_clk_in,
    input reset,
    input switch,
    output [39:0] binary_out,
    output [7:0] display_out,
    output [7:0] seg_control
);
parameter clk_freq = 28'd100_000000; 
parameter shift_freqHz = 2'd2;
parameter binary_in_length = 40;
//wire [39:0] binary_out;

circulate_shift #(
    .clk_freq(clk_freq), 
    .shift_freqHz(shift_freqHz),
    .binary_in_length(binary_in_length) 
) circulate_shift1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .direction(switch), // 0 for left shift, 1 for right shift
    .shifting_bits(5'b0_0100),
    .binary_in(40'b0001_0001_0011_0101_0001_0001_0000_1000_0100_1111),
    .binary_out(binary_out),
    .clk_out(clk_out)
);

bcd_display_module bcd_display1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .binary_in(binary_out),
    .dp(8'b1111_1111),
    .display_out(display_out),
    .seg_control(seg_control)
);

endmodule