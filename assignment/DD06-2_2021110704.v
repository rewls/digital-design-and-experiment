module delay(A, B, C, O);

input A, B, C;
output O;
wire E;

assign #5 E = A & B;
assign #4 O = E | C;

endmodule

module Top;

reg A, B, C;
wire O;

delay myDelay(.A(A), .B(B), .C(C), .O(O));

initial
    $monitor($time, " A = %b, B = %b, C = %b --> O = %b", A, B, C, O);

initial
begin
    // $dumpfile("test.vcd");
    // $dumpvars(0, Top);
    A = 1'b0;
    B = 1'b0;
    C = 1'b0;
    #10
    A = 1'b1;
    B = 1'b1;
    C = 1'b1;
    #20
    B = 1'b0;
    C = 1'b0;
    #10
    B = 1'b1;
    #2
    B = 1'b0;
    #2
    C = 1'b1;
    #1
    C = 1'b0;
end

endmodule
