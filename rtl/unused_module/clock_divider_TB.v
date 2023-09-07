/*
WARNING: This will take > 10minutes or so
And the waveform is 3327MB BIG! 

Please be patient while waiting for the generation of the waveform
I won't be pushing the .vcd file on github

Not really tested YET!
*/
`timescale 1ns/100ps // time unit/time precision
/*
The timescale directive in Verilog is used to specify the time unit and time precision for the module it is declared in. 
The timescaledirective is usually declared at the beginning of the Verilog file and applies to all modules below it in the 
same file unless it's redefined in a lower level module. The directive is declared astimescale time_unit/time_precision.

1ns/100ps as declared in the `timescale means:

1ns: This is the time unit. It represents the unit of measurement for delays used in the module. 
When you write #10 in your code, it implies a delay of 10 units of the declared time unit, which is 10ns in this case.

100ps: This is the time precision. It defines the precision of the simulation. 
The simulator will round off delay times to this precision. 
In this case, any delay will be rounded off to the nearest 100 picoseconds.

So, `timescale 1ns/100ps means that the time delays in the design are measured in nanoseconds, 
but the precision up to which these delays will be accurate is up to 100 picoseconds.

*/
module clock_divider_tb();

    reg clk_50MHz, reset;
    wire clk_1Hz;

    clock_divider inst1(
        .clk_50MHz(clk_50MHz),
        .reset(reset),
        .clk_1Hz(clk_1Hz)
    );

   // VCD generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, clock_divider_tb);
    end

    initial begin
        // 1/50MHz = 20ns
        // Hence, 10ns half period for a 50MHz clock
        clk_50MHz = 0;
        forever #10 clk_50MHz = ~clk_50MHz; 
    end

    initial begin
        // Assert reset signal for the first 100 ns
        reset = 1;
        #100;
        reset = 0;

        // Simulate for 2 seconds, or 2*10^9 ns
        // This should allow us to see 2 cycles of the 1Hz output
        #2000000000;

        // End the simulation
        $finish;
    end


endmodule