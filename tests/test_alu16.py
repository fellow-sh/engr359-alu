import random

import cocotb
from cocotb.triggers import Timer


@cocotb.test
async def alu16_basic_add_test(dut):
    """Unit test for 9 + 7."""
    operand1 = 7
    operand2 = 9
    expected = operand1 + operand2

    dut.op1.value = operand1
    dut.op2.value = operand2
    dut.select.value = 0b0000

    await Timer(10, units='ns')

    assert dut.result.value == expected, \
        f'Unexpected result: {dut.result.value}'
    

@cocotb.test
async def add_randomized_test(dut):
    """Tests adding 2 randomized numbers 10 times."""

    for i in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        dut.op1.value = operand1
        dut.op2.value = operand2
        dut.select.value = 0b0000

        await Timer(10, units='ns')

        assert dut.result.value == operand1 + operand2, \
            f'Randomized add failed with {operand1} + {operand2} -> {dut.result.value}'
        

@cocotb.test
async def sub_randomized_test(dut):
    """Tests subtracting 2 randomized numbers 10 times."""

    for i in range(10):
        operand2 = random.randint(0, 2**8-1)
        operand1 = random.randint(operand2, 2**8-1)

        dut.op1.value = operand1
        dut.op2.value = operand2
        dut.select.value = 0b0001

        await Timer(10, units='ns')

        assert dut.result.value == operand1 - operand2, \
            f'Randomized subtract failed with {operand1} - {operand2} -> {dut.result.value}'
    

@cocotb.test
async def multiply_randomized_test(dut):
    """Tests multiplying 2 randomized numbers 10 times."""

    for i in range(10):
        operand1 = random.randint(0, 2**8-1)
        operand2 = random.randint(0, 2**8-1)

        dut.op1.value = operand1
        dut.op2.value = operand2
        dut.select.value = 0b0010

        await Timer(10, units='ns')

        assert dut.result.value == operand1 * operand2, \
            f'Randomized multiplicaion failed with {operand1} * {operand2} -> {dut.result.value}'
        
