module	mux2to1 #(parameter size = 2)(input S0, input[size - 1 :0] i1, i0, output [size - 1 :0] out);
		
	assign out = (S0 == 0)? i0 :i1 ;	
endmodule		