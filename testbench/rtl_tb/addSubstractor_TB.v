module addSubstractor_tb();

    reg sub;
    reg [7:0] A, B;
    wire [8:0] out;

    addSubstractor inst1(
        .sub(sub),
        .A(A),
        .B(B),
        .out(out)
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, addSubstractor_tb);
    end

    initial begin
        // Init
        sub = 0;
        A = 0;
        B = 0;
        #10;

        // A + B
        sub = 0;
        A = 8'b1;
        B = 8'b10;
        #10;

        // A - B
        sub = 1;
        A = 8'b10;
        B = 8'b1;
        #10;
        
    end 


endmodule