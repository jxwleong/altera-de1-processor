import cocotb
from cocotb.triggers import RisingEdge, Timer


async def generate_clock(dut, num_cycles=10000):
    """Generate clock pulses."""
    for cycle in range(num_cycles):
        dut.clk.value = 0
        await Timer(1, units="ns")
        dut.clk.value = 1
        await Timer(1, units="ns")


async def initialize(dut):
    dut.DATA_IN.value  = 0
    dut.ADDR.value  = 0
    dut.WRITE.value  = 0
    await Timer(1, units="ns")


""" 
Actual RAM DATA in RTL:
    RAM[0]  = 8'b10000000;	// IN A
    RAM[1]  = 8'b00111110;	// STORE A into address 11110
    RAM[2]  = 8'b10000000;	// IN A
    RAM[3]  = 8'b00111111;  // STORE A into address 11111
    RAM[4]  = 8'b00011110;	// LOAD Content of 11110 to A (Load first A to A)
    RAM[5]  = 8'b01111111;	// SUB A with Content of 11111 (First A - Second A)
    RAM[6]  = 8'b10110000;  // JUMP to 10000[0] if A equals 0
    RAM[7]  = 8'b11001100;  // JUMP to 01100[12] if A equals positive (First A > Second A)
    RAM[8]  = 8'b00011111;  // STORE A into address 11111
    RAM[9]  = 8'b01111110;	// SUB A with Content of 11110
    RAM[10] = 8'b00111111;  // STORE A into address 11111
    RAM[11] = 8'b11000100;	// JUMP to 01100 if A equals positive
    RAM[12] = 8'b00011110;  // STORE A into address 11110 (Store subtracted A back to original first A location)
    RAM[13] = 8'b01111111;	// SUB A with Content of 11111 (Second A - subtracted A)

    RAM[14] = 8'b00111110;  // STORE A into address 11110
    RAM[15] = 8'b11000100;	// JUMP to 00100 if A equals positive
    RAM[16] = 8'b00011110;	// LOAD Content of 11110 to A
    RAM[17] = 8'b11111111;  // HALT
    RAM[30] = 8'b00000000;
    RAM[31] = 8'b00000000;
"""
@cocotb.test()
async def test_RAM_read(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    # Read RAM[1] and assert its value
    dut.DATA_IN.value = 0
    dut.ADDR.value = 1
    dut.WRITE.value = 0

    # Wait one more cycle for the ADDR change to take effect
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DATA_OUT.value == 0x3E, f"Expected 0x3E but got {hex(dut.DATA_OUT.value)}"
    assert dut.ADDR.value == 1, f"Expected 1 but got {dut.ADDR.value}"
    assert dut.WRITE.value == 0, f"Expected 0 but got {dut.WRITE.value}"

@cocotb.test()
async def test_RAM_write_addr_31_with_0xAA_then_readback(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit

    # Read RAM[1] and assert its value
    dut.DATA_IN.value = 0xAA
    dut.ADDR.value = 31
    dut.WRITE.value = 1

    # Wait one more cycle for the ADDR change and WRITE to take effect
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.ADDR.value == 31, f"Expected 31 but got {dut.ADDR.value}"
    assert dut.WRITE.value == 1, f"Expected 1 but got {dut.WRITE.value}"

    dut.WRITE.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.DATA_OUT.value == 0xAA, f"Expected 0xAA but got {hex(dut.DATA_OUT.value)}"
    assert dut.ADDR.value == 31, f"Expected 31 but got {dut.ADDR.value}"
    assert dut.WRITE.value == 0, f"Expected 0 but got {dut.WRITE.value}"