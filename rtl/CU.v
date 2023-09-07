module CU(
	output reg IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub, Halt,
	output reg [1:0] Asel,
	input clock, reset, Enter, Aeq0, Apos,
	input [2:0] IR
);

reg [3:0] state, nextState;

// Define states with readable names
parameter start = 4'b0000, fetch = 4'b0001, decode = 4'b0010, 
		  load = 4'b1000, store = 4'b1001, add = 4'b1010, sub = 4'b1011,
		  Input = 4'b1100, jz = 4'b1101, jpos = 4'b1110, halt = 4'b1111;


// State transition block  
always @(posedge clock, negedge reset)
begin
	if(~reset)
	state <= start;	// Reset state to start if reset signal is active
	else
	state <= nextState;	// GO to next state
end


always @(state, Enter, IR)
	case (state)
	start	: begin
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000000;			  
			  Asel[1:0] = 2'b00;
			  Halt = 1'b0;
			  nextState = fetch;
			  end
			  
	fetch	: begin
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b1010000;
			  Asel[1:0] = 2'b00;
			  Halt = 1'b0;	
			  nextState = decode;
			  end
	
	decode	:begin
			{IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b00001000; 
			Asel[1:0] = 2'b00;
			Halt = 1'b0;
				case (IR)
					3'b000 :	nextState = load;	
					3'b001 :	nextState = store;	
					3'b010 :	nextState = add;				
					3'b011 :	nextState = sub;		
					3'b100 :	nextState = Input;								
					3'b101 :	nextState = jz;					
					3'b110 :	nextState = jpos;
					3'b111 :	nextState = halt;			
					default :	nextState = decode;							
				endcase
			end
	load	: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b10;
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000010;
			  nextState = start;
			  end		
	
	store	: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b00;
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0001100;
			  nextState = start;
			  end	
			  
	add		: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b00;
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000010;
			  nextState = start;
			  end	
			  
	sub		: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b00;
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000011;
			  nextState = start;
			  end	
			  	
	Input	: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b01;
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000010;
			  if(~Enter)
				nextState = Input;
			  else
				nextState = start;
			  end
			  	
	jz		: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b00;
			  {IRload, JMPmux, Meminst, MemWr, Aload, Sub} = 6'b010000;
			  PCload = Aeq0;
			  nextState = start;
			  end	
			  
	jpos	: begin
			  Halt = 1'b0;
			  Asel[1:0] = 2'b00;
			  {IRload, JMPmux, Meminst, MemWr, Aload, Sub} = 6'b010000;
			  PCload = Apos;
			  nextState = start;
			  end	
			  
	halt	: begin
			  Halt = 1'b1;
			  Asel[1:0] = 2'b00;
			  {IRload, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000000;
			  nextState = halt;
			  end		  
	endcase
			  			  			  			  			  		  			  			  								
endmodule