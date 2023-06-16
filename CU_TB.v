module CU_tb();

    reg clock, reset, Enter, Aeq0, Apos;
    reg [2:0] IR;

    wire IRLoad, JMPmux, PCload, Meminst, MemWr, Aload, Sub, Halt;
    wire [1:0] Asel;

    CU inst1(
        // Output
        .IRload(IRLoad),
        .JMPmux(JMPmux),
        .PCload(PCload),
        .Meminst(Meminst),
        .MemWr(MemWr),
        .Aload(Aload),
        .Sub(Sub),
        .Halt(Halt),
        .Asel(Asel),

        // Input
        .clock(clock),
        .reset(reset),
        .Enter(Enter),
        .Aeq0(Aeq0),
        .Apos(Apos),
        .IR(IR)
    );

    // For Debug only..
    always @(posedge clock)
        $display("At time %t, IRLoad = %b", $time, IRLoad);

    // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, CU_tb);
    end

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end 


    initial begin
        // This should init all input to 0 at state "start"
        // Reset=0, we should at start state
        Enter = 0;
        reset = 0;
        #10;

        // Remove the reset and wait awhile
        // At next rising edge, we should be at fetch state
        reset = 1;
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "load" state by setting [2:0] IR = 3'b000
        #10;
        IR[2:0] = 3'b000;
        #10;

        // After this time should be "start"
        #10;
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "store" state by setting [2:0] IR = 3'b001
        #10;
        IR[2:0] = 3'b001;
        #10;

        // After this time should be "start"
        #10;
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "input" state by setting [2:0] IR = 3'b100
        #10;
        IR[2:0] = 3'b100;
        Enter = 1;      // Needed to transition to next state, else it will keep at the same state
        #10;

        // After this time should be "start"
        #10;
        Enter = 0;      // Reset Enter
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "add" state by setting [2:0] IR = 3'b010
        #10;
        IR[2:0] = 3'b010;
        #10;

        // After this time should be "start"
        #10;
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "sub" state by setting [2:0] IR = 3'b011
        #10;
        IR[2:0] = 3'b011;
        #10;

        // After this time should be "start"
        #10;
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "jz" state by setting [2:0] IR = 3'b101
        #10;
        IR[2:0] = 3'b101;
        #10;

        // After this time should be "start"
        #10;
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "jpos" state by setting [2:0] IR = 3'b110
        #10;
        IR[2:0] = 3'b110;
        #10;


        // After this time should be "start"
        #10;
        // After this will be "fetch" state
        #10;

        // Now we should be at decode state, for next rising edge
        // Lets make it goto "halt" state by setting [2:0] IR = 3'b111
        #10;
        IR[2:0] = 3'b111;
        #10;

        // We should be back to "start" state by now
        reset = 0;
        #10;

        $finish;
    end 
endmodule