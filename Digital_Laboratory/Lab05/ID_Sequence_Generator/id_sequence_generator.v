module id_sequence_generator(
    input sys_clk_in,
    input reset,
    output new_clk_out,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output AN
);

parameter period = 28'd50_000000; // 50MHz clock input
parameter  duty = 28'd25_000000; // 50% duty cycle
parameter maximum = 4'd15;
reg [3:0] count;
reg [3:0] num; // 4-bit number to be displayed on the 7-segment display
wire [6:0] seg_out;
wire clk_out;

clk_divider #(
    .period(period),
    .duty(duty) 
)clk_div(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out)
); 

assign clk_out = new_clk_out; // Assign the new clock output to a wire

bcd_decoder bcd_dec(
    .bcd_in(num),
    .seg_out(seg_out)
);

always @(posedge clk_out or negedge reset) 
begin
    if(!reset)
        count <= 4'd0; // Reset the count to 0
    else if(count == maximum) // Check if the count has reached the maximum value
        count <= 4'd0; // Reset the count to 0
    else
        count <= count + 4'd1; // Increment the count
end

always @(*)
begin
    case(count)
        4'd0: num <= 4'd1; // Display 1
        4'd1: num <= 4'd1; // Display 1
        4'd2: num <= 4'd3; // Display 3
        4'd3: num <= 4'd5; // Display 5
        4'd4: num <= 4'd1; // Display 1
        4'd5: num <= 4'd1; // Display 1
        4'd6: num <= 4'd0; // Display 0
        4'd7: num <= 4'd8; // Display 8
        4'd8: num <= 4'd4; // Display 4

        4'd9: num <= 4'd1; // Display 1
        4'd10: num <= 4'd2; // Display 2
        4'd11: num <= 4'd0; // Display 0
        4'd12: num <= 4'd4; // Display 4

        4'd13: num <= 4'd10; // Display null
        4'd14: num <= 4'd0; // Display 0
        4'd15: num <= 4'd1; // Display 1
    endcase
end


assign {CA, CB, CC, CD, CE, CF, CG} = seg_out; // Assign the segment outputs to the corresponding pins


assign DP = ~new_clk_out; // Set the decimal point to off
assign AN = 1'b0; // Set the anode to on

endmodule