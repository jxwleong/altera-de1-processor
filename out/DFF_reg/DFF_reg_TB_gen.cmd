iverilog -o DFF_reg_TB_out DFF_reg_TB.v DFF_reg.v   
vvp.exe DFF_reg_TB_out
gtkwave waveform.vcd