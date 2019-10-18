
module InstructionMemory(Instruction,ReadAdd,clk);

input clk;                   //the instruction is constant within the cycle
 input [31:0]ReadAdd;         //4 hexadicimal digits from pc
output reg [31:0]Instruction;

reg[31:0]instmem[0:8191];
integer file;
integer i;

always @(posedge clk)		//at rising edge the instruction is read
begin

 Instruction <= instmem[ReadAdd];

end

initial				//to fill the instruction memory from a file
begin

$readmemb("D:\MIPS/InstructionMemory/ToInstMem.txt",instmem);

end

initial				//to monitor memory contents in a file
begin

i=0;

file=$fopen("D:\MIPS/InstructionMemory/FromInstMem.txt");
$fmonitor(file,"%b // %h \n ",instmem[i],i );

for(i=0;i<8191;i=i+1)
begin
#1
i=i;
end

end
endmodule
