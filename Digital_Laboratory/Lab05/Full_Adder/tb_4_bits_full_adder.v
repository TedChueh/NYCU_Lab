`timescale 1ns/1ns
module tb_4_bits_full_adder();
    reg carry_in;
    reg augend1;
    reg augend2;
    reg augend3;
    reg augend4;

    reg addend1;
    reg addend2;
    reg addend3;
    reg addend4;

    wire sum1;
    wire sum2;
    wire sum3;
    wire sum4;

    wire carry_out;

bits4_full_adder UUT1(
    .carry_in(carry_in),
    .augend1(augend1),
    .augend2(augend2),
    .augend3(augend3),
    .augend4(augend4),

    .addend1(addend1),
    .addend2(addend2),
    .addend3(addend3),
    .addend4(addend4),

    .sum1(sum1),
    .sum2(sum2),
    .sum3(sum3),
    .sum4(sum4),

    .carry_out(carry_out)
);

initial begin
    {carry_in, augend4, augend3, augend2, augend1, addend4, addend3, addend2, addend1} = 9'b0_0000_0000; // zero test 
 #5 {carry_in, augend4, augend3, augend2, augend1, addend4, addend3, addend2, addend1} = 9'b0_0001_0001; // normal addition test
 #5 {carry_in, augend4, augend3, augend2, augend1, addend4, addend3, addend2, addend1} = 9'b1_0011_0011; // carry in test
 #5 {carry_in, augend4, augend3, augend2, augend1, addend4, addend3, addend2, addend1} = 9'b1_1111_1111; // maximum test


end
    
endmodule