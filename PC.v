module PC(Out,In,clk);

input clk;
input [31:0]In;
output reg [31:0]Out;

always@(posedge clk)
begin

Out <= In;

end

endmodule