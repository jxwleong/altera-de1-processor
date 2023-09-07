module clock_divider(clk_50MHz,reset,
		clk_1Hz);
		

// Altera DE1 clock is 50 MHz
// This module is used to generaete 1 second clock
input clk_50MHz,reset;
output reg clk_1Hz;		
integer count;

always @ (posedge clk_50MHz, negedge reset) // KEY neg toggle
 if (~reset)   //reset
	begin
		count <= 32'd0;
		clk_1Hz <= 1'b0;
	end

else // if NO reset
	
	if (count == 25000000) // half cycle toggle once
	begin
		clk_1Hz  <= ~clk_1Hz;   // toggle slow clk_50MHz
		count <= 32'd0;	// clear counter
	end
	 
	else // if count does not reach 25 million
	begin
		clk_1Hz <= clk_1Hz;  	 // hold previos value
		count <= count + 1'd1;
	end
	 
endmodule
