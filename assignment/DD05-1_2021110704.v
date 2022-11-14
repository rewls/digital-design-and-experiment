module MyComparatorBeh(A_lt_B, A_gt_B, A_eq_B, A, B, CLK, nRST);

output reg A_lt_B, A_gt_B, A_eq_B;
input[3:0] A, B;
input CLK, nRST;

always @(posedge CLK or negedge nRST)
begin
    if (nRST == 0)
    begin
        A_lt_B = 0;
        A_gt_B = 0;
        A_eq_B = 0;
    end
    else
    begin
        A_lt_B = 0;
        A_gt_B = 0;
        A_eq_B = 0;
        if (A > B)
            A_gt_B = 1;
        else if (A == B)
            A_eq_B = 1;
        else
            A_lt_B = 1;
    end
end

endmodule

module Top;

reg[3:0] A, B;
reg CLK, nRST;
wire A_lt_B, A_gt_B, A_eq_B;

MyComparatorBeh MyComp(.A_lt_B(A_lt_B), .A_gt_B(A_gt_B), .A_eq_B(A_eq_B), .A(A), .B(B), .CLK(CLK), .nRST(nRST));

initial
begin
    $monitor($time, " A = %h, B = %h, A_lt_B = %h, A_gt_B = %h, A_eq_B = %h", A, B, A_lt_B, A_gt_B, A_eq_B);
end

always #5 CLK = ~CLK;

initial
begin
    nRST = 0; CLK = 0;
    A = 4'h0; B = 4'h1;
    #10 A = 4'hf; B = 4'h3; nRST = 1;
    #10 A = 4'ha; B = 4'hb;
    #10 A = 4'h0; B = 4'h0;
    #10 A = 4'h7; B = 4'hd;
    #10 A = 4'h9; B = 4'h9;
    #5 $finish;
end
endmodule
