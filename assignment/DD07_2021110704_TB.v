`include "DD07_2021110704.v"

module top;

wire Y;
reg CLK, nRST, X;

sequence_detector sd(.Y(Y), .CLK(CLK), .nRST(nRST), .X(X));

always #5 CLK = ~CLK;

initial
begin
    CLK = 1'b0;
    nRST = 1'b0;
    X = 1'b0;
    #20 nRST = 1'b1;
    #20 X = 1'b1;
    #30 X = 1'b0;
    #20 X = 1'b1;
    #10 X = 1'b0;
    #20 X = 1'b1;
    #40 X = 1'b0;
    #30 $finish;
end

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, top);
end

endmodule
