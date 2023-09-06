import cocotb
from cocotb.triggers import Event, RisingEdge, FallingEdge, Timer

import math

# Dump VCD trace
import os
os.environ['COCOTB_ENABLE_COVERAGE'] = '1'

async def generate_clock(dut, num_cycles=10000):
    """Generate clock pulses."""
    for cycle in range(num_cycles):
        dut.clock.value = 0
        await Timer(1, units="ns")
        dut.clock.value = 1
        await Timer(1, units="ns")


async def initialize(dut):
    dut.reset.value  = 0
    await Timer(1, units="ns")
    dut.reset.value  = 1
    dut.enter.value  = 0
    dut.dataIn.value  = 0
    await Timer(1, units="ns")

def print_all_signals(dut):
    for name, signal in dut._sub_handles.items():
        dut._log.info(f"Signal: {name}, Value: {signal.value}")

@cocotb.test()
async def test_gcd(dut):
    value_1 = 10
    value_2 = 5

    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")

    await Timer(5, units="ns")  # wait a bit

    await RisingEdge(dut.clock)
    print_all_signals(dut)
    dut.dataIn.value  = value_1
    dut.enter.value  = 1

    await RisingEdge(dut.clock)
    dut.enter.value  = 0
    dut._log.info(f"Set dataIn = {dut.dataIn.value}")

    await RisingEdge(dut.clock)
    dut.dataIn.value  = value_2
    dut.enter.value  = 1

    await RisingEdge(dut.clock)
    dut.enter.value  = 0
    dut._log.info(f"Set dataIn = {dut.dataIn.value}")

    await RisingEdge(dut.clock)
    dut._log.info(f"dataOut is {dut.dataOut.value}")
    
    
    #assert dut.dataOut.value == math.gcd(value_1, value_2), f"dataOut (GDC) between {value_1} and {value_2} is not {math.gcd(value_1, value_2)}!"