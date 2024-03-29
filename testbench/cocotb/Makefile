# Makefile
# Determine the directory containing this makefile and root directory
MAKEFILE_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
ROOT_DIR := $(realpath $(dir $(MAKEFILE_DIR))/../../)
RTL_DIR := $(ROOT_DIR)/rtl

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# Custom targets for individual tests
# .PHONY ensures these targets are always executed, 
# even if a file with the same name exists.
.PHONY:	all	\
		test_microprocessor	\
		test_mux2to1	\
		test_mux4to1 	\
		test_DFF_reg	\
		test_addSubtractor	\
		test_RAM	\
		test_CU		\
		cleanup

all:	test_microprocessor  \
		test_mux2to1 	\
		test_mux4to1	\
		test_DFF_reg	\
		test_addSubtractor	\
		test_RAM	\
		test_CU		\
		cleanup		

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file
# use VHDL_SOURCES instead VERILOG_SOURCES of for VHDL files
#Paths to HDL source files
VERILOG_SOURCES	+= $(RTL_DIR)/CombinedCUnDP.v
VERILOG_SOURCES += $(RTL_DIR)/CU.v
VERILOG_SOURCES += $(RTL_DIR)/DP.v

VERILOG_SOURCES += $(RTL_DIR)/DFF_reg.v
VERILOG_SOURCES += $(RTL_DIR)/RAM.v
VERILOG_SOURCES += $(RTL_DIR)/addSubstractor.v
VERILOG_SOURCES += $(RTL_DIR)/mux2to1.v
VERILOG_SOURCES += $(RTL_DIR)/mux4to1.v


test_microprocessor:
	$(MAKE) cleanup
	$(info Running test_microprocessor...)
	$(eval TOPLEVEL := CombinedCUnDP)
	$(eval MODULE := test_microprocessor)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"

test_mux2to1:
	$(MAKE) cleanup
	$(info Running test_mux2to1...)
	$(eval TOPLEVEL := mux2to1)
	$(eval MODULE := test_mux2to1)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"

test_mux4to1:
	$(MAKE) cleanup
	$(info Running test_mux4to1...)
	$(eval TOPLEVEL := mux4to1)
	$(eval MODULE := test_mux4to1)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"

test_DFF_reg:
	$(MAKE) cleanup
	$(info Running test_DFF_reg...)
	$(eval TOPLEVEL := DFF_reg)
	$(eval MODULE := test_DFF_reg)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"

test_addSubtractor:
	$(MAKE) cleanup
	$(info Running test_addSubtractor...)
	$(eval TOPLEVEL := addSubstractor)
	$(eval MODULE := test_addSubtractor)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"

test_RAM:
	$(MAKE) cleanup
	$(info Running test_RAM...)
	$(eval TOPLEVEL := RAM)
	$(eval MODULE := test_RAM)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"

test_CU:
	$(MAKE) cleanup
	$(info Running test_CU...)
	$(eval TOPLEVEL := CU)
	$(eval MODULE := test_CU)

	@echo "TOPLEVEL=$(TOPLEVEL)"
	@echo "MODULE=$(MODULE)"
	@echo "VERILOG_SOURCES=$(VERILOG_SOURCES)"
	$(MAKE) sim TOPLEVEL=$(TOPLEVEL) MODULE=$(MODULE) VERILOG_SOURCES="$(VERILOG_SOURCES)"


cleanup:
	$(info Cleaning up generated files...)
	$(RM) -vf *.vvp sim_build/* results.xml
	$(RM) -rf sim_build


