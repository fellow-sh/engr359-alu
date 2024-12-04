`timescale 1ns/1ps

/*
 * A 4-bit ripple-carry adder. This really is unnecessary.
 */
module rca4 (
    input   wire    [3:0]   op1,
    input   wire    [3:0]   op2,
    input   wire            carry_in,
    output  wire    [3:0]   sum,
    output  wire            carry_out
);

    wire [3:1] carry;

    full_adder fa1(op1[0], op2[0], carry_in, sum[0], carry[1]);
    full_adder fa2(op1[1], op2[1], carry[1], sum[1], carry[2]);
    full_adder fa3(op1[2], op2[2], carry[2], sum[2], carry[3]);
    full_adder fa4(op1[3], op2[3], carry[3], sum[3], carry_out);
endmodule
