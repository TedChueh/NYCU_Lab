module digital_clock(
    input sys_clk_in,
    input reset,
    input switch,
    input freq_switch1,
    input freq_switch2,
    input pause_switch,
    input direction_switch,
    output [83:0] binary_out,
    output [7:0] display_out,
    output [7:0] seg_control
);
parameter clk_freq = 28'd100_000000; 
parameter shift_freqHz = 2'd2;
parameter binary_in_length = 84;
parameter timer_freqHz = 28'd1; // 1Hz timer frequency

reg [3:0] year [3:0];
reg [3:0] month [1:0];
reg [3:0] day [1:0];
reg [3:0] hour [1:0];
reg [3:0] minute [1:0];
reg [3:0] second [1:0];
reg [83:0] binary_in;
reg clock_clk;

wire slow_clk_out;
wire mid_clk_out;
wire fast_clk_out;
wire super_clk_out;
//wire [32:0] binary_out; 

circulate_shift_ver2 #(
    .clk_freq(clk_freq), 
    .shift_freqHz(shift_freqHz),
    .binary_in_length(binary_in_length) 
) circulate_shift1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .pause(pause_switch),
    .direction(direction_switch), 
    .shifting_bits(5'b0_0100),
    .binary_in(binary_in),
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

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(timer_freqHz)
) clk_div_slow (
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(slow_clk_out)
);

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(timer_freqHz*60)
) clk_div_mid (
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(mid_clk_out)
);

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(timer_freqHz*60*60)
) clk_div_fast (
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(fast_clk_out)
);

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(timer_freqHz*60*60*24)
) clk_div_super (
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(super_clk_out)
);

always@(*)
begin
    if(!freq_switch1 && !freq_switch2)
        clock_clk <= slow_clk_out;
    else if(freq_switch1 && !freq_switch2)
        clock_clk <= mid_clk_out;
    else if(!freq_switch1 && freq_switch2)
        clock_clk <= fast_clk_out;
    else if(freq_switch1 && freq_switch2)
        clock_clk <= super_clk_out;
end

always@(posedge clock_clk or negedge reset)
begin
    if(!reset)
    begin    
        year[3] <= 4'd2;
        year[2] <= 4'd0;
        year[1] <= 4'd2;
        year[0] <= 4'd5;
        ////
        month[1] <= 4'd0;
        month[0] <= 4'd5;
        ////
        day[1] <= 4'd0;
        day[0] <= 4'd1;
        ////
        hour[1] <= 4'd0;
        hour[0] <= 4'd0;
        ////
        minute[1] <= 4'd0;
        minute[0] <= 4'd0;
        ////
        second[1] <= 4'd0;
        second[0] <= 4'd0;
        ////
        binary_in <= 4'd0;
    end
    
    else
    begin
        if(second[0] < 4'd9)//
            second[0] <= second[0] + 4'd1;
        else 
        begin
            second[0] <= 4'd0;
            if(second[1] < 4'd5)//
                second[1] <= second[1] + 4'd1;
            else
            begin
                second[1] <= 4'd0;
                if(minute[0] < 4'd9)//
                    minute[0] <= minute[0] + 4'd1;
                else
                begin
                    minute[0] <= 4'd0;
                    if(minute[1] < 4'd5)//
                        minute[1] <= minute[1] + 4'd1;
                    else
                    begin
                        minute[1] <= 4'd0;
                        if(!((hour[1] == 4'd2 && hour[0] == 4'd3) || hour[0] >= 4'd9))//
                            hour[0] <= hour[0] + 4'd1;
                        else
                        begin
                            hour[0] <= 4'd0;
                            if(!(hour[1] >= 4'd2))//
                                hour[1] <= hour[1] + 4'd1;
                            else
                            begin 
                                hour[1] <= 4'd0;
                                if(!((day[1] == 4'd3 && day[0] == 4'd1) || day[0] >= 4'd9))//
                                    day[0] <= day[0] + 4'd1;
                                else
                                begin
                                    day[0] <= 4'd1;
                                    if(!(day[1] >= 4'd3))//
                                        day[1] <= day[1] + 4'd1;
                                    else
                                        day[1] <= 4'd0;
                                end
                            end
                        end
                    end
                end
            end
        end

        binary_in <= {year[3],year[2],year[1],year[0],4'd10,
                      month[1],month[0],4'd10,
                      day[1],day[0],4'd10,
                      hour[1],hour[0],4'd10,
                      minute[1],minute[0],4'd10,
                      second[1],second[0],4'd10,
                      4'd15};
    end
end

always @(*)
begin

end
endmodule