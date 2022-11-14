module BCDtoSevenSeg(SevenSeg, BCDIn);

output [6:0] SevenSeg;
input [3:0] BCDIn;

assign SevenSeg = BCDIn == 4'b0 ? 7'b1111110 :
         BCDIn == 4'b1 ? 7'b0110000 :
         BCDIn == 4'b10 ? 7'b1101101 :
         BCDIn == 4'b11 ? 7'b1111001 :
         BCDIn == 4'b100 ? 7'b0110011 :
         BCDIn == 4'b101 ? 7'b1011011 :
         BCDIn == 4'b110 ? 7'b1011111 :
         BCDIn == 4'b111 ? 7'b1110000 :
         BCDIn == 4'b1000 ? 7'b1111111 :
         BCDIn == 4'b1001 ? 7'b1111011 :
         7'b0000000;

endmodule

module Top;

reg [3:0] BCDIn;
wire [6:0] SevenSeg;

BCDtoSevenSeg myBCDtoSevenSeg(.SevenSeg(SevenSeg), .BCDIn(BCDIn));

initial
    $monitor($time, " BCDIn = %d --> a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b", BCDIn, SevenSeg[6], SevenSeg[5], SevenSeg[4], SevenSeg[3], SevenSeg[2], SevenSeg[1], SevenSeg[0]);

initial
begin
    // $dumpfile("test.vcd");
    // $dumpvars(0, Top);
    BCDIn = 0;
    while (BCDIn != 15)
        increment();
    increment();
end

task increment;
    #10 BCDIn = BCDIn + 1;
endtask

endmodule
