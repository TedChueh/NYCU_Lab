`timescale 1ns/1ns
module tb_Example_2();
    reg inA;
    reg inB;
    wire sum;
    wire cout;

bit_half_adder UUT1(
    .inA(inA),
    .inB(inB),
    .sum(sum),
    .cout(cout)
);

initial begin
    {inA, inB} = 2'b00;
 #5 {inA, inB} = 2'b01;
 #5 {inA, inB} = 2'b10;
 #5 {inA, inB} = 2'b11;
    
end
    
endmodule