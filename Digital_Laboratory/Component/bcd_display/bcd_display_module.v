module bcd_display_module(
    input sys_clk_in,
    input reset,
    input [31:0] binary_in,
    input [7:0] dp,
    output [7:0] display_out,
    output [7:0] seg_control
);

wire [3:0] bcd_in [7:0];
wire [6:0] seg_out [7:0];
wire [7:0] display [7:0];

assign {bcd_in[0], bcd_in[1], bcd_in[2], bcd_in[3], bcd_in[4], bcd_in[5], bcd_in[6], bcd_in[7]} = binary_in;

genvar bcd_count;
generate
    for(bcd_count = 0; bcd_count < 8; bcd_count = bcd_count + 1) 
    begin : bcd_decoder
        bcd_decoder bcd_dec(
            .bcd_in(bcd_in[bcd_count]),
            .seg_out(seg_out[bcd_count])
        );
    end
endgenerate

genvar display_count;
generate
    for(display_count = 0; display_count < 8; display_count = display_count + 1) 
    begin : segments_info_compose
        assign display[display_count] = {seg_out[display_count], dp[7 - display_count]};
    end
endgenerate


bcd_display bcd_display1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .display0(display[0]),
    .display1(display[1]),
    .display2(display[2]),
    .display3(display[3]),
    .display4(display[4]),
    .display5(display[5]),
    .display6(display[6]),
    .display7(display[7]),
    .display_out(display_out),
    .seg_control(seg_control)
);

endmodule