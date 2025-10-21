`timescale 1ns/1ns
module tb_sound_keypad();
    reg sys_clk_in;
    reg reset;
    reg E; 
    reg F;
    reg G;
    wire [3:0] pin_control;
    wire [3:0] num;

parameter clk_freq = 28'd1000_0000; // 10MHz clock input
parameter single_key_refresh_rate = 28'd500_0000; // 5MHz shift frequency

sound_keyboard #(
    .clk_freq(clk_freq),
    .single_key_refresh_rate(single_key_refresh_rate)
) UUT1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .E(E),
    .F(F),
    .G(G),
    .pin_control(pin_control),
    .num(num)
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
    #11 
        begin
        E = 1'b1; 
        F = 1'b0; 
        G = 1'b0; 
        end
    
    #10
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b1; 
        G = 1'b0; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end


    #80
        begin
        E = 1'b1; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b1; 
        G = 1'b0; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    
    #80
        begin
        E = 1'b1; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #60    
        begin
        E = 1'b0; 
        F = 1'b1; 
        G = 1'b0; 
        end
    #20 
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    #60
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b1; 
        end
    #20
        begin
        E = 1'b0; 
        F = 1'b0; 
        G = 1'b0; 
        end
    
end

always
begin
    #5 sys_clk_in = ~sys_clk_in; // Toggle the clock input every 5 time units
end

endmodule