module keypad (
    input sys_clk_in,
    input reset,
    input E,
    input F,
    input G,
    output reg [3:0] num,
    output [3:0] pin_control,
    output clk_out
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter refresh_rate = 28'd60;  // 60Hz refresh rate
parameter single_key_refresh_rate = refresh_rate * 4; // 240Hz refresh rate for single key
reg [2:0] EFGsignal; // Signal to indicate which key is pressed (E, F, or G)
reg [3:0] last_pressed_column; // Register to store the last pressed column
reg pressed; // Flag to indicate if a key is pressed

circulate_shift #(
    .clk_freq(clk_freq),
    .shift_freqHz(single_key_refresh_rate),
    .binary_in_length(4)
)shift1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .direction(1'b1), // Right shift
    .shifting_bits(5'b0_0001), // Shift by 1 bit
    .binary_in(4'b0001), // Initial binary number
    .binary_out(pin_control), // Output binary number
    .clk_out(clk_out) // Output clock signal
);

always @(negedge clk_out or negedge reset) 
begin
    if(!reset)
        begin
            EFGsignal<= 3'd0; // Reset the signal to 0
        end
    ////
    else if(pressed == 1'b0) // If a key isn't pressed
        begin
            if(E)
                begin
                    EFGsignal= 3'd1; // E pressed
                end
            else if(F)
                begin
                    EFGsignal= 3'd2; // F pressed
                end
            else if(G)
                begin
                    EFGsignal= 3'd3; // G pressed
                end
            else 
                begin
                    EFGsignal= 3'd0; // No key pressed
                end
        end
    else 
        EFGsignal= 3'd0; // No key pressed
end
////
always@(posedge clk_out or negedge reset)
begin
    if(!reset)
        begin
            num <= 4'd15; // reset the num to 15 (no key pressed)
            last_pressed_column <= 4'b1111; // Reset the last pressed column
            pressed <= 1'b0; // Reset the pressed flag
        end
    ////
    else if (pressed == 1'b0) // If no key is pressed
        begin
            case(pin_control)
                4'b1000: 
                    begin 
                        last_pressed_column <= 4'b0001; // Column 0 pressed
                        pressed <= 1'b1; //set the pressed flag
                        if (EFGsignal == 3'd1) // If E is pressed
                            begin
                                num <= 4'd1;
                            end
                        ////
                        else if (EFGsignal == 3'd2) // If F is pressed
                            begin
                                num <= 4'd2;
                            end
                        ////
                        else if (EFGsignal == 3'd3) // If G is pressed
                            begin
                                num <= 4'd3;
                            end
                        else // If no key is pressed
                            begin
                                num <= 4'd15; // No key pressed
                                last_pressed_column <= 4'b1111; // Reset the last pressed column
                                pressed <= 1'b0; // Reset the pressed flag
                            end
                    end
                4'b0100: 
                    begin
                        last_pressed_column <= 4'b1000; // Column 1 pressed
                        pressed <= 1'b1;  // Reset the pressed flag
                        if (EFGsignal == 3'd1)  // If E is pressed
                            begin
                                num <= 4'd4;
                            end
                        ////
                        else if (EFGsignal == 3'd2) // If F is pressed
                            begin
                                num <= 4'd5;
                            end
                        ////
                        else if (EFGsignal == 3'd3) // If G is pressed
                            begin
                                num <= 4'd6;
                            end
                        else // If no key is pressed
                            begin
                                num <= 4'd15; // No key pressed
                                last_pressed_column <= 4'b1111; // Reset the last pressed column
                                pressed <= 1'b0; // Reset the pressed flag
                            end
                    end
                4'b0010:
                    begin
                        last_pressed_column <= 4'b0100; // Column 2 pressed
                        pressed <= 1'b1; // Reset the pressed flag
                        if (EFGsignal== 3'd1) // If E is pressed
                            begin
                                num <= 4'd7;
                            end
                        ////
                        else if (EFGsignal== 3'd2) // If F is pressed
                            begin
                                num <= 4'd8;
                            end
                        ////
                        else if (EFGsignal== 3'd3) // If G is pressed
                            begin
                                num <= 4'd9;
                            end
                        else // If no key is pressed
                            begin
                                num <= 4'd15; // No key pressed
                                last_pressed_column <= 4'b1111; // Reset the last pressed column
                                pressed <= 1'b0; // Reset the pressed flag
                            end
                    end
                4'b0001: 
                    begin
                        last_pressed_column <= 4'b0010; // Column 3 pressed
                        pressed <= 1'b1; // Reset the pressed flag
                        if (EFGsignal== 3'd1) // If E is pressed
                            begin
                                num <= 4'd10;
                            end
                        ////
                        else if (EFGsignal== 3'd2) // If F is pressed
                            begin
                                num <= 4'd0;
                            end
                        ////
                        else if (EFGsignal== 3'd3) // If G is pressed
                            begin
                                num <= 4'd11;
                            end
                        else // If no key is pressed
                            begin
                                num <= 4'd15; // No key pressed
                                last_pressed_column <= 4'b1111; // Reset the last pressed column
                                pressed <= 1'b0; // Reset the pressed flag
                            end
                    end
                default: 
                    begin
                        num <= 4'd15; // No key pressed
                        pressed <= 1'b0; // Reset the pressed flag
                    end
            endcase
        end
    ////
    else if (pressed == 1'b1) // If a key is already pressed
        begin
            if(pin_control == last_pressed_column ) // If the same column is pressed and no key is pressed
               begin
                   last_pressed_column <= 4'b1111; // Reset the last pressed column
                   pressed <= 1'b0; // Reset the pressed flag
               end
        end
end
endmodule