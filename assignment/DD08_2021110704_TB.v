`include "DD08_2021110704.v"
`define Y2RDELAY 3'd3  // yellow to red delay
`define R2GDELAY 3'd2  // red to green delay

module stimulus;

wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON_CNTRY_RD;
	// if TRUE, there is car on the country road, otherwise FALSE
reg CLOCK, CLEAR;

sig_control SC(MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD, CLOCK, CLEAR, `Y2RDELAY, `R2GDELAY);

initial
	$monitor($time, " Main Sig = %b Country Sig = %b Car_on_cntry = %b",
				MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

initial
	CLOCK = `FALSE;

always #5 CLOCK = ~CLOCK;

initial
begin
	CLEAR = `TRUE;
	#50 CLEAR = `FALSE;
end

initial
begin
	CAR_ON_CNTRY_RD = `FALSE;

	#200 CAR_ON_CNTRY_RD = `TRUE;
	#100 CAR_ON_CNTRY_RD = `FALSE;

	#200 CAR_ON_CNTRY_RD = `TRUE;
	#100 CAR_ON_CNTRY_RD = `FALSE;

	#200 CAR_ON_CNTRY_RD = `TRUE;
	#100 CAR_ON_CNTRY_RD = `FALSE;

	#100 $finish;
end

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0, stimulus);
end

endmodule
