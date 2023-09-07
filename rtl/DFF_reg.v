module DFF_reg	#(parameter size = 1)(Q, load, clear, clock, D);
	output reg [size -1 :0]Q;
	input clock, load, clear;
	input [size -1 :0]D;
	
always @ (posedge clock, negedge clear)
	 if(~clear)
		Q <= 0;
	 else if(load)	
		Q <= D;
	 else
		Q <= Q;
		
endmodule