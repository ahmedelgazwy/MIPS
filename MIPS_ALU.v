// MIPS ALU

module MIPSALU (ctl,a,b,out,zero);

input [3:0] ctl;
input [31:0] a,b;
output reg [31:0] out;
output zero;

// Zero flag equals 1. if the output equals zero
assign zero = (out == 0);

always @ (ctl,a,b)
 case(ctl)
	0:out <= a & b;
	1:out <= a | b;
	2:out <= a + b;
	3:out <= a / b;
	6:out <= a - b;
	7:out <= a < b ? 1:0;
	// nor
	12:out <= ~ (a | b);

	default:out <= 0;
 endcase
endmodule

module ALUcontol (fn, op, ctl);

input [1:0] op;
input [5:0] fn;
output reg [3:0] ctl;

always @ (fn, op)
 if (op == 2'b10)
 begin
   case(fn)
	32:ctl <= 2;
	34:ctl <= 6;
	36:ctl <= 0;
	37:ctl <= 1;
	42:ctl <= 7;
	default:ctl <= 0;
   endcase
 end
 else
	ctl <= 0;
endmodule

module testBench();

// All must be 32-bits, or it will simulate with warnings, but with misleading numbers
// Input must be a reg in testing
reg [31:0] a, b;
reg [1:0] op;
reg [5:0] fn;

// Outpt must be a wire in testing (may not type wire)
wire [31:0] f;
wire [3:0] ctl;
wire zero;

initial 

begin

$monitor ("in1 = %d, in2 = %d, op = %d, fn = %d, ctl= %b, zero = %b, out = %d", a, b, op, fn, ctl, zero, f);

op = 10;
fn =32;
a=34;
b=47;

#5
op = 10;
fn =34;
a=44;
b=18;

#5
op = 10;
fn =36;
a=4515;
b=777;

#5
op = 10;
fn =37;
a=80;
b=2;

#5
op = 10;
fn =42;
a=9584;
b=1888;


end

MIPSALU m1 (ctl, a, b, f, zero);
ALUcontol c1 (fn, op, ctl);

endmodule


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

