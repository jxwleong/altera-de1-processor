iverilog -o DP_TB_out DP_TB.v DP.v mux2to1.v mux4to1.v DFF_reg.v RAM.v addSubstractor.v
vvp.exe DP_TB_out
gtkwave waveform.vcd