# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES	+= $(PWD)/CombinedCUnDP.v
VERILOG_SOURCES += $(PWD)/CU.v
VERILOG_SOURCES += $(PWD)/DP.v

VERILOG_SOURCES += $(PWD)/DFF_reg.v
VERILOG_SOURCES += $(PWD)/RAM.v
VERILOG_SOURCES += $(PWD)/addSubstractor.v
VERILOG_SOURCES += $(PWD)/mux2to1.v
VERILOG_SOURCES += $(PWD)/mux4to1.v
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = CombinedCUnDP

# MODULE is the basename of the Python test file
MODULE = test_microprocessor

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim