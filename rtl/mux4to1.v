module mux4to1 #(parameter size = 4)(input S0, S1, input [size - 1 : 0] i0, i1, i2, i3, output [size - 1 : 0] out);

assign out = (({S1, S0} == 2'b00) ? i0 :
			  ({S1, S0} == 2'b01) ? i1 :
			  ({S1, S0} == 2'b10) ? i2 :
			  i3);
			  

endmodule
