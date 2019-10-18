module SignExtend16_32(Exiting,Entering);

input[15:0]Entering;
output wire[31:0]Exiting;

assign Exiting = {{16{Entering[15]}} ,Entering};

endmodule

/////////////////////////////////////////////////////////////////

module ShiftLeft32(Exiting,Entering);

input[31:0]Entering;
output wire[31:0]Exiting;

assign Exiting = {Entering[29:0],2'b00};

endmodule

////////////////////////////////////////////////////////////////

module ShiftLeft26_28(Exiting,Entering);

input[25:0]Entering;
output wire[27:0]Exiting;

assign Exiting = {Entering,2'b00};

endmodule

///////////////////////////////////////////////////////////////

module Concatenator(JumpAddress,Instruction,PCplus4);

input[27:0]Instruction;
input[31:28]PCplus4;
output wire[31:0]JumpAddress;

assign JumpAddress = {PCplus4,Instruction};


endmodule

////////////////////////////////////////////////////////////////

module Mux5(Out,In0,In1,Sel);

input [4:0]In0;
input [4:0]In1;
input Sel;
output reg [4:0]Out;

always@(Out,In0,In1,Sel)
begin
case(Sel)
1'b0: assign Out=In0;
1'b1: assign Out=In1;
default: assign Out=5'bxxxxx;
endcase
end
endmodule

//////////////////////////////////////////////////////////////

module Mux32(Out,In0,In1,Sel);

input [31:0]In0;
input [31:0]In1;
input Sel;
output reg [31:0]Out;

always@(Out,In0,In1,Sel)
begin
case(Sel)
1'b0: assign Out=In0;
1'b1: assign Out=In1;
default: assign Out=32'dx;
endcase
end
endmodule
///////////////////////////////////////////////////////////
module PCAdder(Out,In);

input [15:0]In;
output reg [31:0]Out;
always@(Out,In)
Out<=({16'd0,In}+4);

endmodule
///////////////////////////////////////////////////////////
module ShiftAdder(Out,In1,In2);
input [31:0]In1;
input [31:0]In2;
output reg [31:0]Out;
always@(Out,In1,In2)
Out<=(In1+In2);
endmodule