import cocotb
from cocotb.triggers import RisingEdge, Timer


async def initialize(dut):
    dut.A.value  = 0
    dut.B.value  = 0
    dut.sub.value  = 0
    await Timer(1, units="ns")


@cocotb.test()
async def test_addSubtractor_add(dut):
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    dut.sub.value = 0
    dut._log.info(f"Signal sub is set to {dut.sub.value}")

    dut._log.info(f"Test:   A(0) + B(1)")
    dut.A.value = 0
    dut.B.value = 1
    await Timer(1, units="ns")
    assert dut.out.value == 1, f"Expected 1 but got {dut.out.value}"
    assert dut.A.value == 0, f"Expected 0 but got {dut.A.value}"
    assert dut.B.value == 1, f"Expected 1 but got {dut.B.value}"
    assert dut.sub.value == 0, f"Expected 0 but got {dut.sub.value}"

    dut._log.info(f"Test:   A(1) + B(1)")
    dut.A.value = 1
    dut.B.value = 1
    await Timer(1, units="ns")
    assert dut.out.value == 2, f"Expected 1 but got {dut.out.value}"
    assert dut.A.value == 1, f"Expected 0 but got {dut.A.value}"
    assert dut.B.value == 1, f"Expected 1 but got {dut.B.value}"
    assert dut.sub.value == 0, f"Expected 0 but got {dut.sub.value}"


@cocotb.test()
async def test_addSubtractor_sub(dut):
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    dut.sub.value = 1
    dut._log.info(f"Signal sub is set to {dut.sub.value}")

    dut._log.info(f"Test:   A(1) - B(0)")
    dut.A.value = 1
    dut.B.value = 0
    await Timer(1, units="ns")
    assert dut.out.value == 1, f"Expected 1 but got {dut.out.value}"
    assert dut.A.value == 1, f"Expected 0 but got {dut.A.value}"
    assert dut.B.value == 0, f"Expected 1 but got {dut.B.value}"
    assert dut.sub.value == 1, f"Expected 0 but got {dut.sub.value}"

    dut._log.info(f"Test:   A(1) - B(1)")
    dut.A.value = 1
    dut.B.value = 1
    await Timer(1, units="ns")
    assert dut.out.value == 0, f"Expected 1 but got {dut.out.value}"
    assert dut.A.value == 1, f"Expected 0 but got {dut.A.value}"
    assert dut.B.value == 1, f"Expected 1 but got {dut.B.value}"
    assert dut.sub.value == 1, f"Expected 0 but got {dut.sub.value}"