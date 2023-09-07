module BCD_decoder_modified(Count,							// Display output 0-9 with 4 bits binary input using case								
		 Output);
				
				
	input [3:0] Count;
	integer i; 
	output reg [0:6]Output;	
			

always @ (Count)				
// 0-a, 1-b, 2-c, 3-d, 4-e, 5-f, 6-g
	case (Count)
	4'b0000 : Output[0:6] = 7'b0000001;
	4'b0001 : Output[0:6] = 7'b1001111;
	4'b0010 : Output[0:6] = 7'b0010010;
	4'b0011 : Output[0:6] = 7'b0000110;
	4'b0100 : Output[0:6] = 7'b1001100;
	4'b0101 : Output[0:6] = 7'b0100100;
	4'b0110 : Output[0:6] = 7'b0100000;
	4'b0111 : Output[0:6] = 7'b0001111;
	4'b1000 : Output[0:6] = 7'b0000000;
	4'b1001 : Output[0:6] = 7'b0001100;
	
	//Aplhabets (A - F)
	4'b1010 : Output[0:6] = 7'b0001000;		
	4'b1011 : Output[0:6] = 7'b1100000;
	4'b1100 : Output[0:6] = 7'b0110001;
	4'b1101 : Output[0:6] = 7'b1000010;
	4'b1110 : Output[0:6] = 7'b0110000;
	4'b1111 : Output[0:6] = 7'b0111000;
	endcase
	
	
endmodule


