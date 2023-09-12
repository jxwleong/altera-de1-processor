""" 
STATE encoding
    start = 4'b0000, fetch = 4'b0001, decode = 4'b0010, 
    load = 4'b1000, store = 4'b1001, add = 4'b1010, sub = 4'b1011,
    Input = 4'b1100, jz = 4'b1101, jpos = 4'b1110, halt = 4'b1111;
"""
import json
import cocotb
from cocotb.triggers import Event, RisingEdge, FallingEdge, Timer

state = {
    "start": 0b0000,
    "fetch": 0b0001,
    "decode": 0b0010,
    "load": 0b1000,
    "store": 0b1001,
    "add": 0b1010,
    "sub": 0b1011,
    "input": 0b1100,
    "jz": 0b1101,
    "jpos": 0b1110,
    "halt": 0b1111
}

def get_key_from_value(my_dict, search_value):
    for key, value in my_dict.items():
        if value == search_value:
            return key
    return None  # Return None if the value is not found in the dictionary

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
    dut.Enter.value  = 0
    dut.Aeq0.value  = 0
    dut.Apos.value = 0
    await Timer(1, units="ns")


def print_signal_values(dut):
    signal_values = []
    # List of signals to print
    signals_to_print = [
        "IRload",
        "JMPmux",
        "PCload",
        "Meminst",
        "MemWr",
        "Aload",
        "Sub",
        "state",
        "nextState",
        "Asel",
        "Halt"
    ]

    # Print the values of the specified signals
    for signal_name in signals_to_print:
        signal = getattr(dut, signal_name)
        if "state" in signal_name.lower():
            state_label = get_key_from_value(state, signal.value)
            signal_values.append(f"{signal_name}: {state_label}({signal.value})")
        else:
            signal_values.append(f"{signal_name}: {signal.value}")

    dut._log.info(", ".join(signal_values))


@cocotb.test()
async def test_CU_full_flow(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    await initialize(dut)  # Call the initialization function
    
    dut._log.info("Initialization DONE!")
    await Timer(5, units="ns")  # wait a bit
    dut._log.info("State Label:")
    dut._log.info(json.dumps(state, indent="\t"))

    # Testing flow from start to STORE, INPUT
    # Reset to 'start' state
    dut.reset.value  = 0
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 0, f"Expected 0 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["start"], f"Expected {state['start']} but got {dut.state.value}"
    assert dut.nextState.value == state["fetch"], f"Expected {state['fetch']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)
    
    # Go to 'fetch' state
    dut.reset.value  = 1
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 1, f"Expected 1 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 1, f"Expected 1 but got {dut.PCload.value}"
    assert dut.Meminst.value == 0, f"Expected 0 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["fetch"], f"Expected {state['fetch']} but got {dut.state.value}"
    assert dut.nextState.value == state["decode"], f"Expected {state['decode']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)

    # 'decode' state
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 1, f"Expected 1 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    # nextState=decode because no IR value is inserted.
    assert dut.state.value == state["decode"], f"Expected {state['decode']} but got {dut.state.value}"
    assert dut.nextState.value == state["decode"], f"Expected {state['decode']}  but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)

    # 'store' state
    dut.IR.value = 0b001
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 1, f"Expected 1 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 1, f"Expected 1 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["store"], f"Expected {state['store']} but got {dut.state.value}"
    assert dut.nextState.value == state["start"], f"Expected {state['start']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)

    # Back to 'start' state
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 0, f"Expected 0 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["start"], f"Expected {state['start']} but got {dut.state.value}"
    assert dut.nextState.value == state["fetch"], f"Expected {state['fetch']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)

    # Go to 'fetch' state
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 1, f"Expected 1 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 1, f"Expected 1 but got {dut.PCload.value}"
    assert dut.Meminst.value == 0, f"Expected 0 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["fetch"], f"Expected {state['fetch']} but got {dut.state.value}"
    assert dut.nextState.value == state["decode"], f"Expected {state['decode']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)

    # 'decode' state
    dut.IR.value = 0b100
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 1, f"Expected 1 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["decode"], f"Expected {state['decode']} but got {dut.state.value}"
    assert dut.nextState.value == state["input"], f"Expected {state['input']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)


    # 'input' state
    # Enter=0, stuck at 'input' state
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 0, f"Expected 0 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 1, f"Expected 1 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["input"], f"Expected {state['input']} but got {dut.state.value}"
    assert dut.nextState.value == state["input"], f"Expected {state['input']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b01, f"Expected 2'b01 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)

    # Enter=1, go to 'start' state
    dut.Enter.value = 0b1
    await RisingEdge(dut.clock)
    await RisingEdge(dut.clock)
    assert dut.IRload.value == 0, f"Expected 0 but got {dut.IRload.value}"
    assert dut.JMPmux.value == 0, f"Expected 0 but got {dut.JMPmux.value}"
    assert dut.PCload.value == 0, f"Expected 0 but got {dut.PCload.value}"
    assert dut.Meminst.value == 0, f"Expected 0 but got {dut.Meminst.value}"
    assert dut.MemWr.value == 0, f"Expected 0 but got {dut.MemWr.value}"
    assert dut.Aload.value == 0, f"Expected 0 but got {dut.Aload.value}"
    assert dut.Sub.value == 0, f"Expected 0 but got {dut.Sub.value}"

    assert dut.state.value == state["start"], f"Expected {state['start']} but got {dut.state.value}"
    assert dut.nextState.value == state["fetch"], f"Expected {state['fetch']} but got {dut.nextState.value}"
    assert dut.Asel.value == 0b00, f"Expected 2'b00 but got {dut.Asel.value}"
    assert dut.Halt.value == 0b0, f"Expected 0 but got {dut.Halt.value}"
    print_signal_values(dut)
    dut.Enter.value = 0b0