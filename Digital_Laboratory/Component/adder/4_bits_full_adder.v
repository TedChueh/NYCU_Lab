module bits4_full_adder (
    input carry_in,
    input augend1,
    input augend2,
    input augend3,
    input augend4,

    input addend1,
    input addend2, 
    input addend3,
    input addend4,

    output sum1,
    output sum2,
    output sum3,
    output sum4,

    output carry_out


);

wire carry_out1;
wire carry_out2;
wire carry_out3;

bit_full_adder full1 (
    .inA(augend1),
    .inB(addend1),
    .cin(carry_in),
    .sum(sum1),
    .cout(carry_out1)
);

bit_full_adder full2 (
    .inA(augend2),
    .inB(addend2),
    .cin(carry_out1),
    .sum(sum2),
    .cout(carry_out2)
);

bit_full_adder full3 (
    .inA(augend3),
    .inB(addend3),
    .cin(carry_out2),
    .sum(sum3),
    .cout(carry_out3)
);

bit_full_adder full4 (
    .inA(augend4),
    .inB(addend4),
    .cin(carry_out3),
    .sum(sum4),
    .cout(carry_out)
);


//or g1(cout, cout1, cout2);

endmodule