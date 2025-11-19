module sequence_detector(
    input sys_clk_in,
    input reset,
    input data_in,
    output data,
    output [7:0] data_bus,
    output new_clk_out,
    output reg led
);

parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter refreshHz = 28'd1;

reg [1:0] wait_count;
reg buffer [7:0];
assign data = data_in;

assign data_bus = {buffer[7], buffer[6], buffer[5], buffer[4], buffer[3], buffer[2], buffer[1], buffer[0]};

clk_divider#(
    .clk_freq(clk_freq),
    .Hz(refreshHz)
)clk_ver1(
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(new_clk_out)
);

always @(posedge new_clk_out or negedge reset)
begin
    if(!reset)
    begin
        buffer[0] <= 1'b0;
        buffer[1] <= 1'b0;
        buffer[2] <= 1'b0;
        buffer[3] <= 1'b0;
        buffer[4] <= 1'b0;
        buffer[5] <= 1'b0;
        buffer[6] <= 1'b0;
        buffer[7] <= 1'b0;
        wait_count <= 2'd0;
        led <= 1'b0;
    end
    else
    begin
        buffer[0] <= data_in;
        buffer[1] <= buffer[0];
        buffer[2] <= buffer[1];
        buffer[3] <= buffer[2];
        buffer[4] <= buffer[3];
        buffer[5] <= buffer[4];
        buffer[6] <= buffer[5];
        buffer[7] <= buffer[6];

        if(data_bus == 8'b10111001)
        begin
            led <= 1'b1;
        end
        else
        begin
            led <= 1'b0;
        end
    end
end
endmodule