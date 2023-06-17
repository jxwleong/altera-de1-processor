iverilog -o Combined_TB_out ..\..\CombinedCUnDP_TB.v ..\..\CombinedCUnDP.v ..\..\DP.v ..\..\CU.v ..\..\mux2to1.v ..\..\mux4to1.v ..\..\DFF_reg.v ..\..\RAM.v ..\..\addSubstractor.v
vvp.exe Combined_TB_out
gtkwave waveform.vcd