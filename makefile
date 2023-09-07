# Makefile
THIS_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES	+= $(THIS_DIR)/CombinedCUnDP.v
VERILOG_SOURCES += $(THIS_DIR)/CU.v
VERILOG_SOURCES += $(THIS_DIR)/DP.v

VERILOG_SOURCES += $(THIS_DIR)/DFF_reg.v
VERILOG_SOURCES += $(THIS_DIR)/RAM.v
VERILOG_SOURCES += $(THIS_DIR)/addSubstractor.v
VERILOG_SOURCES += $(THIS_DIR)/mux2to1.v
VERILOG_SOURCES += $(THIS_DIR)/mux4to1.v
# use VHDL_SOURCES for VHDL files


# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim


# Custom targets for individual tests
# .PHONY ensures these targets are always executed, 
# even if a file with the same name exists.

.PHONY:	all test1 cleanup

all: test_microprocessor cleanup

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file
test_microprocessor:
	$(info Running test_microprocessor...)
	TOPLEVEL=CombinedCUnDP \
	MODULE=test.test_microprocessor \
	$(MAKE) sim


cleanup:
	$(RM) -r sim_build/ results.xml