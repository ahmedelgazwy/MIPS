
module AluCtl(funct,aluop,aluctl);
input [5:0] funct;
input [1:0] aluop;
output reg [3:0] aluctl;

always @ (aluop,funct)

if (aluop == 2'b00) //loads and stores 
 aluctl<=2;
else if (aluop==2'b01) //beq
 aluctl<=6;
else if (aluop==2'b10) //R-format
  begin
     case (funct)
	32:aluctl <= 2; //add
 	34:aluctl <= 6; //sub
	36:aluctl <= 0; //and
	37:aluctl <= 1; //or
	42:aluctl <= 7; //slt
	default:aluctl <= 0;
      endcase
  end
else
aluctl<=0;

endmodule

/*
aluctl:
0:and
1:or
2:add
6:subtract
7:compare
12:nor
*/
