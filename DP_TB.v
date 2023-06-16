module DP_tb();

    reg IRLoad, JMPmux, PCload, Meminst, MemWr, Aload, Reset, Clock, Sub;
    reg [1:0] Asel;
    reg [7:0] INPUT;

    wire Aeq0, Apos;
    wire [2:0] IR;
    wire [7:0] OUTPUT;

    DP inst1 (
        // Declare Input
        .IRload(IRLoad),
        .JMPmux(JMPmux),
        .PCload(PCload),
        .Meminst(Meminst),
        .MemWr(MemWr),
        .Aload(Aload),
        .Reset(Reset),
        .Clock(Clock),
        .Sub(Sub),

        // Declare output
        .Aeq0(Aeq0),
        .Apos(Apos),
        .IR(IR),
        .OUTPUT(OUTPUT)
    );

    // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, DP_tb);
    end

    // Generate Clock
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end 


    initial begin
        // Intialize all inputs to be 0
        IRLoad = 1'b0;
        JMPmux = 1'b0;
        PCload = 1'b0; 
        Meminst = 1'b0;
        MemWr = 1'b0; 
        Aload = 1'b0; 
        Reset = 1'b0; 
        Clock = 1'b0; 
        Sub = 1'b0;

        Asel = 2'b0;
        INPUT = 8'b0;
        #10;

        /*
        We're going to mimic the behavior of the actual program

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
        */

        // First, we simulate the Load and Store instruction
        // 1. INPUT A
        Asel = 2'b10;
        Aload = 1'b1;
        INPUT = 8'd8;
        #10;

        Asel = 2'b00;
        Aload = 1'b0;

        $finish;


    end 

endmodule