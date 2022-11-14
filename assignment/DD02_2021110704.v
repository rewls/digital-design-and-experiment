module SR_latch(Q, Qbar, Sbar, Rbar);

output Q, Qbar;
input Sbar, Rbar;

nand n1(Q, Sbar, Qbar);
nand n2(Qbar, Rbar, Q);

endmodule


module D_latch(Q, Qbar, D, En);

output Q, Qbar;
input D, En;
wire sbar, rbar;

nand n1(sbar, D, En);
nand n2(rbar, ~D, En);

SR_latch m1(.Q(Q), .Qbar(Qbar), .Sbar(sbar), .Rbar(rbar));

endmodule


module Top;

wire q, qbar;
reg d, en;

D_latch m1(.Q(q), .Qbar(qbar), .D(d), .En(en));

initial
begin
    $monitor($time, " D = %b, En = %b, Q = %b, Qbar = %b\n", d, en, q, qbar);
    d = 0;
    en = 0;
    #5 d = 1;
    #5 d = 0;
    #5 en = 1;
    #5 d = 1;
    #5 d = 0;
    #5 d = 1;
    #5 en = 0;
    #5 d =0;
end

endmodule
