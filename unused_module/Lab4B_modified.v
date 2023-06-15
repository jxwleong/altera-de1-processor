module Lab4B_modified(Clock,reset,
		oneHz);
		
		
input Clock,reset;
output reg oneHz;		
integer count;

always @ (posedge Clock, negedge reset) // KEY neg toggle
 if (~reset)   //reset
	begin
	count <= 32'd0;
	oneHz <= 1'b0;
	end

else // if NO reset
	
	if (count == 2500000) // half cycle toggle once
	 begin
	  oneHz  <= ~oneHz;   // toggle slow clock
	  
	  count <= 32'd0;	// clear counter
	 end
	 
	else // if count does not reach 25 million
	 begin
	 oneHz <= oneHz;  	 // hold previos value
	 
	 count <= count + 1'd1;
	 end
	 
	
	 
endmodule
