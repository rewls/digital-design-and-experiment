// Module name and port list
module SR_latch(Q, Qbar, Sbar, Rbar);

// Port declarations
output Q, Qbar;
input Sbar, Rbar;

// Instantiate lower-level modules
nand n1(Q, Sbar, Qbar);
nand n2(Qbar, Rbar, Q);

endmodule

module Top;

// Variable declarations
wire q, qBar;
reg set, reset;

// Instantiate lower-level modules
SR_latch m1(q, qbar, ~set, ~reset);

// Behavioral block, initial
initial
begin
    $monitor($time, " set = %b, reset = %b, q = %b\n", set, reset, q);
    set = 0; reset = 0;
    #5 reset = 1;
    #5 reset = 0;
    #5 set =1;
end

endmodule
