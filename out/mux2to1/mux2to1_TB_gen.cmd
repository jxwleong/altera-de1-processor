iverilog -o mux2to1_TB_out mux2to1_TB.v mux2to1.v   
vvp.exe mux2to1_TB_out
gtkwave waveform.vcd