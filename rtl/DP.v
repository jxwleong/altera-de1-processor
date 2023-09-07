module DP(
	input IRload, JMPmux, PCload, Meminst, MemWr, Aload, Reset, Clock , Sub, 
	input [1:0] Asel, 
	input [7:0] INPUT,
	output [7:0] OUTPUT,
	output [2:0] IR, 
	output Aeq0, Apos
);


	wire [7:0] qIR, qA;
	wire [4:0] qPC;

	// output of reg/ connection wires

	wire [7:0] qRAM;

	wire [7:0] dIR, dA, dRAM;
	wire [4:0] dPC; 

	wire [1:0] wireNOR;
	wire [4:0] wireJMP;
	wire [7:0] wireAddSubRslt;
	wire [7:0] wireMux4to1;
	wire [1:0] wireAsel;

	wire [4:0] address;

	wire [8:0] resultAddSub;
	wire [4:0] increment5bits;

	/*High impedence for 4-to-1 mux*/
	wire [7:0] Z;
	assign Z = 8'bzzzzzzzz;
	//assign 	wireJMP = JMPmux  ? qIR[4:0] :  qPC[4:0] + 5'b00001;
	// First cycle PC=0 because of the reset to start the FSM
	assign  increment5bits = qPC[4:0] + 5'b00001;
	assign  wireAddSubRslt = resultAddSub;
	assign  IR[2:0] = qIR[7:5];
	assign  wireAsel = Asel;
	assign  OUTPUT = qA;

	or (wireNOR[0], qA[0], qA[1], qA[2], qA[3]);
	or (wireNOR[1], qA[4], qA[5], qA[6], qA[7]);
	nor (Aeq0, wireNOR[0], wireNOR[1]);

	not	(Apos, qA[7]);


	mux2to1	#(5)		muxJMP     (JMPmux, qIR[4:0], increment5bits, dPC);
	mux2to1	#(5)		muxMeminst (Meminst, qIR[4:0], qPC, address);

	mux4to1	#(8)		mux1    (Asel[0], Asel[1], wireAddSubRslt, INPUT, qRAM, Z, wireMux4to1);

	DFF_reg #(8)		IRreg   (qIR, IRload, Reset, Clock, qRAM);
	DFF_reg #(5)		PCreg   (qPC, PCload, Reset, Clock, dPC);
	DFF_reg #(8)		Areg    (qA , Aload , Reset, Clock, wireMux4to1);
	RAM		#(32, 8)	RAM32x8 (qA, address, MemWr, Clock, qRAM);

	addSubstractor 		addSub1 (Sub, qA, qRAM, resultAddSub);



endmodule 
