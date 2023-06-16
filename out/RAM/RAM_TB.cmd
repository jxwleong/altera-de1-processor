iverilog -o RAM_TB_out ..\..\RAM_TB.v ..\..\RAM.v   
vvp.exe RAM_TB_out
gtkwave waveform.vcd