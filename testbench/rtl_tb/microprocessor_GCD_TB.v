module microprocessor_GCD_TB();
	reg clock, reset, enter;
	reg [7:0] dataIn;
	wire halt;
	wire [2:0] IR;
	wire [7:0] dataOut;
	
	integer X, Y;
	
	//Generate clock pulse
	initial begin
		clock =  0;
		forever #2 clock =  ~clock; // clock signal toggles every 2 time units
	end

    // Generate reset signal
    initial begin
        reset <= 0; // reset signal starts low
        @(posedge clock); // wait for positive edge of clock
        @(negedge clock) reset = 1; // set reset high on negative edge of clock
    end

    // Initialize enter and dataIn signals
    initial begin
        enter <= 0; // enter signal starts low
        dataIn <= 8'd0; // input data starts as 0
    end
    
    // Simulate input of X and Y values
	initial
        begin
            #12 dataIn = 8'd50; // 12 time units in, set dataIn as 50 (X value)
            $display("INPUT FOR X: %d\n", dataIn); 
            X = dataIn;     
            #10 enter = 1; // 10 time units later, set enter high to indicate dataIn is ready
            #4 enter = 0; // 4 time units later, set enter back to low
            #26 dataIn = 8'd17; // 26 time units later, set dataIn as 17 (Y value)
            $display("INPUT FOR Y: %d\n", dataIn);
            Y = dataIn;
            #10 enter = 1; // 10 time units later, set enter high
            #4 enter = 0; // 4 time units later, set enter back to low
        end
    
    // Monitor X and Y values
    always @(X or Y) begin
        // Nothing is done here in the original code
    end   
   
    // Monitor halt signal and display GCD when halt is high
    always @ (halt) begin
        if(halt)
            $display("THE GCD OF %d(X) & %d(Y) is: %d \n",X,Y,dataOut);
    end

    // Instantiate the microprocessor module
    CombinedCUnDP microprocessor(dataIn, clock, reset, enter, dataOut, halt, IR);
endmodule 
