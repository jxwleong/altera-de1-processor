iverilog -o addSubstractor_TB_out addSubstractor_TB.v addSubstractor.v   
vvp.exe addSubstractor_TB_out
gtkwave waveform.vcd