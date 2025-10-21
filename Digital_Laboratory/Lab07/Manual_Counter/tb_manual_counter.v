`timescale 1ns/1ns
module tb_manual_counter();
    reg sys_clk_in;
    reg reset;
    reg upbutton;
    reg downbutton;
    wire [3:0] num;
    wire upbuttonFlag;
    wire downbuttonFlag;

parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter debounce_freq = 28'd500_0000;  //5MHz debounce frequency

manual_counter #(
    .clk_freq(clk_freq),
    .debounce_freq(debounce_freq) 
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .upbutton(upbutton),
    .downbutton(downbutton),
    .num(num),
    .upbuttonFlag(upbuttonFlag),
    .downbuttonFlag(downbuttonFlag)
);

initial 
begin
        sys_clk_in = 1'b0; // Initialize the clock input to 0
        upbutton = 1'b0; // Initialize the clock input to 0
        downbutton = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  reset = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
    // simulate the button bounce
    #17 
        begin
        upbutton = 1'b1; // Set the upbutton to 1
        end
    #10
        begin
        upbutton = 1'b0; // Set the upbutton to 0
        end
    #15
        begin
        upbutton = 1'b1; // Set the upbutton to 1
        end
    #10
        begin
        upbutton = 1'b0; // Set the upbutton to 0
        end
   
    #45 
        begin
        downbutton = 1'b1; // Set the upbutton to 1
        end
    #10
        begin
        downbutton = 1'b0; // Set the upbutton to 0
        end
    #15
        begin
        downbutton = 1'b1; // Set the upbutton to 1
        end
    #10
        begin
        downbutton = 1'b0; // Set the upbutton to 0
        end
    
    //simulate normal counting 
    #25 
        begin
        upbutton = 1'b1; // Set the upbutton to 1
        end
    #10
        begin
        upbutton = 1'b0; // Set the upbutton to 0
        end
    #55
        begin
        upbutton = 1'b1; // Set the upbutton to 1   
        end
    #10
        begin
        upbutton = 1'b0; // Set the upbutton to 0
        end
    #50
        begin
        downbutton = 1'b1; // Set the downbutton to 1   
        end
    #10
        begin
        downbutton = 1'b0; // Set the downbutton to 0
        end
    #50
        begin
        downbutton = 1'b1; // Set the downbutton to 1   
        end
    #10
        begin
        downbutton = 1'b0; // Set the downbutton to 0
        end
       
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule