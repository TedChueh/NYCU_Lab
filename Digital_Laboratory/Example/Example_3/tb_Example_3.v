`timescale 1ns/1ns
module tb_Example_3();
    reg inA;
    reg inB;
    reg cin;
    wire sum;
    wire cout;

bit_full_adder UUT1(
    .inA(inA),
    .inB(inB),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    {inA, inB, cin} = 3'b000;
 #5 {inA, inB, cin} = 3'b001; 
 #5 {inA, inB, cin} = 3'b010;
 #5 {inA, inB, cin} = 3'b011;
 #5 {inA, inB, cin} = 3'b100;   
 #5 {inA, inB, cin} = 3'b101;   
 #5 {inA, inB, cin} = 3'b110;   
 #5 {inA, inB, cin} = 3'b111;   

end
    
endmodule