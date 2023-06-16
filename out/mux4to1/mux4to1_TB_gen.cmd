iverilog -o mux4to1_TB_out ..\..\mux4to1_TB.v ..\..\mux4to1.v   
vvp.exe mux4to1_TB_out
gtkwave waveform.vcd