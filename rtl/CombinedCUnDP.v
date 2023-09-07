module CombinedCUnDP(input [7:0]dataIn, input clock, input reset, input enter, output [7:0]dataOut, output Halt, output wire [2:0]IR);

wire IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub, Aeq0, Apos;
wire [1:0] Asel;

CU controlUnit(IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub, Halt, Asel,
		  clock, reset, enter, Aeq0, Apos,
		  IR
		  );
		  
DP dataPath(IRload, JMPmux, PCload, Meminst, MemWr, Aload, reset, clock , Sub, 
		  Asel, dataIn, dataOut ,IR, Aeq0, Apos);

endmodule