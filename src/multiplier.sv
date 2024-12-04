`timescale 1ns/1ps

/*
 * Interface module between the multiplier and the ALU.
 */
module multiplier (
    input   wire    [15:0]  op1,        // Multiplicand.
    input   wire    [15:0]  op2,        // Multiplier.
    output  wire    [15:0]  result,     // Product.
    output  wire            carry_out   // Carry out bit.
);
    wire [31:0] product;
    
    array_mul16 am16 (
        .op1(op1),
        .op2(op2),
        .product(product),
        .carry_out(carry_out)
    );

    assign result = product[15:0];
endmodule
