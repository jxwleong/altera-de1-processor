# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VHDL_SOURCES  += $(PWD)/CombinedCUnDP.v
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = CombinedCUnDP

# MODULE is the basename of the Python test file
MODULE = test_microprocessor

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim