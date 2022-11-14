module BCDtoDecimalBeh(DECOut, BCDIn, CLK, nRST);

output reg[9:0] DECOut;
input[3:0] BCDIn;
input CLK, nRST;

always @(posedge CLK or negedge nRST)
begin
    if (nRST == 0)
         DECOut = 0;
    else
    begin
        DECOut = BCDIn == 4'b0 ? 10'b1 :
             BCDIn == 4'b1 ? 10'b10 :
             BCDIn == 4'b10 ? 10'b100 :
             BCDIn == 4'b11 ? 10'b1000 :
             BCDIn == 4'b100 ? 10'b10000 :
             BCDIn == 4'b101 ? 10'b100000 :
             BCDIn == 4'b110 ? 10'b1000000 :
             BCDIn == 4'b111 ? 10'b10000000 :
             BCDIn == 4'b1000 ? 10'b100000000 :
             BCDIn == 4'b1001 ? 10'b1000000000 :
             10'b0;
    end
end

endmodule

module Top;

reg [3:0] BCDIn;
reg CLK, nRST;
wire [9:0] DECOut;

BCDtoDecimalBeh MyBCDtoDecimalBeh(.DECOut(DECOut), .BCDIn(BCDIn), .CLK(CLK), .nRST(nRST));

initial
begin
    $monitor($time, " BCDIn = %d --> DECOut = %10b", BCDIn, DECOut);
end

always #5 CLK = ~CLK;

initial
begin
    nRST = 0; CLK = 0;
    BCDIn = 4'b0;
    #10 BCDIn = 4'b1; nRST = 1;
    #10 BCDIn = 4'b10;
    #10 BCDIn = 4'b11;
    #10 BCDIn = 4'b100;
    #10 BCDIn = 4'b101;
    #10 BCDIn = 4'b110;
    #10 BCDIn = 4'b111;
    #10 BCDIn = 4'b1000;
    #10 BCDIn = 4'b1001;
    #10 BCDIn = 4'b1010;
    #10 BCDIn = 4'b1011;
    #10 BCDIn = 4'b1100;
    #10 BCDIn = 4'b1101;
    #10 BCDIn = 4'b1110;
    #10 BCDIn = 4'b1111;
    #10 BCDIn = 4'b0;
    #5 $finish;
end

endmodule
