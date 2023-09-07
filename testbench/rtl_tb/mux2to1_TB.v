module mux2to1_tb();

    parameter size = 8;
    reg S0;
    reg [size-1:0] i0, i1;

    wire [size-1:0] out;

    mux2to1 #(size) inst1 (
        .S0(S0),
        .i1(i1),
        .i0(i0),
        .out(out)
    );

    // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, mux2to1_tb);
    end


    initial begin
        S0 = 0;
        i0 = 0;
        i1 = 0;
        #10;

        // Expect i0 will be selected as out
        S0 = 0;
        i0 = 8'hF0;
        i1 = 0;
        #10;

        // Expect i1 will be selected as out
        S0 = 1;
        i0 = 0;
        i1 = 8'hF1;
        #10;
    end 

endmodule