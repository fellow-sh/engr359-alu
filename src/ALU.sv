`timescale 1ns/1ps

/*
 * The "ALU" design to test.
 *
 * Features a simple instruction decoder, built-in exposed data registers,
 * internal buses for register transfers, and kinda-gate-level defined
 * arithmetic operations.
 * 
 * This "ALU" lacks status input/output, an register-ALU bus, and a control
 * unit. Technically an ALU should not have a register bank but I digress.
 */
module ALU (
    input   wire    [15:0]  instruction,            // Instruction input.
    output  logic   [15:0]  registers    [0:15]     // Exposed registers.
);
    logic [15:0] operand1;
    logic [15:0] operand2;
    logic [15:0] accumulator;

    // Input selection signals
    logic [3:0] select_op1;
    logic [3:0] select_op2;

    // Write enable and destination signals
    logic [3:0] write_select;
    logic write_enable;

    alu16 intern_alu(
        .op1(operand1),
        .op2(operand2),
        .select(instruction[15:12]),
        .result(accumulator)
    );

    // Instruction decode logic
    always @(instruction) begin
        if (instruction[15:12] === 4'b1111) begin
            write_select = instruction[11:8];

            operand1 = {8'b0, instruction[7:0]};
            operand2 = 16'b0;
        end
        else begin
            select_op1 = instruction[11:8]; 
            select_op2 = instruction[7:4];  
            write_select = instruction[3:0];

            operand1 = registers[select_op1];
            operand2 = registers[select_op2];
        end

        // wait for ALU propagation delay
        #1 registers[write_select] = accumulator;
    end

endmodule
