module clock(clk);
`timescale 100ps/1ps
output reg clk;
initial
	begin
		assign clk = 0;
	end
always
	begin
		#625
		assign clk = 1;
		#625
		assign clk = 0;
	end
endmodule
