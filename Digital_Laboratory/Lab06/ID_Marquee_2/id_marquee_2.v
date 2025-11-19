module id_marquee_2(
    input sys_clk_in,
    input reset,
    input switch,
    output [63:0] binary_out,
    output [7:0] display_out,
    output [7:0] seg_control
);
parameter clk_freq = 28'd100_000000; 
parameter shift_freqHz = 2'd2;
parameter binary_in_length = 64;
//wire [63:0] binary_out; 

circulate_shift #(
    .clk_freq(clk_freq), 
    .shift_freqHz(shift_freqHz),
    .binary_in_length(binary_in_length) 
) circulate_shift1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .direction(switch), // 0 for left shift, 1 for right shift
    .shifting_bits(5'b0_0100),
    .binary_in(64'b0010_0000_0010_0010_1101_0001_1000_0101_0000_1111_1010_1100_1111_1011_1100_1111),
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