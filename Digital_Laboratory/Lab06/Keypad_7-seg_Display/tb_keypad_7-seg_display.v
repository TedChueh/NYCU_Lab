`timescale 1ns/1ns
module tb_keypad_7seg_display();
    reg sys_clk_in;
    reg reset;
    reg E; 
    reg F;
    reg G;
    wire [3:0] num;
    wire [3:0] pin_control;
    wire clk_out;  
    wire [7:0] display_out;
    wire [7:0] seg_control;

parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter single_key_refresh_rate = 28'd500_0000; // 5MHz shift frequency

keypad_7seg_display #(
    .clk_freq(clk_freq),
    .single_key_refresh_rate(single_key_refresh_rate)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .E(E),
    .F(F),
    .G(G),
    .num(num),
    .pin_control(pin_control),
    .clk_out(clk_out),
    .display_out(display_out),
    .seg_control(seg_control)
);

initial 
begin
        sys_clk_in = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  reset = 1'b0; // Initialize the clock input to 0
    #1  reset = 1'b1; // Initialize the clock input to 0
    #1  
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    //simulate key presses in long intervals
    #11 
        begin
        E = 1'b1; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    
    #10
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #60
        begin
        E = 1'b1; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #20
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #60
        begin
        E = 1'b1; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #20
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    //end of long interval key press simulation

    //press another key in short intervals
    #120 
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b1; // Initialize the clock input to 0
        end
    #20
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    //end of short interval key press simulation

    // simulate press multiple keys in same row in short intervals
    #100 
        begin
        E = 1'b1; // Initialize the clock input to 0
        F = 1'b1; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #20
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    // end of short interval key press simulation
    // simulate press multiple keys in same column in short intervals
    #80 
        begin
        E = 1'b1; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #20
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #40 
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b1; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    #20
        begin
        E = 1'b0; // Initialize the clock input to 0
        F = 1'b0; // Initialize the clock input to 0
        G = 1'b0; // Initialize the clock input to 0
        end
    
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule