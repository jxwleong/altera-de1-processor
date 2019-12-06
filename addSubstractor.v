module addSubstractor(sub,A, B, out);
	input sub;
	input [7:0] A, B;
	output reg [8:0] out;
	
	always @(sub or A or B)
	begin
		if(sub)
			out = A - B;
		else
			out = A + B;
	end
endmodule	