module RAM #(parameter RAM_LOCATIONS = 16, 	parameter RAM_BITS = 4)(input [RAM_BITS - 1:0] DATA_IN, input [4:0] ADDR, input WRITE, clk, output reg[RAM_BITS - 1:0] DATA_OUT);
	

	
	reg [RAM_BITS - 1: 0] RAM [RAM_LOCATIONS - 1:0];
		//Program to calculate the GCD of 2 numbers
	initial begin
		RAM[0]  = 8'b10000000;
		RAM[1]  = 8'b00111110;
		RAM[2]  = 8'b10000000;
		RAM[3]  = 8'b00111111;
		RAM[4]  = 8'b00011110;
		RAM[5]  = 8'b01111111;
		RAM[6]  = 8'b10110000;
		RAM[7]  = 8'b11001100;
		RAM[8]  = 8'b00011111;
		RAM[9]  = 8'b01111110;
		RAM[10] = 8'b00111111;
		RAM[11] = 8'b11000100;	
		RAM[12] = 8'b00011110;
		RAM[13] = 8'b01111111;
		RAM[14] = 8'b00111110;
		RAM[15] = 8'b11000100;
		RAM[16] = 8'b00011110;
		RAM[17] = 8'b11111111;
		RAM[30] = 8'b00000000;
		RAM[31] = 8'b00000000;
	end	
	
	/*
	initial 
	begin
	RAM[0] = 8'b10000000;
	RAM[1] = 8'b01111111;
	RAM[2] = 8'b10100100;
	RAM[3] = 8'b11000001;
	RAM[4] = 8'b11111111;
	RAM[31]= 8'b00000001;
	end
	*/
	always@(posedge clk)
	    if(WRITE)
			RAM[ADDR] <= DATA_IN;
		else
			DATA_OUT <= RAM[ADDR];
			
endmodule			