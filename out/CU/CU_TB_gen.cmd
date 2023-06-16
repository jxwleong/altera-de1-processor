iverilog -o CU_TB_out ..\..\CU_TB.v ..\..\CU.v   
vvp.exe CU_TB_out
gtkwave waveform.vcd