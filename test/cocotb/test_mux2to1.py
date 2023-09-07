import cocotb
from cocotb.triggers import Event, RisingEdge, FallingEdge, Timer





async def initialize(dut):
    await Timer(1, units="ns")
    dut.i0.value  = 0
    dut.i1.value  = 0
    await Timer(1, units="ns")


@cocotb.test()
async def test_mux2_to_1(dut):
    """Run test for a 2-to-1 multiplexer without a clock."""
    
    dut._log.info("Running test...")

    await initialize(dut)  # Call the initialization function
    dut._log.info("Initialization DONE!")

    dut._log.info("S0=0, I0=1, I1=0, EXPECTED OUT=I0=1")
    dut.i0.value = 1
    dut.i1.value = 0
    dut.S0.value = 0
    await Timer(1, units="ns")  # wait a bit for hardware natural delay
    assert dut.out == dut.i0.value, f"Expected {dut.i0.value } but got {dut.out}"

    dut._log.info("S0=1, I0=0, I1=1, EXPECTED OUT=I1=1")
    dut.i0.value = 0
    dut.i1.value = 1
    dut.S0.value = 1
    await Timer(1, units="ns") 
    assert dut.out == dut.i1.value, f"Expected {dut.i1.value} but got {dut.out}"
    