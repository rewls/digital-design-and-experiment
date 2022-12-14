// Module 4-to-1 multiplexer. Port list is taken exactly from
// the 1/0 diagram.
module mux4_to_1 (out, i0, i1, i2, i3, s1, s0);

// Port declarations from the 1/0 diagram
output out;
input i0, i1, i2, i3;
input s1, s0;

// Internal wire declarations
wire s1n, s0n;
wire y0, y1, y2, y3;

// Gate instantiations

// Create sln and son signals.
not (s1n, s1);
not (s0n, s0);

// 3-input and gates instantiated
and (y0, i0, s1n, s0n);
and (y1, i1, s1n, s0);
and (y2, i2, s1, s0n);
and (y3, i3, s1, s0);

// 4-input or gate instantiated
or (out, y0, y1, y2, ~y3);

endmodule

// Define the stimulus module (no ports)
module stimulus;

// Declare variables to be connected
// to inputs
reg IN0, IN1, IN2, IN3;
reg S1, S0;

// Declare output wire
wire OUTPUT;

// Instantiate the multiplexer
mux4_to_1 mymux (OUTPUT, IN0, IN1, IN2, IN3, S1, S0);

// define the stimulus module (no ports)
// Stimulate the inputs
initial
begin
    // set input lines
    IN0 = 1; IN1 = 0; IN2 = 1; IN3 = 0;
    #1 $display("INO= %b, IN1= %b, IN2= %b, IN3= %b\n", IN0, IN1, IN2, IN3);
    // choose IN0
    S1 = 0; S0 = 0;
    #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
    // choose IN1
    S1 = 0; S0 = 1;
    #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
    // choose IN2
    S1 = 1; S0 = 0;
    #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);

    // choose IN3
    S1 = 1; S0 = 1;
    #1 $display("S1 = %b, S0 = %b, OUTPUT = %b \n", S1, S0, OUTPUT);
end

endmodule
