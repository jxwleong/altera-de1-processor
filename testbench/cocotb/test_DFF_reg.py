import cocotb
from cocotb.triggers import Event, RisingEdge, FallingEdge, Timer



async def generate_clock(dut, num_cycles=10000):
    """Generate clock pulses."""
    for cycle in range(num_cycles):
        dut.clock.value = 0
        await Timer(1, units="ns")
        dut.clock.value = 1
        await Timer(1, units="ns")


async def initialize(dut):
    dut.clear.value  = 0
    await Timer(1, units="ns")
    dut.clear.value  = 1
    dut.load.value  = 0
    dut.D.value  = 0
    dut.Q.value = 0
    await Timer(1, units="ns")


@cocotb.test()
async def test_DFF_reg_clear(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    await RisingEdge(dut.clock)
    dut.clear.value = 0
    dut._log.info(f"Signal clear is set to {dut.clear.value}")

    await RisingEdge(dut.clock)
    assert dut.Q.value == 0, f"Expected 0 but got {dut.Q.value}"
    assert dut.D.value == 0, f"Expected 0 but got {dut.D.value}"
    assert dut.load.value == 0, f"Expected 0 but got {dut.load.value}"


@cocotb.test()
async def test_DFF_reg_load(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    # D=0
    await RisingEdge(dut.clock)
    dut.load.value = 1
    dut._log.info(f"Signal load is set to {dut.load.value}")

    dut.D.value = 0
    dut._log.info(f"Input D is set to {dut.D.value}")

    await RisingEdge(dut.clock)
    assert dut.Q.value == 0, f"Expected 0 but got {dut.Q.value}"
    assert dut.D.value == 0, f"Expected 0 but got {dut.D.value}"
    assert dut.load.value == 1, f"Expected 1 but got {dut.load.value}"

    # D=1
    await RisingEdge(dut.clock)
    dut.D.value = 1
    dut._log.info(f"Input D is set to {dut.D.value}")

    # Wait for another cycle for the output to be loaded to the output (Q)
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.Q.value == 1, f"Expected 1 but got {dut.Q.value}"
    assert dut.D.value == 1, f"Expected 1 but got {dut.D.value}"
    assert dut.load.value == 1, f"Expected 1 but got {dut.load.value}"


@cocotb.test()
async def test_DFF_reg_idle(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    # Load first
    # D=1
    await RisingEdge(dut.clock)
    dut.load.value = 1
    dut._log.info(f"Signal load is set to {dut.load.value}")

    await RisingEdge(dut.clock)
    dut.D.value = 1
    dut._log.info(f"Input D is set to {dut.D.value}")

    # Wait for another cycle for the output to be loaded to the output (Q)
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.Q.value == 1, f"Expected 1 but got {dut.Q.value}"
    assert dut.D.value == 1, f"Expected 1 but got {dut.D.value}"
    assert dut.load.value == 1, f"Expected 1 but got {dut.load.value}"

    # Deassert the load signal to make it idle
    await RisingEdge(dut.clock)
    dut.load.value = 0
    dut._log.info(f"Signal load is set to {dut.load.value}")

    # Wait multiple cycles to see if the original value of output (Q) remains
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.Q.value == 1, f"Expected 1 but got {dut.Q.value}"
    assert dut.load.value == 0, f"Expected 1 but got {dut.load.value}"