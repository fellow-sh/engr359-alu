`timescale 1ns/1ps

/*
 * A 16-bit ripple-carry adder.
 */
module rca16 (
    input   wire    [15:0]  op1,
    input   wire    [15:0]  op2,
    input   wire            carry_in,
    output  wire    [15:0]  sum,
    output  wire            carry_out
);

    wire [3:1] carry;

    /* Using 4-bit RCAs as grouped ripple carry adders.
    This is before I learned about the `generate` block. */
    rca4 ga1(op1[3:0], op2[3:0], carry_in, sum[3:0], carry[1]);
    rca4 ga2(op1[7:4], op2[7:4], carry[1], sum[7:4], carry[2]);
    rca4 ga3(op1[11:8], op2[11:8], carry[2], sum[11:8], carry[3]);
    rca4 ga4(op1[15:12], op2[15:12], carry[3], sum[15:12], carry_out);
    //assign sum = op1 + op2 + carry_in;
    //assign carry_out = (op1[15] & op2[15]) ^ sum[15]; // overflow
endmodule

