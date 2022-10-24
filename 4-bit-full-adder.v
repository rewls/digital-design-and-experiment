// Define a l-bit full adder
module fulladd(sum, c_out, a, b, c_in);

// I/O port declarations
output sum, c_out;
input a, b, c_in;

// Internal nets
wire sl, cl, c2;

// Instantiate logic gate primitives
xor (sl, a, b);
and (cl, a, b);

xor (sum, sl, c_in);
and (c2, sl, c_in);

or (c_out, c2, cl);

endmodule


// Define a 4-bit full adder
module fulladd4(sum, c_out, a, b, c_in);

// I/O port declarations
output[3:0] sum;
output c_out;
input[3:0] a, b;
input c_in;

// Internal nets
wire cl, c2, c3;

// Instanti
fulladd fa0(sum[0], c1, a[0], b[0], c_in);
fulladd fa1(sum[1], c2, a[1], b[1], c1);
fulladd fa2(sum[2], c3, a[2], b[2], c2);
fulladd fa3(sum[3], c_out, a[3], b[3], c3);

endmodule


// Define the stimulus (top level module)
module stimulus;

// Set up variables
reg[3:0] A, B;
reg C_IN;
wire[3:0] SUM;
wire C_OUT;

// Instantiate the 4-bit full adder. call it FA1-4
fulladd4 FA1_4(SUM, C_OUT, A, B, C_IN) ;

// Setup the monitorins for the sisnal values
initial
begin
    $monitor($time,"A= %b, B=%b, C-IN= %b, --- C-OUT= %b, SUM= %b\n", A, B, C_IN, C_OUT, SUM);
end

// Stimulate inputs
initial
begin
    A = 4'd0; B = 4'd0; C_IN = 1'b0;
    #5 A = 4'd3; B = 4'd4;
    #5 A = 4'd2; B = 4'd5;
    #5 A = 4'd9; B = 9'd4;
    #5 A = 4'd10; B = 4'd5; C_IN = 1'b1;
end

endmodule
