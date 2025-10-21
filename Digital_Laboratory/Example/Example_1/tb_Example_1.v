module tb_Example_1();

reg in0;
wire out0;

bit_invert UUT1(
    .in0(in0),
    .out0(out0)
);

initial begin
    in0 = 1'b0;
    
end
    
endmodule