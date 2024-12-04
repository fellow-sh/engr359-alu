`timescale 1ns/1ps

/*
 * A 16-bit true arithmetic logic unit.
 */
module alu16 (
    input   wire    [15:0]  op1,
    input   wire    [15:0]  op2,
    input   wire    [3:0]   select,
    output  logic   [15:0]  result
);
    logic add_sub_sel = 1'b0;
    wire carry_out;
    wire [15:0] adder_result;
    wire [15:0] multiplier_result;

    adder_sub adder_sub1 (
        .op1(op1),
        .op2(op2),
        .sub(add_sub_sel),
        .result(adder_result),
        .carry_out(carry_out)
    );

    multiplier multiplier1 (
        .op1(op1),
        .op2(op2),
        .result(multiplier_result),
        .carry_out(carry_out)
    );

    // ALU logic
    always @(*) begin
        case (select)
            4'b0000: begin // ADD
                add_sub_sel = 1'b0;
                result = adder_result;
            end
            4'b0001: begin // SUB
                add_sub_sel = 1'b1;
                result = adder_result;
            end
            4'b0010: result = multiplier_result; // MUL
            4'b0011: result = op1 & op2;         // AND
            4'b0100: result = op1 | op2;         // OR
            4'b0101: result = op1 ^ op2;         // XOR
            4'b0110: result = ~op1;              // NOT
            4'b1111: result = op1;               // MOV
            default: result = 16'h0000;          // Default to zero
        endcase
    end

endmodule
