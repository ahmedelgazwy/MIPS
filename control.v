module control(regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,opCode);

input[5:0] opCode;
output reg regDst,jump,branch,memRead,memToReg,memWrite,aluSrc,regWrite;
output reg[2:0] aluOp;

always @(opCode)

begin


if(opCode==6'b000000) //R type 
begin
regDst<=1'b1;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b010;
memWrite<=1'b0;
aluSrc<=1'b0;
regWrite<=1'b1;
end


else if(opCode==6'b000100) //beq
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b1;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'b001; //subtract 
memWrite<=1'b0;
aluSrc<=1'b0;
regWrite<=1'b0;
end

else if(opCode==6'b001000) //addi 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b000;
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b001101) //ori 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
aluOp<=3'b100; 
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b101011) //sw 
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'b000; 
memWrite<=1'b1;
aluSrc<=1'b1;
regWrite<=1'b0;
end

else if(opCode==6'b100011) //lw
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b1;
memToReg<=1'b1;
aluOp<=3'b000; 
memWrite<=1'b0;
aluSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b000010) //j
begin
regDst<=1'bx;
jump<=1'b1;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b0;
end


else
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
aluOp<=3'bxxx; 
memWrite<=1'b0;
aluSrc<=1'bx;
regWrite<=1'b0;
end


end

endmodule

module control_tb();

reg[5:0] op;
wire a,b,c,d,e,w,s,t;
wire[2:0] m;

initial
begin

$monitor("opcode=%d  ->regDst=%b , jump=%b , branch=%b , memRead=%b , memToReg=%b , aluOp=%b , memWrite=%b , aluSrc=%b , regWrite=%b",op,a,b,c,d,e,m,w,s,t);

#10
op=6'b000000;
#10
op=6'b000100;
#10
op=6'b001000;
#10
op=6'b001101;
#10
op=6'b100011;
#10
op=6'b000010;

end
control c1(a,b,c,d,e,m,w,s,t,op);

endmodule
