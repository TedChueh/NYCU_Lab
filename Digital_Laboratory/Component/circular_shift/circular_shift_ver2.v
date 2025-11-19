module circulate_shift_ver2(
    input sys_clk_in, // System clock input
    input reset, // Active low reset signal
    input pause, // 0 for continue, 1 for pause
    input direction, // 0 for left shift, 1 for right shift
    input [4:0] shifting_bits, // Number of bits to shift
    input [binary_in_length - 1:0] binary_in, // Input binary number
    output reg [binary_in_length - 1:0] binary_out, // Output binary number
    output clk_out // Output clock signal
);


parameter clk_freq = 28'd100_000000; // 100MHz clock input
parameter shift_freqHz = 28'd1; // 5MHz shift frequency;
parameter binary_in_length = 32; // Length of the binary input (default 32bits)

reg [6:0] shift_count;



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
    if (!reset)
    begin
        shift_count <= 1'd0;
    end

    else if(!pause)
    begin
        if (direction == 1'b0) 
        begin // Left shift
            // binary_out <= (binary_in << shift_count) | (binary_in >> (binary_in_length - shift_count));
            if (shift_count >= binary_in_length - 4'd4)
                shift_count <= 4'd0;
            else 
                shift_count <= shift_count + shifting_bits;
        end
        else if (direction == 1'b1) 
        begin // Right shift
            // binary_out <= (binary_in << shift_count) | (binary_in >> (binary_in_length - shift_count));
             if (shift_count <= 4'd0)
                shift_count <= binary_in_length - 4'd4;
             else 
                shift_count <= shift_count - shifting_bits;
        end
    end

    // else if(pause)
    //     binary_out <= (binary_in << shift_count) | (binary_in >> (binary_in_length - shift_count));
end

always @(*)
begin
    binary_out <= (binary_in << shift_count) | (binary_in >> (binary_in_length - shift_count));
end
endmodule