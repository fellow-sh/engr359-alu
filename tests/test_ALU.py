import random

import cocotb
from cocotb.triggers import Timer

ADD_OPCODE = 0b0000
SUB_OPCODE = 0b0001
MUL_OPCODE = 0b0010
AND_OPCODE = 0b0011
OR_OPCODE = 0b0100
XOR_OPCODE = 0b0101
NOT_OPCODE = 0b0110
MOV_OPCODE = 0b1111


async def mov(instr_n, reg, value):
    """Execute a load immediate value instruction."""
    mov_instr1 = (MOV_OPCODE << 12) | (reg << 8) | value << 0
    instr_n.value = mov_instr1
    await Timer(10, units='ns')


async def exec_instr(instr_n, opcode, Rn, Rm, Dest):
    """Execute an ALU instruction."""
    instr = (opcode << 12) | (Rn << 8) | (Rm << 4) | Dest
    instr_n.value = instr
    await Timer(10, units='ns')


@cocotb.test()
async def ALU_imm_load_test(dut): 
    "Tests the load immediate value functionality."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    # Assign R0 with 0xff
    await mov(dut.instruction, 0, 0xff)

    # Assign R10 with 0x55
    await mov(dut.instruction, 10, 0x55)

    assert dut.registers[0].value == 0b1111_1111, \
        f'imm_load failed, r0={dut.registers[0].value}'
    assert dut.registers[10].value == 0b0101_0101, \
        f'imm_load failed r10={dut.registers[10].value}'


@cocotb.test()
async def ALU_randomized_add_test(dut):
    "Tests adding randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await mov(dut.instruction, 1, operand2)
        await exec_instr(dut.instruction, ADD_OPCODE, 0, 1, 2)

        assert dut.registers[2].value == operand1 + operand2, \
            f'Randomized add failed'
        
        
@cocotb.test()
async def ALU_randomized_sub_test(dut):
    "Tests subtracting randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand2 = random.randint(0, 2**8-1)
        operand1 = random.randint(operand2, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await mov(dut.instruction, 1, operand2)
        await exec_instr(dut.instruction, SUB_OPCODE, 0, 1, 2)

        assert dut.registers[2].value == operand1 - operand2, \
            f'Randomized subtract failed'
        

@cocotb.test()
async def ALU_randomized_mul_test(dut):
    "Tests multiplying randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await mov(dut.instruction, 1, operand2)
        await exec_instr(dut.instruction, MUL_OPCODE, 0, 1, 2)

        assert dut.registers[2].value == operand1 * operand2, \
            f'Randomized multiplication failed'
        

@cocotb.test()
async def ALU_randomized_and_test(dut):
    "Tests bitwise AND with randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await mov(dut.instruction, 1, operand2)
        await exec_instr(dut.instruction, AND_OPCODE, 0, 1, 2)

        assert dut.registers[2].value == (operand1 & operand2), \
            f'Randomized AND failed'


@cocotb.test()
async def ALU_randomized_or_test(dut):
    "Tests bitwise OR with randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await mov(dut.instruction, 1, operand2)
        await exec_instr(dut.instruction, OR_OPCODE, 0, 1, 2)

        assert dut.registers[2].value == (operand1 | operand2), \
            f'Randomized OR failed'


@cocotb.test()
async def ALU_randomized_xor_test(dut):
    "Tests bitwise XOR with randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await mov(dut.instruction, 1, operand2)
        await exec_instr(dut.instruction, XOR_OPCODE, 0, 1, 2)

        assert dut.registers[2].value == (operand1 ^ operand2), \
            f'Randomized XOR failed'


@cocotb.test()
async def ALU_randomized_not_test(dut):
    "Tests bitwise NOT with randomized numbers 10 times."

    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    for _ in range(10):
        operand1 = random.randint(0, 2**8-1)

        await mov(dut.instruction, 0, operand1)
        await exec_instr(dut.instruction, NOT_OPCODE, 0, 0, 1)

        assert dut.registers[1].value == (~operand1 & 0xFFFF), \
            f'Randomized NOT failed'
    
    
@cocotb.test()
async def ALU_repeated_instr_test(dut):
    """Test if the ALU can read the same instruction twice. This should fail."""
    # Reset
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    # Write '1' to R0
    dut.instruction.value = 0xf001
    await Timer(10, units='ns')

    # ADD R0, R0, R0 (R0 -> 2)
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')
    
    # ADD R0, R0, R0 again (R0 -> 4)
    dut.instruction.value = 0x0000
    await Timer(10, units='ns')

    # The second ADD instruction will not execute.
    # The ALU only updates for every new instruction.
    assert dut.registers[0].value == 2
    