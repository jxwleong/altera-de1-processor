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
        .Asel(Asel),
        .INPUT(INPUT),

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


    // For Debug only..
    always @(posedge Clock) begin 
        $display("At time %t, IRLoad = %b", $time, IRLoad);
        $display("At time %t, Asel = %b", $time, Asel);

    end     
    
    task DP_init;
        // Intialize all inputs to be 0
        IRLoad = 1'b0;
        JMPmux = 1'b0;
        PCload = 1'b0; 
        Meminst = 1'b0;
        MemWr = 1'b0; 
        Aload = 1'b0; 
        Clock = 1'b0; 
        Sub = 1'b0;
        Reset = 1'b0;
        Asel = 2'b0;
        INPUT = 8'b0;
        #10; // Wait for the reset..

        // Figured out why the DFF is not loaded properly, was due to the
        // these Reset signals..
        Reset = 1'b1;  
        #10;
    endtask 

    task input_A;
        input [7:0] value;
        begin
            // INPUT A
            INPUT = value;
            {IRLoad, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0000010;
            Asel = 2'b01;
            #20;  // Wait two full clock cycles for the register to update
        end
    endtask

    task store_A;
        begin 
            Asel = 2'b00;
            {IRLoad, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0001100;
            #20;
        end 

    task fetch_decode;
        // Mimic fetch and decode cycle
        // we will send out the control signals accordingly...
        begin 
            // Fetch
            {IRLoad, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b1010000;
            #10;
            // Decode
            {IRLoad, JMPmux, PCload, Meminst, MemWr, Aload, Sub} = 7'b0001000;
            #10;
        end 



    initial begin
        DP_init;

        input_A(8'd10);
                    
        $finish;


    end 

endmodule


   /*
        We're going to mimic the behavior of the actual program.
        Which required to simulated the Fetch=>Decode=>Execute cycle.

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
