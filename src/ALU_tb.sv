`timescale 1ns/1ps

module ALU_tb;
    reg [15:0] instruction;
    wire [15:0] registers [0:15];

    // Instantiate the ALU module
    ALU uut (
        .instruction(instruction),
        .registers(registers)
    );

    integer i;

    initial begin
        // Initialize registers to zero
        for (i = 0; i < 16; i = i + 1) begin
            uut.registers[i] = 16'd0;
        end

        // Test 1: Load Immediate (Opcode 1111)
        instruction = {4'b1111, 4'd0, 8'hAA}; // Load 0xAA into register 0
        #5;
        $display("Load Immediate: Register 0 = %h", registers[0]);

        // Test 2: ADD (Opcode 0000)
        uut.registers[1] = 16'h0010; // Set register 1 to 0x0010
        uut.registers[2] = 16'h0005; // Set register 2 to 0x0005
        instruction = {4'b0000, 4'd1, 4'd2, 4'd3}; // ADD R1 + R2 -> R3
        #5;
        $display("Load Immediate: Register 1 = %h", registers[1]);
        $display("Load Immediate: Register 2 = %h", registers[2]);
        $display("ADD R1, R2, R3 -> %h", registers[3]);

        // Test 3: SUB (Opcode 0001)
        instruction = {4'b0001, 4'd1, 4'd2, 4'd4}; // SUB R1 - R2 -> R4
        #5;
        $display("SUB R1, R2, R4 -> %h", registers[4]);

        // Test 4: AND (Opcode 0011)
        instruction = {4'b0011, 4'd1, 4'd2, 4'd5}; // AND R1 & R2 -> R5
        #5;
        $display("AND R1, R2, R5 -> %h", registers[5]);

        // Test 5: OR (Opcode 0100)
        instruction = {4'b0100, 4'd1, 4'd2, 4'd6}; // OR R1 | R2 -> R6
        #5;
        $display("OR R1, R2, R6 -> %h", registers[6]);

        // Test 6: XOR (Opcode 0101)
        instruction = {4'b0101, 4'd1, 4'd2, 4'd7}; // XOR R1 ^ R2 -> R7
        #5;
        $display("XOR R1, R2, R7 -> %h", registers[7]);

        // Test 7: NOT (Opcode 0110)
        instruction = {4'b0110, 4'd1, 4'd0, 4'd8}; // NOT R1 -> R8
        #5;
        $display("NOT R1, R2, R8 -> %h", registers[8]);

        $finish;
    end
endmodule
