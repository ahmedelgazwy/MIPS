module PC(Out,In,clk);

input clk;
input [31:0]In;
output reg [31:0]Out;
/*initial
  begin
  intger i;
  for(i=0;i<31;i++)
  begin
  pc[i]=0;
  end
  end*/
always@(posedge clk)
begin

Out <= In;

end

endmodule
