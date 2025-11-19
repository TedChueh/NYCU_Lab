module bcd_display(
    input sys_clk_in,
    input reset,
    input [7:0] display0,
    input [7:0] display1,
    input [7:0] display2,
    input [7:0] display3,
    input [7:0] display4,
    input [7:0] display5,
    input [7:0] display6,
    input [7:0] display7,
    output reg [7:0] display_out,
    output reg [7:0] seg_control
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter refresh_rate_Hz = 28'd1000; // 1kHz refresh rate
parameter single_display_refresh_rate = refresh_rate_Hz * 8; // 8kHz for single display
parameter maximum_count = 4'd8; // Maximum count for 8 displays
wire clk_out;
reg [3:0] count;

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(single_display_refresh_rate)
)clk(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(clk_out)
);

always @(posedge clk_out or negedge reset) 
begin
    if (!reset) // Check for reset
        count <= 4'd0; // Reset the count to 0
    else if(count == maximum_count)
        count <= 4'd1; // Reset the count to 0 if it reaches the maximum count
    else
        count <= count + 1'd1; // Increment the count
end

always @(*)
begin
    case (count)

        4'd1: 
        begin 
            display_out = display0; // Display 0
            seg_control = 8'b0111_1111; // Enable Display 0
        end
        ////
        4'd2: 
        begin
            display_out = display1; // Display 1
            seg_control = 8'b1011_1111; // Enable Display 1
        end
        ////
        4'd3: 
        begin
            display_out = display2; // Display 2
            seg_control = 8'b1101_1111; // Enable Display 2
        end
        ////
        4'd4: 
        begin
            display_out = display3; // Display 3
            seg_control = 8'b1110_1111; // Enable Display 3
        end
        ////
        4'd5: 
        begin 
            display_out = display4; // Display 4
            seg_control = 8'b1111_0111; // Enable Display 4
        end
        ////
        4'd6: 
        begin
            display_out = display5; // Display 5
            seg_control = 8'b1111_1011; // Enable Display 5 
        end
        ////
        4'd7: 
        begin
            display_out = display6; // Display 6
            seg_control = 8'b1111_1101; // Enable Display 6
        end
        ////
        4'd8: 
        begin
            display_out = display7; // Display 7
            seg_control = 8'b1111_1110; // Enable Display 7
        end
        ////
        default: 
        begin
            display_out = 8'b11111111; // Default case to turn off all displays
            seg_control = 8'b1111_1111; // Disable all displays
        end
    endcase
end
endmodule