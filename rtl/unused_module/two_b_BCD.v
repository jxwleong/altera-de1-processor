module two_b_BCD(
		input CLOCK_50, 				//50 MHZ clock
		input [0:0] KEY,				// reset
		output [0:6]HEX0,
		output [0:6]HEX1		
						);
		reg [3:0]counter;			// for HEX0
		reg [3:0]counter2;			// for HEX1
		reg [3:0]cycles;
		wire clock_clk_1Hz;				
		
		clock_divider clk_1HzClock (CLOCK_50,KEY,clock_clk_1Hz);
		BCD_decoder_modified seven_seg1 (counter,HEX0);
		BCD_decoder_modified seven_seg2 (counter2,HEX1);

		
always@(posedge clock_clk_1Hz, negedge KEY)
		
		if (~KEY)   //reset
		begin
		counter <= 4'd0;
		counter2 <= 4'd0;
		end
		
		else // no reset
		 if(counter <4'd9)			// increment of counter from '0' - '9'
			begin
			counter <= counter + 1'd1;
		    counter2 <= counter2;
		    end
		 else
			begin
		     counter <= 0;
			if(counter2< 4'd9)			// increment of counter2 from '0' - '9'
			 counter2 <= counter2 +1'd1; // by one when counter become '0'
			else
			 counter2 <= 0;               
			end							

endmodule
