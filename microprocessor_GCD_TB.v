module microprocessor_GCD_TB();
	reg clock, reset, enter;
	reg [7:0] dataIn;

	wire halt;
	wire [2:0] IR;
	wire [7:0] dataOut;
	
	integer X, Y;
	
	/*Generate clock pulse*/
initial begin
	clock =  0;
	forever #2 clock =  ~clock;
end

  initial begin
    reset <= 0;
    @(posedge clock);
    @(negedge clock) reset = 1;
  end

  initial begin
    enter <= 0;
    dataIn <= 8'd0;
  end
    
initial
    begin
      #12 dataIn = 8'd50;
      $display("INPUT FOR X: %d\n", dataIn);
      X = dataIn;     
      #10 enter = 1;
      #4 enter = 0;
      #26 dataIn = 8'd17;
      $display("INPUT FOR Y: %d\n", dataIn);
      Y = dataIn;
      #10 enter = 1;
      #4 enter = 0;
    end
    
 always @(X or Y) begin
  
  end   
 always @ (halt) begin
    if(halt)
      $display("THE GCD OF %d(X) & %d(Y) is: %d \n",X,Y,dataOut);
  end
  
  CombinedCUnDP microprocessor(dataIn, clock, reset, enter, dataOut, halt, IR);
 endmodule 