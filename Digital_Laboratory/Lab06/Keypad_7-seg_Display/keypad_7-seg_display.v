module keypad_7seg_display(
    input sys_clk_in,
    input reset,
    input E,
    input F,
    input G,
    output [3:0] num,
    output [3:0] pin_control,
    output clk_out,
    output [7:0] display_out,
    output [7:0] seg_control
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter refresh_rate = 28'd60;  // 60Hz refresh rate
parameter single_key_refresh_rate = refresh_rate * 4; // 240Hz refresh rate for single key
//wire [3:0] num; // 4-bit output for the pressed key
reg [7:0] dpControl; // Decimal point control signal

keypad #(
    .clk_freq(clk_freq),
    .single_key_refresh_rate(single_key_refresh_rate)
) keypad1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .E(E),
    .F(F),
    .G(G),
    .num(num),
    .pin_control(pin_control),
    .clk_out(clk_out)
);

bcd_display_module bcd_display1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .binary_in({28'b1111_1111_1111_1111_1111_1111_1111, num}), // 32-bit binary input
    .dp(dpControl), // No decimal point
    .display_out(display_out),
    .seg_control(seg_control)
);

always@(*)
begin
    if(num == 4'd10) 
        dpControl = 8'b1111_1110; // No decimal point for U
    else
        dpControl = 8'b1111_1111; // No decimal point for other digits
end
endmodule