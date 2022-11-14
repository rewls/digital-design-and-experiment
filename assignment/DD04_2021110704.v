module BCDtoDecimal(DECOut, BCDIn);

output [9:0] DECOut;
input [3:0] BCDIn;

assign DECOut = BCDIn == 4'b0 ? 10'b1 :
         BCDIn == 4'b1 ? 10'b10 :
         BCDIn == 4'b10 ? 10'b100 :
         BCDIn == 4'b11 ? 10'b1000 :
         BCDIn == 4'b100 ? 10'b10000 :
         BCDIn == 4'b101 ? 10'b100000 :
         BCDIn == 4'b110 ? 10'b1000000 :
         BCDIn == 4'b111 ? 10'b10000000 :
         BCDIn == 4'b1000 ? 10'b100000000 :
         BCDIn == 4'b1001 ? 10'b1000000000 :
         10'b1111111111;

endmodule

module Top;

reg [3:0] BCDIn;
wire [9:0] DECOut;

BCDtoDecimal MyBCDtoD(.DECOut(DECOut), .BCDIn(BCDIn));

initial
begin
    $monitor($time, " BCDIn = %d --> DECOut = %10b", BCDIn, DECOut);
end

initial
begin
    BCDIn = 4'b0;
    #10 BCDIn = 4'b1;
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
end

endmodule
