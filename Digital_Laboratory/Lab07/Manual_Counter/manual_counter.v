module manual_counter(
    input sys_clk_in,
    input reset,
    input upbutton,
    input downbutton,
    output reg [3:0] num,
    output reg upbuttonFlag,
    output reg downbuttonFlag,
    output [7:0] display_out,
    output [7:0] seg_control
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter debounce_freq = 28'd60;  // 60Hz debounce frequency

//reg [3:0] num;
reg [7:0] display_num;
reg [2:0] debounce_count;
//reg upbuttonFlag;
//reg downbuttonFlag;

wire button_clk;

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(debounce_freq)
) clk1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(button_clk)
);

bcd_display_module bcd_display1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .binary_in({24'b1111_1111_1111_1111_1111_1111, display_num}), // 32-bit binary input
    .dp(8'b1111_1111), // No decimal point
    .display_out(display_out),
    .seg_control(seg_control)
);

always@(negedge reset or posedge button_clk )
begin
    if(!reset)
    begin
        num <= 4'd0;
        debounce_count <= 4'd0;
        upbuttonFlag <= 1'b0;
        downbuttonFlag <= 1'b0;
    end
    ////
    else if(upbutton == 1'b1 && upbuttonFlag == 1'b0 && downbuttonFlag == 1'b0)
    begin 
        upbuttonFlag <= 1'b1;
        if(num == 4'd15)
            num <= 4'd0;
        else
            num <= num + 4'd1;
    end
    ////
    else if(downbutton == 1'b1 && upbuttonFlag == 1'b0 && downbuttonFlag == 1'b0)
    begin
        downbuttonFlag <= 1'b1;
        if(num == 4'd0)
            num <= 4'd15;
        else
            num <= num - 4'd1;
    end
    ////
    else if(upbuttonFlag == 1'b1 || downbuttonFlag == 1'b1)
    begin
        if(debounce_count < 4'd2)
            debounce_count <= debounce_count + 4'd1;

        else if((debounce_count == 4'd2 || debounce_count > 4'd2) && !upbutton && !downbutton)
        begin    
            upbuttonFlag <= 1'b0;
            downbuttonFlag <= 1'b0;
        end
    end 
end

always@(*)
begin
    if(num < 4'd10)
        display_num <= {4'b1111, num};
    else
        display_num <= {4'b0001, num - 4'd10};
end
endmodule 