module RegFile (ReadData1,ReadData2,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,clk);

input clk;
input RegWrite;		//from control
input [4:0] ReadReg1;   //from instruction bus
input [4:0] ReadReg2;	//from instruction bus
input [4:0] WriteReg;	//from RegDst MUX
input [31:0] WriteData; //from instruction bus
output reg [31:0] ReadData1;
output reg [31:0] ReadData2;


reg [31:0] registers [0:31] ;

integer i;
integer file;

always @(posedge clk)
begin
//RegFile is supposed to read both regs
 ReadData1 <= registers[ReadReg1];
 ReadData2 <= registers[ReadReg2];
//write in register
if(RegWrite)
	registers[WriteReg]=WriteData;
end


initial				//to monitor registers contents in a file
begin

i=0;

file=$fopen("D:\MIPS/RegFile/FromRegFile.txt");
$fmonitor(file,"%b // %d \n ",registers[i],i );

for(i=0;i<31;i=i+1)
begin
#1
i=i;
end

end
endmodule
