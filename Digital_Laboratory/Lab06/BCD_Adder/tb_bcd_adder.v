`timescale 1ns/1ns
module tb_bcd_adder();
    reg sys_clk_in;
    reg reset;
    //
    reg addbutton;
    reg reset_reg;
    reg switch_reg;
    //
    reg E; 
    reg F;
    reg G;
    //
    wire [3:0] display_num;
    //
    wire [3:0] pin_control;
    wire clk_out;  
    wire [7:0] display_out;
    wire [7:0] seg_control;

parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter single_key_refresh_rate = 28'd500_0000; // 5MHz shift frequency

bcd_adder #(
    .clk_freq(clk_freq),
    .single_key_refresh_rate(single_key_refresh_rate)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .addbutton(addbutton),
    .reset_reg(reset_reg),
    .switch_reg(switch_reg),
    .E(E),
    .F(F),
    .G(G),
    .display_num(display_num),
    .pin_control(pin_control),
    .clk_out(clk_out),
    .display_out(display_out),
    .seg_control(seg_control)
);

initial 
begin
        sys_clk_in = 1'b0; // Initialize the clock input to 0
        addbutton = 1'b0; // Initialize the addbutton to disabled
        reset_reg = 1'b0; // Initialize the reset_reg to disabled
        switch_reg = 1'b0; // Initialize the switch_reg to first register
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  reset = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  
        begin
        E = 1'b0; 
        F = 1'b0;
        G = 1'b0; 
        end
    
    //simulate 0 + 0 zero addition
    #71 
        begin
        E = 1'b0; 
        F = 1'b1; 
        G = 1'b0; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b1; // Change the switch_reg to second register
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b1;
        G = 1'b0; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b0; //  Change the switch_reg to first register
        end
    #10 
        begin
        addbutton = 1'b1; // Enable the addbutton
        end
    #10 
        begin
        addbutton = 1'b0; // Disable the addbutton
        end
    #20 
        begin
        reset_reg = 1'b1; // Reset the registers
        end
    #10 
        begin
        reset_reg = 1'b0; // Disable the reset_reg
        end
    //End of zero addition
    //Simulate 3 + 3 normal addition
    #30 
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b1; // Change the switch_reg to second register
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b0; //  Change the switch_reg to first register
        end
    #10 
        begin
        addbutton = 1'b1; // Enable the addbutton
        end
    #40 
        begin
        addbutton = 1'b0; // Disable the addbutton
        end
    #20 
        begin
        reset_reg = 1'b1; // Reset the registers
        end
    #10 
        begin
        reset_reg = 1'b0; // Disable the reset_reg
        end
    //End normal addition
    //Simulate 5 + 5 carry addition
    #80 
        begin
        E = 1'b0; 
        F = 1'b1; 
        G = 1'b0; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b1; // Change the switch_reg to second register
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b1; 
        G = 1'b0; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b0; //  Change the switch_reg to first register
        end
    #10 
        begin
        addbutton = 1'b1; // Enable the addbutton
        end
    #40 
        begin
        addbutton = 1'b0; // Disable the addbutton
        end
    #20 
        begin
        reset_reg = 1'b1; // Reset the registers
        end
    #10 
        begin
        reset_reg = 1'b0; // Disable the reset_reg
        end
    //End carry addition
    //Simulate 9+9 maximun addition
    #80 
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b1; // Change the switch_reg to second register
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #10 
        begin
        switch_reg = 1'b0; //  Change the switch_reg to first register
        end
    #10 
        begin
        addbutton = 1'b1; // Enable the addbutton
        end
    #40 
        begin
        addbutton = 1'b0; // Disable the addbutton
        end
    #20 
        begin
        reset_reg = 1'b1; // Reset the registers
        end
    #10 
        begin
        reset_reg = 1'b0; // Disable the reset_reg
        end
    //End maximun addition
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule