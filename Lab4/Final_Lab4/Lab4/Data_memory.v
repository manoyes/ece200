module Data_memory(MemRead, MemWrite, address, WriteData, ReadData, mode);
output [15:0] ReadData;
input [15:0] address;
input [15:0] WriteData;
input mode;
input MemRead, MemWrite;
reg [7:0] Mem[0:65535];
reg [7:0] a1,a2;
initial $readmemb("DataMem.txt",Mem); 
initial
begin
a1 = 0;
a2 = 0;
end
always @(address)
begin
if(address!=0)
	if(MemRead==1)
	begin
		
		if(mode==0)
			begin
			#5 a1 = Mem[address];
			$display("Memory read from address %h value %h",address, a1);
			end
		else
		begin
			#5 a1 = Mem[address];
			a2 = Mem[address+1];
			$display("Memory read from address %h value %h",address, {a1, a2});
		end
	end
	else if (MemWrite==1)
	begin
		if(mode==0)
			begin
			#5 Mem[address] = WriteData[15:8];
			$display("Memory write in address %h value %h",address, WriteData[15:8]);
			end
		else
		begin
			#5 Mem[address] = WriteData[15:8];
			Mem[address+1] = WriteData[7:0];
			$display("Memory write in address %h value %h",address, {WriteData[15:8], WriteData[7:0]});
		end
	end
end
assign ReadData = mode==0? {a1, 8'b00000000} : {a1, a2};

endmodule