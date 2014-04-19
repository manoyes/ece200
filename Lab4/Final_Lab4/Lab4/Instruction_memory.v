module Instruction_memory(Read_address, INST);
parameter filename = "test_fact.txt";
output [31:0] INST;
input [15:0] Read_address;
reg [7:0] Mem[0:65535];
reg [7:0] a1,a2,a3,a4;
initial $readmemb(filename,Mem); 

always @(Read_address)
begin
a1 = Mem[Read_address];
a2 = Mem[Read_address+1];
a3 = Mem[Read_address+2];
a4 = Mem[Read_address+3];
end
assign #5 INST = {a1, a2, a3, a4};
endmodule