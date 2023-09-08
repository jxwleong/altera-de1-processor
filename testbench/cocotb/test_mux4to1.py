import cocotb
from cocotb.triggers import Timer


async def initialize(dut):
    await Timer(1, units="ns")
    dut.i0.value  = 0
    dut.i1.value  = 0
    await Timer(1, units="ns")

"""Run test for a 4-to-1 multiplexer without a clock."""
@cocotb.test()
async def test_mux4_to_1_S1S0_eq_00_expect_I0(dut):
    dut._log.info("Running test for S1S0=00...")

    await initialize(dut)  # Call the initialization function
    dut._log.info("Initialization DONE!")

    dut._log.info("S1S0=00, I3_I2_I1_I0=0001 EXPECTED OUT=I0=1")
    dut.i0.value = 1
    dut.i1.value = 0
    dut.i2.value = 0
    dut.i3.value = 0
    dut.S0.value = 0
    dut.S1.value = 0
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i0.value, f"Expected {dut.i0.value} but got {dut.out}"

    dut._log.info("S1S0=00, I3_I2_I1_I0=1110 EXPECTED OUT=I0=0")
    dut.i0.value = 0
    dut.i1.value = 1
    dut.i2.value = 1
    dut.i3.value = 1
    dut.S0.value = 0
    dut.S1.value = 0
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i0.value, f"Expected {dut.i0.value} but got {dut.out}"


@cocotb.test()
async def test_mux4_to_1_S1S0_eq_01_expect_I1(dut):
    dut._log.info("Running test for S1S0=01...")

    await initialize(dut)  # Call the initialization function
    dut._log.info("Initialization DONE!")

    dut._log.info("S1S0=01, I3_I2_I1_I0=0010 EXPECTED OUT=I1=1")
    dut.i0.value = 0
    dut.i1.value = 1
    dut.i2.value = 0
    dut.i3.value = 0
    dut.S0.value = 1
    dut.S1.value = 0
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i1.value, f"Expected {dut.i1.value} but got {dut.out}"

    dut._log.info("S1S0=01, I3_I2_I1_I0=1101 EXPECTED OUT=I1=0")
    dut.i0.value = 1
    dut.i1.value = 0
    dut.i2.value = 1
    dut.i3.value = 1
    dut.S0.value = 1
    dut.S1.value = 0
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i1.value, f"Expected {dut.i1.value} but got {dut.out}"
    
@cocotb.test()
async def test_mux4_to_1_S1S0_eq_10_expect_I2(dut):
    dut._log.info("Running test for S1S0=10...")

    await initialize(dut)  # Call the initialization function
    dut._log.info("Initialization DONE!")

    dut._log.info("S1S0=10, I3_I2_I1_I0=0100 EXPECTED OUT=I2=1")
    dut.i0.value = 0
    dut.i1.value = 0
    dut.i2.value = 1
    dut.i3.value = 0
    dut.S0.value = 0
    dut.S1.value = 1
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i2.value, f"Expected {dut.i2.value} but got {dut.out}"

    dut._log.info("S1S0=01, I3_I2_I1_I0=1011 EXPECTED OUT=I2=0")
    dut.i0.value = 1
    dut.i1.value = 1
    dut.i2.value = 0
    dut.i3.value = 1
    dut.S0.value = 0
    dut.S1.value = 1
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i2.value, f"Expected {dut.i2.value} but got {dut.out}"

@cocotb.test()
async def test_mux4_to_1_S1S0_eq_11_expect_I3(dut):
    dut._log.info("Running test for S1S0=11...")

    await initialize(dut)  # Call the initialization function
    dut._log.info("Initialization DONE!")

    dut._log.info("S1S0=11, I3_I2_I1_I0=1000 EXPECTED OUT=I3=1")
    dut.i0.value = 0
    dut.i1.value = 0
    dut.i2.value = 0
    dut.i3.value = 1
    dut.S0.value = 1
    dut.S1.value = 1
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i3.value, f"Expected {dut.i3.value} but got {dut.out}"

    dut._log.info("S1S0=11, I3_I2_I1_I0=0111 EXPECTED OUT=I3=0")
    dut.i0.value = 1
    dut.i1.value = 1
    dut.i2.value = 1
    dut.i3.value = 0
    dut.S0.value = 1
    dut.S1.value = 1
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i3.value, f"Expected {dut.i3.value} but got {dut.out}"