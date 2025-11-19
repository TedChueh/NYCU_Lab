`timescale 1ns/1ns
module tb_rgb_show();
    reg sys_clk_in;
    reg reset;
    wire [7:0] R_PWM;
    wire [7:0] G_PWM;
    wire [7:0] B_PWM;
    wire R;
    wire G;
    wire B;


parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter refreshHz = 28'd500_0000; // 5MHz refresh frequency

rgb_show #(
    .clk_freq(clk_freq),
    .refreshHz(refreshHz)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .R_PWM(R_PWM),
    .G_PWM(G_PWM),
    .B_PWM(B_PWM),
    .R(R),
    .G(G),
    .B(B)
);

initial 
begin
    // Initialize inputs
        sys_clk_in = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1;  // Initialize the reset signal to 1
    #1  reset = 1'b0;  // Deassert the reset signal
    #1  reset = 1'b1;  // Assert the reset signal again
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule