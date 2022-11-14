`timescale 1 ns / 1 ns
`define TRUE 1'b1
`define FALSE 1'b0

module sig_control(hwy, cntry, x, clock, clear, y2rdelay, r2gdelay);

output reg [1:0] hwy, cntry;  // for 3 states GREEN, YELLOW, RED
input x; // if TRUE, there is car on the country road, otherwise FALSE
input clock, clear;
input [2:0] y2rdelay, r2gdelay;

reg [10:0] y2rcounter, r2gcounter;

parameter RED = 2'd0,
		  YELLOW = 2'd1,
		  GREEN = 2'd2;

// state definition		 HWY     CNTRY
parameter s0 = 3'd0,  // GREEN   RED
		  s1 = 3'd1,  // YELLOW  RED
		  s2 = 3'd2,  // RED     RED
		  s3 = 3'd3,  // RED     GREEN
		  s4 = 3'd4;  // RED     YELLOW

reg [2:0] state;
reg [2:0] next_state;

initial
begin
	y2rcounter = 10'd0;
	r2gcounter = 10'd0;
end

always @(state)
begin
	hwy = GREEN;
	cntry = RED;
	case (state)
		s0:;
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

always @(state)
begin
	y2rcounter = 10'd0;
	r2gcounter = 10'd0;
end

always @(posedge clock)
begin
	if (clear)
		state <= s0;
	else
	begin
		case (state)
			s1:
				if (y2rcounter == y2rdelay)
					state <= next_state;
				else
					y2rcounter = y2rcounter + 1;
			s2:
				if (r2gcounter == r2gdelay)
					state <= next_state;
				else
					r2gcounter = r2gcounter + 1;
			s4:
				if (y2rcounter == y2rdelay)
					state <= next_state;
				else
					y2rcounter = y2rcounter +1;
			default:
				state <= next_state;
		endcase
	end
end

// state machine
always @(state or x)
begin
	case (state)
		s0:
			if(x)
				next_state = s1;
			else
				next_state = s0;
		s1:
			next_state = s2;
		s2:
			next_state = s3;
		s3:
			if (x)
				next_state = s3;
			else
				next_state = s4;
		s4:
			next_state = s0;
		default:
			next_state = s0;
	endcase
end

endmodule
