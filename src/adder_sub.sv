`timescale 1ns/1ps

/*
 * A combined adder-subtractor module. Interface module between the adder
 * and the ALU.
 */
module adder_sub (
    input   wire    [15:0]  op1,        // Addend.
    input   wire    [15:0]  op2,        // Addend.
    input   wire            sub,        // Add-subtract mode select.
    output  wire    [15:0]  result,     // Sum.
    output  wire            carry_out   // Carry out bit.
);
    wire [15:0] sub_ones;
    wire [15:0] op2_twos;

    assign sub_ones = {16{sub}};
    assign op2_twos = op2 ^ sub_ones;

    rca16 adder1 (
        .op1(op1),
        .op2(op2_twos),
        .carry_in(sub),
        .sum(result),
        .carry_out(carry_out)
    );
endmodule
