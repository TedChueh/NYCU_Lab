module bcd_adder(
    input sys_clk_in,
    input reset,
    input addbutton,
    input reset_reg,
    input switch_reg,
    input E,
    input F,
    input G,
    output reg [3:0] display_num,
    output [3:0] pin_control,
    output clk_out,
    output [7:0] display_out,
    output [7:0] seg_control
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter refresh_rate = 28'd60;  // 60Hz refresh rate
parameter single_key_refresh_rate = refresh_rate * 4; // 240Hz refresh rate for single key
reg [4:0] reg1_num; // 4-bit register for the first number
reg [4:0] reg2_num; // 4-bit register for the second number
reg [4:0] sum_num; // 4-bit register for the sum
wire [3:0] keypad_num; // 4-bit output for the pressed key
//reg [7:0] display_num; // 4-bit output for the display number
wire [4:0] result_num;
assign result_num = sum_num - 5'b01010; // Subtract 10 from the sum to check if it's greater than 9


keypad #(
    .clk_freq(clk_freq),
    .single_key_refresh_rate(single_key_refresh_rate)
) keypad1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .E(E),
    .F(F),
    .G(G),
    .num(keypad_num),
    .pin_control(pin_control)
    ,.clk_out(clk_out)
);

bcd_display_module bcd_display1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .binary_in({24'b1111_1111_1111_1111_1111_1111, display_num}), // 32-bit binary input
    .dp(8'b1111_1111), // No decimal point
    .display_out(display_out),
    .seg_control(seg_control)
);

always@(posedge sys_clk_in)
begin
    if (reset_reg) 
        begin
            reg1_num <= 4'b0000;
            reg2_num <= 4'b0000;
        end 
    else if(switch_reg == 1'b0 && addbutton == 1'b0 && keypad_num < 4'b1010)
        begin
            reg1_num <= keypad_num;
        end 
    else if(switch_reg == 1'b1 && addbutton == 1'b0 && keypad_num < 4'b1010) 
        begin
            reg2_num <= keypad_num;
        end
end

always@(posedge sys_clk_in)
begin
    if(switch_reg == 1'b0 && addbutton == 1'b1) 
        begin 
            sum_num <= reg1_num + reg2_num; // Add the two numbers
            if(sum_num > 5'd9) // Check if the sum is greater than 9
                begin
                    display_num <= {4'b0001, result_num[3:0]}; // Add 6 to the sum to convert to BCD
                end 
            else 
                begin
                    display_num <= {4'b1111, sum_num[3:0]}; // Display the sum
                end
        end
    else if(switch_reg == 1'b0 && addbutton == 1'b0)
        begin
            display_num <= {4'b1111, reg1_num[3:0]};
        end 
    else if(switch_reg == 1'b1) 
        begin
            display_num <= {4'b1111, reg2_num[3:0]};
        end
end
endmodule