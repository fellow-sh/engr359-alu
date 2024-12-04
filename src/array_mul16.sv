`timescale 1ns/1ps

/*
 * A 16-bit array multiplier that utilizes carry-save adders. Untested with
 * signed numbers. Only tested with up to 2^8-1.
 */
module array_mul16 (
    input   wire    [15:0]  op1,
    input   wire    [15:0]  op2,
    output  wire    [31:0]  product,
    output  wire            carry_out
);
    wire [15:0] carry_ij [0:15];
    wire [15:1] sum_ij [0:15];


    csa1 ma0j [15:0] (
        .xi(op1),
      	.yi(op2[0]),
        .carry_in(16'b0),
        .sum_in(16'b0),
        .carry_out(carry_ij[0]),
        .sum_out({sum_ij[0], product[0]})
    );

    genvar i;

    generate
        for (i = 1; i < 16; i = i + 1) begin
            csa1 maij [15:0] (
                .xi(op1),
                .yi(op2[i]),
                .carry_in(carry_ij[i-1]),
                .sum_in({1'b0, sum_ij[i-1]}),
                .carry_out(carry_ij[i]),
                .sum_out({sum_ij[i], product[i]})
            );
        end
    endgenerate

    rca16 rca_final (
        .op1({1'b0, sum_ij[15]}),
        .op2(carry_ij[15]),
        .carry_in(1'b0),
        .sum(product[31:16]),
        .carry_out(carry_out)
    );
endmodule
