`timescale 1ns/1ns
module tb_sequence_detector();
    reg sys_clk_in;
    reg reset;
    reg data_in;
    wire data;
    wire [7:0] data_bus;
    wire new_clk_out;
    wire led;


parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter refreshHz = 28'd500_0000; // 5MHz refresh frequency

sequence_detector #(
    .clk_freq(clk_freq),
    .refreshHz(refreshHz)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .data_in(data_in),
    .data(data),
    .data_bus(data_bus),
    .new_clk_out(new_clk_out),
    .led(led)
);

initial 
begin
    // Initialize inputs
        sys_clk_in = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1;  // Initialize the reset signal to 1
    #1  reset = 1'b0;  // Deassert the reset signal
    #1  reset = 1'b1;  // Assert the reset signal again
    #1  data_in = 1'b0; // Initialize the data input to 0
    // random sequence
    #19  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b0; // Set the data input to 0
    #20  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b0; // Set the data input to 0
    #20  data_in = 1'b0; // Set the data input to 0
    #20  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b0; // Set the data input to 0

    //correct sequence
    #20  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b0; // Set the data input to 0
    #20  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b1; // Set the data input to 1

    #20  data_in = 1'b1; // Set the data input to 1
    #20  data_in = 1'b0; // Set the data input to 0
    #20  data_in = 1'b0; // Set the data input to 0
    #20  data_in = 1'b1; // Set the data input to 1



end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule