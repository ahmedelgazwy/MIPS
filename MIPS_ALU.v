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
reg [31:0] readData1, lowerIn;
reg [2:0] ALUop;
reg [4:0] shamt;
reg [5:0] fn;
reg [31:0] readData2;
reg [31:0] in2;
reg ALUSrc;

// Outpt must be readData1 wire in testing (may not type wire)
wire [31:0] ALUresult;
wire [3:0] ctl;
wire zero;
wire [31:0] MUXout;

initial 

begin

$monitor ("readData1 = %d, lowerIn = %d, ALUop = %d, fn = %d, ctl= %b, zero = %b, ALUresult = %d", readData1, MUXout, ALUop, fn, ctl, zero, ALUresult);

ALUop = 3'b010;
fn =32;
readData1=34;
readData2=47;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b010;
fn =34;
readData1=44;
readData2=18;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b010;
fn =36;
readData1=4515;
readData2=777;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b010;
fn =37;
readData1=80;
readData2=2;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b010;
fn =42;
readData1=9584;
readData2=1888;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b000;
fn =34;
readData1=44;
readData2=18;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b001;
fn =34;
readData1=44;
readData2=18;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b011;
fn =34;
readData1=44;
readData2=18;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b100;
fn =34;
readData1=44;
readData2=18;
in2=55;
ALUSrc=1;

#5
ALUop = 3'b101;
fn =34;
readData1=44;
readData2=18;
in2=55;
ALUSrc=1;

end

MIPSALU m1 (ctl, readData1, MUXout, shamt, ALUresult, zero);
ALUcontol c1 (fn, ALUop, ctl);
ALUMux mux1(MUXout, readData2, in2, ALUSrc);

endmodule



