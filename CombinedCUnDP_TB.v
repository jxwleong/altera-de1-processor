// This is the fully integrated top module of the processor
module CombinedCUnDP_tb();

    reg clock, reset, enter;
    reg [7:0] dataIn;

    wire Halt;
    wire [2:0] IR;
    wire [7:0] dataOut;

    integer X, Y;


    CombinedCUnDP microprocessor(
        // INPUT
        .dataIn(dataIn),
        .clock(clock),
        .reset(reset),
        .enter(enter),

        // OUTPUT
        .Halt(Halt),
        .IR(IR),
        .dataOut(dataOut)
    );

    // Init Clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end 

    // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, CombinedCUnDP_tb);
    end


    task trigger_reset; 
        begin
            reset = 0; // reset signal starts low
            #10; 
            reset = 1; // set reset high
        end
    endtask

    task processor_init;
        begin 
            enter <= 0; // enter signal starts low
            dataIn <= 8'd0; // input data starts as 0
        end 
    endtask


    // Monitor halt signal and display GCD when halt is high
    always @ (Halt) begin
        if(Halt) begin
            $display("THE GCD OF %d(X) & %d(Y) is: %d \n", X, Y, dataOut);
            $finish;
        end 
    end



    
    initial begin
        X = 8'd51;
        Y = 8'd22;

        processor_init;
        trigger_reset;

        dataIn = X; 
        $display("INPUT FOR X: %d\n", dataIn); 
        #30 enter = 1; // set enter high to indicate dataIn is ready
        #30 enter = 0; 

        dataIn = Y; 
        $display("INPUT FOR Y: %d\n", dataIn); 
        #30 enter = 1; // set enter high to indicate dataIn is ready
        #30 enter = 0; 

    end 

        // Simulate input of X and Y values
        /*
	initial
        begin
            processor_init;
            trigger_reset;
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
        end*/

endmodule 