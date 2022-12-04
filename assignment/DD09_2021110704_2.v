module fsm(CLK, nRST, X_IN, Y_OUT);

output reg Y_OUT;
input CLK, nRST, X_IN;

parameter s0 = 3'd0,
		  s1 = 3'd1,
		  s2 = 3'd2,
		  s3 = 3'd3,
		  s4 = 3'd4;

reg [2:0] state = 3'd0;

always @(posedge CLK)
	if (nRST)
	begin
		case (state)
			s0:
				if (X_IN)
				begin
					state = 3'd1;
					Y_OUT = 1;
				end
				else
					Y_OUT = 1;
			s1:
				state = 3'd2;
			s2:
				state = 3'd3;
			s3:
			begin
				state = 3'd4;
				Y_OUT = 1'b0;
			end
			s4:
				state = 3'd0;
		endcase
	end
	else
		Y_OUT = 0;

endmodule
