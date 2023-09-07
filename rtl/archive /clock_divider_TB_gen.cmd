iverilog -o clock_divider_TB_out clock_divider_TB.v clock_divider.v   
vvp.exe clock_divider_TB_out
gtkwave waveform.vcd