`define s0_to_s1_delay 2'd3
`define s1_to_s2_delay 2'd2

module fsm(Y_OUT, CLK, nRST, X_IN);

output reg Y_OUT;
input CLK, nRST, X_IN;

parameter s0 = 2'd0,
		  s1 = 2'd1,
		  s2 = 2'd2;

reg [1:0] state, next_state;
reg [1:0] s0_to_s1_counter, s1_to_s2_counter;

initial
begin
	Y_OUT = 1'd0;
	state = 2'd0;
	next_state = 2'd0;
	s0_to_s1_counter = 2'd0;
	s1_to_s2_counter = 2'd0;
end

always @(state)
begin
	s0_to_s1_counter = 2'd0;
	s1_to_s2_counter = 2'd0;
end

always @(posedge CLK)
begin
	if (nRST)
	begin
		case (state)
			s1:
				if (s0_to_s1_counter == `s0_to_s1_delay)
					state <= next_state;
				else
					s0_to_s1_counter = s0_to_s1_counter + 1;
			s2:
				if (s1_to_s2_counter == `s1_to_s2_delay)
					state <= next_state;
				else
					s1_to_s2_counter = s1_to_s2_counter + 1;
			default:
				state <= next_state;
		endcase
	end
	else
		state <= s0;
end

always @(state)
begin
	case (state)
		s0:
			Y_OUT = 1'b0;
		s1:
			Y_OUT = 1'b1;
		s2:
			Y_OUT = 1'b0;
	endcase
end

always @(state or X_IN)
begin
	case (state)
		s0:
			if (X_IN)
				next_state = s1;
			else
				next_state = s0;
		s1:
			if (X_IN)
				next_state = s2;
			else
				next_state = s0;
		s2:
			if (X_IN)
				next_state = s1;
			else
				next_state = s0;
	endcase
end

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, top);
end

endmodule
