module MyComparatorGate(A_lt_B, A_gt_B, A_eq_B, A, B);

output A_lt_B, A_gt_B, A_eq_B;
input[3:0] A, B;

wire [3:0] An, Bn, and1_1_wire, and1_2_wire, x;

not not1[3:0](An, A);
not not2[3:0](Bn, B);

and and1_1[3:0](and1_1_wire, An, B);
and and1_2[3:0](and1_2_wire, A, Bn);

nor nor1[3:0](x, and1_1_wire, and1_2_wire);

wire[5:0] and2;

and (and2[5], and1_2_wire_1, x[3], and1_1_wire[2]);
and (and2[4], x[3], and1_2_wire[2]);
and (and2[3], x[3], x[2], and1_1_wire[1]);
and (and2[2], x[3], x[2], and1_2_wire[1]);
and (and2[1], x[3], x[2], x[1], and1_1_wire[0]);
and (and2[0], x[3], x[2], x[1], and1_2_wire[0]);

and (A_eq_B, x[3], x[2], x[1], x[0]);

or (A_lt_B, and1_1_wire[3], and2[5], and2[3], and2[1]);
or (A_gt_B, and1_2_wire[3], and2[4], and2[2], and2[0]);

endmodule

module Top;

reg[3:0] A, B;
wire A_lt_B, A_gt_B, A_eq_B;

MyComparatorGate MyComp(.A_lt_B(A_lt_B), .A_gt_B(A_gt_B), .A_eq_B(A_eq_B), .A(A), .B(B));

initial
begin
    $monitor($time, " A = %h, B = %h, A_lt_B = %h, A_gt_B = %h, A_eq_B = %h", A, B, A_lt_B, A_gt_B, A_eq_B);
end

initial
begin
    A = 4'h0; B = 4'h1;
    #10 A = 4'hf; B = 4'h3;
    #10 A = 4'ha; B = 4'hb;
    #10 A = 4'h0; B = 4'h0;
    #10 A = 4'h7; B = 4'hd;
    #10 A = 4'h9; B = 4'h9;
end

endmodule
