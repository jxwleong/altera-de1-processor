# Determine the directory containing this makefile and root directory
MAKEFILE_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
ROOT_DIR := $(realpath $(dir $(MAKEFILE_DIR))/../../)


# Directories
RTL_DIR = $(ROOT_DIR)/rtl
TB_DIR = $(ROOT_DIR)/testbench/rtl_tb
OUT_DIR = $(TB_DIR)/out

# Create the OUT_DIR if it doesn't exist
$(shell mkdir -p $(OUT_DIR))

# Define the simulator
SIM = iverilog
SIM_FLAGS = -o

# Define the VVP (Icarus Verilog runtime engine) for simulation execution
VVP = vvp

# All the testbenches
TESTBENCHES = $(TB_DIR)/CU_TB.v $(TB_DIR)/CombinedCUnDP_TB.v $(TB_DIR)/DFF_reg_TB.v $(TB_DIR)/DP_TB.v $(TB_DIR)/RAM_TB.v $(TB_DIR)/addSubstractor_TB.v $(TB_DIR)/mux2to1_TB.v $(TB_DIR)/mux4to1_TB.v

# Print the DIR directly in the Makefile
$(info MAKEFILE_DIR: $(MAKEFILE_DIR))
$(info ROOT_DIR: $(ROOT_DIR))


all: $(TESTBENCHES)
    # $^: All prerequisites of the target.
    # $$tb: Escaping $ to use shell variable tb.
	for tb in $^ ; do \
        OUTFILE=$(OUT_DIR)/$$(basename $$tb .v).out ; \
		TB_NAME=$$(basename $$tb .v) ; \
        echo "\nRunning Testbench: $$TB_NAME" ; \
		VCD_FILE=$(OUT_DIR)/$$TB_NAME.vcd ; \
        $(SIM) $(SIM_FLAGS) $$OUTFILE $(RTL_DIR)/*.v $$tb ; \
        $(VVP) $$OUTFILE ; \
		mv $(CURDIR)/waveform.vcd $$VCD_FILE ; \
		echo "Waveform: $$VCD_FILE" ; \
    done


clean:
	rm -vrf $(OUT_DIR)/*

