// Define a simple combination module called D
module D (out, a, b, c);

// 1/0 port declarations
output out;
input a,b,c;

// Internal nets
wire e;

// Instantiate primitive gates to build the circuit
and #(5) a1 (e, a, b) ; // Delay of 5 on gate a1

or #(4) ol(out, e, c); // Delay of 4 on gate 01
endmodule

// Stimulus (top-level module)
module stimulus;

// Declare variables
reg A, B, C;
wire OUT;

// Instantiate the module D
D dl(OUT, A, B, C);

// Stimulate the inputs. Finish the simulation at 40 time units
initial
begin
    A= 1'b0; B= 1'b0; C= 1'b0;
    #10 A= 1'b1; B= 1'b1; C= 1'b1;
    #10 A= 1'b1; B= 1'b0; C= 1'b0;
    #20 $finish;
end
endmodule
