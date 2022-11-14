module sequence_detector(Y, CLK, nRST, X);

output reg Y;
input CLK, nRST, X;

parameter s0 = 2'd0,
          s1 = 2'd1,
          s2 = 2'd2,
          s3 = 2'd3;

reg [1:0] current_state, next_state;

always @(posedge CLK)
    if (nRST)
        current_state <= next_state;
    else
        current_state <= s0;

initial
begin
    current_state = s0;
    next_state = s0;
    Y = 1'b0;
end

always @(current_state)
    if (current_state == s3)
        Y = 1'b1;
    else
        Y = 1'b0;

always @(current_state or X)
begin
    case (current_state)
        s0:
            if (X)
                next_state = s1;
            else
                next_state = s0;
        s1:
            if (X)
                next_state = s2;
            else
                next_state = s0;
        s2:
            if (X)
                next_state = s3;
            else
                next_state = s0;
        s3:
            if (X)
                next_state = s3;
            else
                next_state = s0;
        default:
            next_state = s0;
    endcase
end

endmodule
