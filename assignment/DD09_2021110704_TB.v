`timescale 1 ns / 1 ns
`include "DD09_2021110704_2.v"

module top;

wire Y_OUT;
reg CLK, nRST, X_IN;

fsm my_fsm(Y_OUT, CLK, nRST, X_IN);

initial
	CLK = 1'b0;

always
	#5 CLK = ~CLK;

initial
begin
	nRST = 1'b0;
	#20 nRST = 1'b1;
end

initial
begin
	X_IN = 1'b0;
	#40 X_IN = 1'b1;
	#100 X_IN = 1'b0;
	#50 X_IN = 1'b1;
	#10 X_IN = 1'b0;
	#100 $finish;
end

endmodule
