module traffic_light(
    input sys_clk_in,
    input reset,
    output [7:0] R_PWM,
    output [7:0] G_PWM,
    output [7:0] B_PWM,
    output [3:0] count_down,
    output [1:0] traffic_light_status_out,
    output R,
    output G,
    output B,
    output [7:0] display_out,
    output [7:0] seg_control
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter periodHz = 28'd120; // Target clock frequency
parameter refreshHz = 28'd1;

reg [7:0] duty_percentage [2:0];
wire led_clk_out [2:0];
assign R = led_clk_out[0];
assign G = led_clk_out[1];
assign B = led_clk_out[2];

assign R_PWM = duty_percentage[0];
assign G_PWM = duty_percentage[1];
assign B_PWM = duty_percentage[2];

genvar led_index;
generate
    for(led_index = 0; led_index < 3; led_index = led_index + 1) 
    begin : led_pwm
        clk_divider_ver2#(
            .clk_freq(clk_freq),
            .Hz(periodHz)
        ) clk_div_ver2(
            .sys_clk_in(sys_clk_in),
            .reset(reset),
            .duty_percentage(duty_percentage[led_index]),
            .new_clk_out(led_clk_out[led_index])
        );
    end
endgenerate


reg [3:0] count;
reg [1:0] traffic_light_status;
reg [7:0] display_num;

assign count_down = count;
assign traffic_light_status_out = traffic_light_status;

wire new_clk_out;
clk_divider#(
    .clk_freq(clk_freq),
    .Hz(refreshHz)
)clk_ver1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out)
);

bcd_display_module bcd_display1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .binary_in({24'b1111_1111_1111_1111_1111_1111, display_num}), // 32-bit binary input
    .dp(8'b1111_1111), // No decimal point
    .display_out(display_out),
    .seg_control(seg_control)
);

always @(posedge new_clk_out or negedge reset)
begin
    if(!reset)
    begin
        count <= 4'd10;
        traffic_light_status <= 2'd0;
    end
    ////
    else if(traffic_light_status == 2'd0)
    begin
        if(count > 4'd1)
        begin
            count <= count - 4'd1;
        end
        else
        begin
            count <= 4'd5;
            traffic_light_status <= 2'd1;
        end
    end
    ////
    else if(traffic_light_status == 2'd1)
    begin
        if(count > 4'd1)
        begin
            count <= count - 4'd1;
        end
        else
        begin
            count <= 4'd10;
            traffic_light_status <= 2'd2;
        end
    end
    ////
    else if(traffic_light_status == 2'd2)
    begin
        if(count > 4'd1)
        begin
            count <= count - 4'd1;
        end
        else
        begin
            count <= 4'd10;
            traffic_light_status <= 2'd0;
        end
    end
end


always @(*)
begin
    if(count >= 10)
    begin
        display_num = {4'b0001, (count - 4'd10)};
    end
    else
    begin
        display_num = {4'b0000, count};
    end

    case (traffic_light_status)
        2'd0: 
        begin
            duty_percentage[0] = 8'd40;
            duty_percentage[1] = 8'd0;
            duty_percentage[2] = 8'd0;
        end
        2'd1:
        begin
            duty_percentage[0] = 8'd20;
            duty_percentage[1] = 8'd20;
            duty_percentage[2] = 8'd0;
        end
        2'd2:
        begin
            duty_percentage[0] = 8'd0;
            duty_percentage[1] = 8'd40;
            duty_percentage[2] = 8'd0;
        end
    endcase
end
endmodule