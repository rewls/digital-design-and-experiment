`timescale 1 ns / 1 ns
`define TRUE 1'b1
`define FALSE 1'b0

module sig_control(hwy, cntry, x, clock, clear, y2rdelay, r2gdelay);

output reg[1:0] hwy, cntry;

input x, clock, clear;
input [2:0] y2rdelay, r2gdelay;

reg [10:0] y2rcounter, r2gcounter;

parameter RED = 2'd0,
		  YELLOW = 2'd1,
		  GREEN = 2'd2;

parameter s0 = 3'd0,
		  s1 = 3'd1,
		  s2 = 3'd2,
		  s3 = 3'd3,
		  s4 = 3'd4;

reg [2:0] state;
reg [2:0] next_state;

initial
begin
	y2rcounter = 10'd0;
	r2gcounter = 10'd0;
end

always @(posedge clock)
	if (clear)
		state <= s0;
	else
		state <= next_state;

always @(posedge clock)
begin
	if (state == s1)
	begin
		if (y2rcounter == y2rdelay)
			next_state = s2;
		else
			y2rcounter = y2rcounter + 1;
	end
	else if (state == s4)
	begin
		if (y2rcounter == y2rdelay)
			next_state = s0;
		else
			y2rcounter = y2rcounter + 1;
	end
	else if (state == s2)
	begin
		if (r2gcounter == r2gdelay)
			next_state = s3;
		else
			r2gcounter = r2gcounter + 1;
	end
end

always @(state)
begin
	y2rcounter = 10'd0;
	r2gcounter = 10'd0;
end

always @(state)
begin
	hwy = GREEN;
	cntry = RED;
	case (state)
		s0: ;
		s1: hwy = YELLOW;
		s2: hwy = RED;
		s3:
		begin
			hwy = RED;
			cntry = GREEN;
		end
		s4:
		begin
			hwy = RED;
			cntry = YELLOW;
		end
	endcase
end

always @(state or x)
begin
	case (state)
		s0:
			if (x)
				next_state = s1;
			else
				next_state = s0;
		s1: ;
		s2: ;
		s3:
			if (x)
				next_state = s3;
			else
				next_state = s4;
		s4: ;
		default:
			next_state = s0;
	endcase
end

endmodule
