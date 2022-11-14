`define TRUE 1'b1
`define FALSE 1'b0

`define Y2RDELAY 3  // yellow to red delay
`define R2GDELAY 2  // red to green delay

module sig_control(hwy, cntry, x, clock, clear);

output reg [1:0] hwy, cntry;  // for 3 states GREEN, YELLOW, RED
input x; // if TRUE, there is car on the country road, otherwise FALSE
input clock, clear;

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

always @(posedge clock)
	if (clear)
		state <= s0;
	else
		state <= next_state;

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
		begin
			repeat(`Y2RDELAY) @(posedge clock);
			next_state = s2;
		end
		s2:
		begin
			repeat(`R2GDELAY) @(posedge clock);
			next_state = s3;
		end
		s3:
			if (x)
				next_state = s3;
			else
				next_state = s4;
		s4:
		begin
			repeat(`Y2RDELAY) @(posedge clock);
			next_state = s0;
		end
		default:
			next_state = s0;
	endcase
end

endmodule

module stimulus;

wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON_CNTRY_RD;
	// if TRUE, there is car on the country road, otherwise FALSE
reg CLOCK, CLEAR;

sig_control SC(MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD, CLOCK, CLEAR);

initial
	$monitor($time, " Main Sig = %b Country Sig = %b Car_on_cntry = %b",
				MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

initial
begin
	CLOCK = `FALSE;
	forever #5 CLOCK = ~CLOCK;
end

initial
begin
	CLEAR = `TRUE;
	repeat (5) @(negedge CLOCK);
	CLEAR = `FALSE;
end

initial
begin
	CAR_ON_CNTRY_RD = `FALSE;

	repeat (20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
	repeat (10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;

	repeat (20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
	repeat (10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;

	repeat (20) @(negedge CLOCK); CAR_ON_CNTRY_RD = `TRUE;
	repeat (10) @(negedge CLOCK); CAR_ON_CNTRY_RD = `FALSE;

	repeat (10) @(negedge CLOCK); $stop;
end

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, stimulus);
end

endmodule
