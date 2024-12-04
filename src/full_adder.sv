`timescale 1ns/1ps

module full_adder (
    input   wire    a,
    input   wire    b,
    input   wire    carry_in,
    output  wire    sum,
    output  wire    carry_out
);
    wire    sum1;
    wire    carry1;
    wire    carry2;

    half_adder ha1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(carry1)
    );

    half_adder ha2 (
        .a(sum1),
        .b(carry_in),
        .sum(sum),
        .carry(carry2)
    );

    assign carry_out = carry1 | carry2;
endmodule
