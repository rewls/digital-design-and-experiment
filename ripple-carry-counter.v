// Top-level
module ripple_carry_counter(q, clk, reset);

output [3:0] q;
input clk, reset;

// Four instances of the module T_FF
T_FF tff0(q[0], clk, reset);
T_FF tff1(q[1], q[0], reset);
T_FF tff2(q[2], q[1], reset);
T_FF tff3(q[3], q[2], reset);

endmodule


// T flip-flop
module T_FF(q, clk, reset);

output q;
input clk, reset;
wire d;

// instantiate D_FF
D_FF dff0(q, d, clk, reset);
not n1(d, q);

endmodule


// D flip-flop
module D_FF(q, d, clk, reset);

output q;
input d, clk, reset;
reg q;

always @(posedge reset or negedge clk)
if (reset)
    q <= 1'b0;
else
    q <= d;

endmodule


module stimulus;

reg clk;
reg reset;
wire[3:0] q;

// Instantiate the design block
ripple_carry_counter r1(q, clk, reset);

// Control the clk signal that drives the design block
// Cycle time = 10
initial
    clk = 1'b0;
always
    #5 clk = ~clk;

// Control the reset signal that drives the design block
initial
begin
    reset = 1'b1;
    #15 reset = 1'b0;
    #180 reset = 1'b1;
    #10 reset = 1'b0;
    #20 $finish;  // terminate the simulation
end

// Monitor the outputs
initial
    $monitor($time, " Output q = %d", q);

endmodule
