`include "DD08_2021110704.v"
`timescale 1 ns / 1 ns
`define TRUE 1'b1
`define FALSE 1'b0
`define Y2RDELAY 3'd3
`define R2GDELAY 3'd2

module stimulus;

wire [1:0] MAIN_SIG, CNTRY_SIG;
reg CAR_ON_CNTRY_RD;
reg CLOCK, CLEAR;

sig_control SC(.hwy(MAIN_SIG), .cntry(CNTRY_SIG), .x(CAR_ON_CNTRY_RD), .clock(CLOCK), .clear(CLEAR), .y2rdelay(`Y2RDELAY), .r2gdelay(`R2GDELAY));

initial
	$monitor($time, " Main sig = %b country Sig %b Car_on_cntry = %b", MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);

always #5 CLOCK = ~CLOCK;

initial
begin
	CLEAR = `TRUE;
	CLOCK = `FALSE;
	CAR_ON_CNTRY_RD = `FALSE;
	#40 CLEAR = `FALSE;
	#160 CAR_ON_CNTRY_RD = `TRUE;
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
