module circulate_shift(
    input sys_clk_in, // System clock input
    input reset, // Active low reset signal
    input direction, // 0 for left shift, 1 for right shift
    input [4:0] shifting_bits, // Number of bits to shift
    input [binary_in_length - 1:0] binary_in, // Input binary number
    output reg [binary_in_length - 1:0] binary_out, // Output binary number
    output clk_out // Output clock signal
);


parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter shift_freqHz = 28'd1; // 5MHz shift frequency;
parameter binary_in_length = 32; // Length of the binary input (default 32bits)
reg [1:0] count;

clk_divider #(
    .clk_freq(clk_freq),
    .Hz(shift_freqHz)
) clk_div (
    .sys_clk_in(sys_clk_in),
    .reset(reset),
    .new_clk_out(clk_out)
);

always @(posedge clk_out or negedge reset)
begin
    if(!reset)
        count <= 2'd0;
    else if(count == 2'd3)
        count <= 2'd1;
    else
        count <= count + 1'd1;
end

always @(posedge clk_out or negedge reset)
begin
    if (!reset)
        binary_out <= 40'd0;
    else 
    begin
        if (direction == 1'b0) // Left shift
        begin
            if (count == 2'd0)
                binary_out <= (binary_in << shifting_bits) | (binary_in >> (binary_in_length - shifting_bits));
            else
                binary_out <= (binary_out << shifting_bits) | (binary_out >> (binary_in_length - shifting_bits));
        end
        else 
        begin // Right shift
            if (count == 2'd0)
                binary_out <= (binary_in >> shifting_bits) | (binary_in << (binary_in_length - shifting_bits));
            else
                binary_out <= (binary_out >> shifting_bits) | (binary_out << (binary_in_length - shifting_bits));
        end
    end
end

endmodule