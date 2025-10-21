module bit_full_adder (
    input inA,
    input inB,
    input cin,
    output sum,
    output cout
);

wire sum1;
wire cout1;
wire cout2;

bit_half_adder half1 (
    .inA(inA),
    .inB(inB),
    .sum(sum1),
    .cout(cout1)
);
bit_half_adder half2 (
    .inA(sum1),
    .inB(cin),
    .sum(sum),
    .cout(cout2)
);

or g1(cout, cout1, cout2);

endmodule