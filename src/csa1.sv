`timescale 1ns/1ps

/*
 * 1-bit carry-save adder used for array multiplication.
 */
module csa1 (
    input   wire    xi,
    input   wire    yi,
    input   wire    carry_in,
    input   wire    sum_in,
    output  wire    carry_out,
    output  wire    sum_out
);

    wire b_in;
    assign b_in = xi & yi;

    full_adder fa1(
        .a(sum_in),
        .b(b_in),
        .carry_in(carry_in),
        .sum(sum_out),
        .carry_out(carry_out)
    );

endmodule
