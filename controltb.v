//control
module control(regDst, jump, branch, memRead, memToReg, ALUop, memWrite, ALUSrc, regWrite, opCode);

input[5:0] opCode;
output reg regDst,jump,branch,memRead,memToReg,memWrite,ALUSrc,regWrite;
output reg[2:0] ALUop;

always @(opCode)

begin


if(opCode==6'b000000) //R type 
begin
regDst<=1'b1;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
ALUop<=3'b010;
memWrite<=1'b0;
ALUSrc<=1'b0;
regWrite<=1'b1;
end


else if(opCode==6'b000100) //beq
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b1;
memRead<=1'b0;
memToReg<=1'bx;
ALUop<=3'b001; //subtract 
memWrite<=1'b0;
ALUSrc<=1'b0;
regWrite<=1'b0;
end

else if(opCode==6'b001000) //addi 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
ALUop<=3'b000;
memWrite<=1'b0;
ALUSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b001101) //ori 
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'b0;
ALUop<=3'b100; 
memWrite<=1'b0;
ALUSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b101011) //sw 
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
ALUop<=3'b000; 
memWrite<=1'b1;
ALUSrc<=1'b1;
regWrite<=1'b0;
end

else if(opCode==6'b100011) //lw
begin
regDst<=1'b0;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b1;
memToReg<=1'b1;
ALUop<=3'b000; 
memWrite<=1'b0;
ALUSrc<=1'b1;
regWrite<=1'b1;
end

else if(opCode==6'b000010) //j
begin
regDst<=1'bx;
jump<=1'b1;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
ALUop<=3'bxxx; 
memWrite<=1'b0;
ALUSrc<=1'bx;
regWrite<=1'b0;
end


else
begin
regDst<=1'bx;
jump<=1'b0;
branch<=1'b0;
memRead<=1'b0;
memToReg<=1'bx;
ALUop<=3'bxxx; 
memWrite<=1'b0;
ALUSrc<=1'bx;
regWrite<=1'b0;
end


end

endmodule
// MIPS ALU

module MIPSALU (ctl, readData1, lowerIn, shamt, ALUresult, zero);
// lowerIn is the mux output

input [3:0] ctl;
input [31:0] readData1,lowerIn;
input [4:0] shamt;
output reg [31:0] ALUresult;
output zero;

// Zero flag equals 1. if the output equals zero
assign zero = (ALUresult == 0);

always @ (ctl, readData1, lowerIn)
 case(ctl)
	0:ALUresult <= readData1 & lowerIn;		//and
	1:ALUresult <= readData1 | lowerIn;		//or (ori)
	2:ALUresult <= readData1 + lowerIn;		//add (lw, sw, addi)
	6:ALUresult <= readData1 - lowerIn;		//sub (beq)
	7:ALUresult <= readData1 < lowerIn ? 1:0;	//slt
	//12:ALUresult <= ~ (readData1 | lowerIn);	//nor
	14:ALUresult <= lowerIn >> shamt;		//sll
	default:ALUresult <= 0;
 endcase
endmodule

module ALUcontol (fn, ALUop, ctl);

input [2:0] ALUop;
input [5:0] fn;
output reg [3:0] ctl;

always @ (fn, ALUop)
// Add for load and stores
 if (ALUop == 3'b000)
 begin
	ctl <= 2;
 end
// Subtract for beq
 else if (ALUop == 3'b001)
 begin
	ctl <= 6;
 end
// Determined by funct for R-format
else if (ALUop == 3'b010)
 begin
   case(fn)
	32:ctl <= 2;	//add
	34:ctl <= 6;	//sub
	36:ctl <= 0;	//and
	37:ctl <= 1;	//or
	42:ctl <= 7;	//slt
	0:ctl <= 14;	//sll
	default:ctl <= 0;
   endcase
 end
// add for addi
else if (ALUop == 3'b011)
 begin
	ctl <= 0;
 end
// or for ori
else if (ALUop == 3'b100)
 begin
	ctl <= 1;
 end
// sub for beq
else if (ALUop == 3'b101)
 begin
	ctl <= 1;
 end

else
	ctl <= 1;
endmodule

module ALUMux (MUXout, readData2, in2, ALUSrc);

output [31:0] MUXout;
input [31:0] readData2, in2;
input ALUSrc;
assign  MUXout = (ALUSrc == 1'b0)? readData2:
		 (ALUSrc == 1'b1)? in2:
		1'bx;
endmodule

module testBench();

// All must be 32-bits, or it will simulate with warnings, but with misleading numbers
// Input must be readData1 reg in testing

reg [5:0] opCode;
reg [31:0] readData1, lowerIn;
reg [4:0] shamt;
reg [5:0] fn;
reg [31:0] readData2;
reg [31:0] in2;

// Outpt must be readData1 wire in testing (may not type wire)
wire [31:0] ALUresult;
wire [3:0] ctl;
wire regDst, jump, branch, memRead, memToReg, memWrite, ALUSrc, regWrite, zero;
wire [31:0] MUXout;
wire [2:0] ALUop;

initial 

begin

$monitor ("readData1=%d,lowerIn=%d,fn=%d,ctl=%b,zero=%b,ALUresult=%d,opcode=%d ->regDst=%b,jump=%b,branch=%b,memRead=%b,memToReg=%b,ALUop=%b,memWrite=%b,ALUSrc=%b,regWrite=%b",
	   readData1,MUXout, fn,ctl, zero,ALUresult, opCode, regDst,jump,branch,memRead, memToReg,ALUop,memWrite,ALUSrc,regWrite);

opCode=6'b000000;
fn =32;
readData1=34;
readData2=47;
in2=55;

#5

opCode=6'b101011;
fn =34;
readData1=44;
readData2=18;
in2=55;

#5

opCode=6'b000100;
fn =36;
readData1=4515;
readData2=777;
in2=55;

#5
opCode=6'b001000;
fn =37;
readData1=80;
readData2=2;
in2=55;

#5

opCode=6'b001101;
fn =42;
readData1=9584;
readData2=1888;
in2=55;

#5

opCode=6'b100011;
fn =34;
readData1=44;
readData2=18;
in2=55;

#5

opCode=6'b100011;
fn =34;
readData1=44;
readData2=18;
in2=55;

#5

opCode=6'b000010;
fn =34;
readData1=44;
readData2=18;
in2=55;

#5

opCode=6'b000010;
fn =34;
readData1=44;
readData2=18;
in2=55;

#5
opCode =6'b000010;
readData1=44;
readData2=18;
in2=55;

end

MIPSALU m1 (ctl, readData1, MUXout, shamt, ALUresult, zero);
ALUcontol c1 (fn, ALUop, ctl);
ALUMux mux1(MUXout, readData2, in2, ALUSrc);
control t1 (regDst, jump, branch, memRead, memToReg, ALUop, memWrite, ALUSrc, regWrite, opCode);
endmodule


