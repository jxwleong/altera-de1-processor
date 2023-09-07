module RAM_tb();

    parameter RAM_LOCATIONS = 32;
    parameter RAM_BITS = 8;

    reg [RAM_BITS-1:0]  DATA_IN;
    reg [4:0] ADDR;
    reg WRITE;
    reg clk;

    wire [RAM_BITS-1:0] DATA_OUT;

    RAM #(RAM_LOCATIONS, RAM_BITS) inst1 (
        .DATA_IN(DATA_IN),
        .ADDR(ADDR),
        .WRITE(WRITE),
        .clk(clk),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generator
    initial clk = 0;
    always #5 clk = ~clk;  // 10s clock period

    // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, RAM_tb);
    end

    initial begin
        // Init, at the same time, it read RAM[0] which is
        // 8'b10000000 = 0x80
        DATA_IN = 0;
        ADDR = 0;
        WRITE = 0;
        #10;

        // Read RAM[1] which will be 8'b00111110 (0x3E);
        // Just so happen similar as init statements, LOL
        // Init statement will read RAM[0]
        DATA_IN = 0;
        ADDR = 5'd1;
        WRITE = 0;
        #10;

        // Write RAM[31] with value 8'b10101010 (0xAA)
        DATA_IN = 8'b10101010;
        ADDR = 5'd31;
        WRITE = 1;
        #10;

        // Reset WRITE to ensure that we are no longer in write mode
        WRITE = 0;
        #10;

        // Read Back RAM[31] to see if write success expect (0xAA)
        DATA_IN = 0;
        ADDR = 5'd31;
        WRITE = 0;
        #10;

        // Need to add these statements else stuck at 
        // vvp.exe RAM_TB_out
        // VCD info: dumpfile waveform.vcd opened for output.
        #10;  // Some delay to see the last instruction effect on the waveform
        $finish;  // Stops the simulation
    end 

endmodule