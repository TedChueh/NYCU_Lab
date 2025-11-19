module sound_keyboard(
    input sys_clk_in,
    input reset,
    input E,
    input F,
    input G,
    output [3:0] pin_control,
    output [9:0] num,
    output reg speaker_control

);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter refresh_rate = 28'd60;  // 60Hz refresh rate
parameter single_key_refresh_rate = refresh_rate * 4; // 240Hz refresh rate for single key
//wire [3:0] num;
wire new_clk_out [11:0];

keypad #(
    .clk_freq(clk_freq),
    .single_key_refresh_rate(single_key_refresh_rate)
)keypad1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .E(E),
    .F(F),
    .G(G),
    .num(num),
    .pin_control(pin_control)
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd262) 
) Key_1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[1])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd294)
) Key_2(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[2])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd330) 
) Key_3(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[3])
);
//////////////////////////////////////////////
clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd349)
) Key_4(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[4])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd392) 
) Key_5(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[5])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd440)
) Key_6(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[6])
);
//////////////////////////////////////////////
clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd494)
) Key_7(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[7])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd523)
) Key_8(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[8])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd587)
) Key_9(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[9])
);
//////////////////////////////////////////////
clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd659)
) Key_10(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[10])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd698)
) Key_0(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[0])
);

clk_divider #(
    .clk_freq(clk_freq), // 100MHz clock input
    .Hz(28'd754) 
) Key_11(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out[11])
);
//////////////////////////////////////////////

always@(*)
begin
    case(num)
    4'd1: speaker_control <= new_clk_out[1];
    4'd2: speaker_control <= new_clk_out[2];
    4'd3: speaker_control <= new_clk_out[3];
    4'd4: speaker_control <= new_clk_out[4];
    4'd5: speaker_control <= new_clk_out[5];
    4'd6: speaker_control <= new_clk_out[6];
    4'd7: speaker_control <= new_clk_out[7];
    4'd8: speaker_control <= new_clk_out[8];
    4'd9: speaker_control <= new_clk_out[9];
    4'd10: speaker_control <= new_clk_out[10];
    4'd0: speaker_control <= new_clk_out[0];
    4'd11: speaker_control <= new_clk_out[11];
    default: speaker_control <= 1'd0;
    endcase
end

endmodule