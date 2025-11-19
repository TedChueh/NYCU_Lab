module bit_half_adder (
    input inA,
    input inB,
    output sum,
    output cout
);

xor g1(sum, inA, inB);
and g2(cout, inA, inB);
    
endmodule