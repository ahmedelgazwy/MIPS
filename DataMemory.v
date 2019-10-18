module DataMemory(ReadData,Address,WriteData,MemRead,MemWrite,clk);

input clk;
input MemRead;
input MemWrite;
input[15:0]Address;
input[31:0]WriteData;
output reg[31:0]ReadData;

reg[31:0]datamem[0:8191];
integer file;
integer i;

always @(posedge clk)		//at rising edge the data of the address is read
begin

 ReadData <= datamem[Address];

end

initial				//to fill the data memory from a file
begin

$readmemb("D:\MIPS/DataMemory/ToDataMem.txt",datamem);

end

initial				//to monitor data memory contents in a file
begin

i=0;

file=$fopen("D:\MIPS/DataMemory/FromDataMem.txt");
$fmonitor(file,"%b // %h \n ",datamem[i],i );

for(i=0;i<8191;i=i+1)
begin
#1
i=i;
end

end

endmodule
