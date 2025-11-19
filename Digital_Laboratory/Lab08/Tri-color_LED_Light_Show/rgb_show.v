module rgb_show(
    input sys_clk_in,
    input reset,
    output [7:0] R_PWM,
    output [7:0] G_PWM,
    output [7:0] B_PWM,
    output R,
    output G,
    output B
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter periodHz = 28'd120; // Target clock frequency
parameter refreshHz = 28'd10;

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


reg [2:0] rgb_flag [2:0];
wire new_clk_out;
clk_divider#(
    .clk_freq(clk_freq),
    .Hz(refreshHz)
)clk_ver1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out)
);

always @(posedge new_clk_out or negedge reset)
begin
    if(!reset)
    begin
        duty_percentage[0] <= 8'd40;
        duty_percentage[1] <= 8'd0;
        duty_percentage[2] <= 8'd0;
        rgb_flag [0] <= 2'd2;
        rgb_flag [1] <= 2'd0;
        rgb_flag [2] <= 2'd0;
    end
    ////
    else
    begin

        if(rgb_flag[0] == 2'd2)
        begin
            if(duty_percentage[0] > 8'd0)
            begin
                if(duty_percentage[0] == 8'd40)
                begin
                    rgb_flag[1] <= 2'd1;
                    duty_percentage[0] <= duty_percentage[0] - 8'd1;
                end
                else
                begin
                    duty_percentage[0] <= duty_percentage[0] - 8'd1;
                end
            end
            else
            begin
                rgb_flag[0] <= 2'd0;
            end
        end

        else if(rgb_flag[0] == 2'd1)
        begin
            if(duty_percentage[0] < 8'd40)
            begin
                duty_percentage[0] <= duty_percentage[0] + 8'd1;
            end
            else
                rgb_flag[0] <= 2'd2;
        end
        ////
        if(rgb_flag[1] == 2'd2)
        begin
            if(duty_percentage[1] > 8'd0)
            begin
                if(duty_percentage[1] == 8'd40)
                begin
                    rgb_flag[2] <= 2'd1;
                    duty_percentage[1] <= duty_percentage[1] - 8'd1;
                end
                else
                begin
                    duty_percentage[1] <= duty_percentage[1] - 8'd1;
                end
            end
            else
            begin
                rgb_flag[1] <= 2'd0;
            end
        end

        else if(rgb_flag[1] == 2'd1)
        begin
            if(duty_percentage[1] < 8'd40)
            begin
                duty_percentage[1] <= duty_percentage[1] + 8'd1;
            end
            else
                rgb_flag[1] <= 2'd2;
        end
        ////
        if(rgb_flag[2] == 2'd2)
        begin
            if(duty_percentage[2] > 8'd0)
            begin
                if(duty_percentage[2] == 8'd40)
                begin
                    rgb_flag[0] <= 2'd1;
                    duty_percentage[2] <= duty_percentage[2] - 8'd1;
                end
                else
                begin
                    duty_percentage[2] <= duty_percentage[2] - 8'd1;
                end
            end
            else
            begin
                rgb_flag[2] <= 2'd0;
            end
        end

        else if(rgb_flag[2] == 1'd1)
        begin
            if(duty_percentage[2] < 8'd40)
            begin
                duty_percentage[2] <= duty_percentage[2] + 8'd1;
            end
            else
                rgb_flag[2] <= 2'd2;
        end
    end
end
endmodule