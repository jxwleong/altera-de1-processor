module DFF_reg_tb();

    // Parameters
    parameter size = 8;

    // Wires and regs
    reg [size-1:0] D;
    reg load;
    reg clear;
    reg clock;
    wire [size-1:0] Q;

    // DUT
    DFF_reg #(size) u1 (
        .Q(Q), 
        .load(load), 
        .clear(clear), 
        .clock(clock), 
        .D(D)
    );

    // Clock generator
    initial clock = 0;
    always #5 clock = ~clock;  // 10s clock period

    // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, DFF_reg_tb);
    end

    // Stimulus
    initial begin
        // Reset the D flip-flop
        clear = 1;
        load = 0;
        D = 0;
        #10;

        // Load some value
        clear = 1;
        load = 1;
        D = 8'hA5;  // Arbitrary value
        #10;

        // Stop loading, maintain value
        load = 0;
        #20;

        // Load a new value
        load = 1;
        D = 8'h3C;  // Another arbitrary value
        #10;

        // Reset the D flip-flop
        clear = 1;
        #10;

        // End the simulation
        $finish;
    end
endmodule
