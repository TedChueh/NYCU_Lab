`timescale 1ns/1ns
module tb_id_sequence_generator();
    reg sys_clk_in;
    reg reset;
    wire new_clk_out;
    wire CA;
    wire CB;
    wire CC;
    wire CD;
    wire CE;
    wire CF;
    wire CG;
    wire DP;
    wire AN;

parameter period = 28'd10; //r40 cycle
parameter duty = 28'd5; // 50% duty cycle

id_sequence_generator #(
    .period(period),
    .duty(duty)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out),
    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG),
    .DP(DP),
    .AN(AN)
);

initial 
begin
        sys_clk_in = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  reset = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule