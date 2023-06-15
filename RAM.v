module RAM #(parameter RAM_LOCATIONS = 32, 	parameter RAM_BITS = 8)(input [RAM_BITS - 1:0] DATA_IN, input [4:0] ADDR, input WRITE, clk, output reg[RAM_BITS - 1:0] DATA_OUT);
	

	
	reg [RAM_BITS - 1: 0] RAM [RAM_LOCATIONS - 1:0];
		//Program to calculate the GCD of 2 numbers
	initial begin
		RAM[0]  = 8'b10000000;	// IN A
		RAM[1]  = 8'b00111110;	// STORE A into address 11110
		RAM[2]  = 8'b10000000;	// IN A
		RAM[3]  = 8'b00111111;  // STORE A into address 11111
		RAM[4]  = 8'b00011110;	// LOAD Content of 11110 to A (Load first A to A)
		RAM[5]  = 8'b01111111;	// SUB A with Content of 11111 (First A - Second A)
		RAM[6]  = 8'b10110000;  // JUMP to 10000[0] if A equals 0
		RAM[7]  = 8'b11001100;  // JUMP to 01100[12] if A equals positive (First A > Second A)
		RAM[8]  = 8'b00011111;  // STORE A into address 11111
		RAM[9]  = 8'b01111110;	// SUB A with Content of 11110
		RAM[10] = 8'b00111111;  // STORE A into address 11111
		RAM[11] = 8'b11000100;	// JUMP to 01100 if A equals positive
		RAM[12] = 8'b00011110;  // STORE A into address 11110 (Store subtracted A back to original first A location)
		RAM[13] = 8'b01111111;	// SUB A with Content of 11111 (Second A - subtracted A)

		RAM[14] = 8'b00111110;  // STORE A into address 11110
		RAM[15] = 8'b11000100;	// JUMP to 00100 if A equals positive
		RAM[16] = 8'b00011110;	// LOAD Content of 11110 to A
		RAM[17] = 8'b11111111;  // HALT
		RAM[30] = 8'b00000000;
		RAM[31] = 8'b00000000;
	end	
	
	// PC Count	: Instruction code: Desc
	//  00000	: 100 00000; -- INPUT A
	//  00001	: 001 11110; -- STORE A -> 11110
	//  00010	: 100 00000; -- INPUT A
	//  00011	: 001 11111; -- STORE A -> 11111
	//  00100	: 000 11110; -- LOAD (11110) -> A
	//  00101	: 011 11111; -- A = A - (11111)
	//  00110	: 101 10000; -- JUMP to PC (10000) if A = 0
	//  00111	: 110 01100; -- JUMP to PC (01100) if A = +ve
	//	01000	: 000 11111; -- STORE A -> 11111
	//  01001	: 011 11110; -- A = A - (11110)  
	//  01010	: 001 11111; -- STORE A -> 11111
	//  01011	: 110 00100; -- JUMP to PC (01100) if A = +ve
	//  01100	: 000 11110; -- STORE A -> 11110
	//  01101	: 011 11111; -- A = A - 11111
	//  01110   : 001 11110; -- STORE A -> 11110
	//  01111   : 110 00100; -- JUMP to PC (00100) if A = +ve
	//  10000	: 000 11110; -- LOAD (11110) -> A
	//  10001	: 111 11111; -- HALT    
	   
	/*	Exampel from Lab Manual
	initial 
	begin
	RAM[0] = 8'b10000000; -- INPUT A
	RAM[1] = 8'b01111111; -- A = A - (11111)
	RAM[2] = 8'b10100100; -- JUMP to PC (00100) if A = 0
	RAM[3] = 8'b11000001; -- JUMP to PC (00001) if A = +ve
	RAM[4] = 8'b11111111; -- HALT
	RAM[31]= 8'b00000001; -- CONSTANT 1
	end
	*/
	always@(posedge clk)
	    if(WRITE)
			RAM[ADDR] <= DATA_IN;
		else
			DATA_OUT <= RAM[ADDR];
			
endmodule			