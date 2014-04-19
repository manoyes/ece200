module Main(clk, INST, D_out, new_address, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
input clk;

reg [15:0] address;
output [15:0] new_address;
output [31:0] INST;

reg [31:0] WriteData;
wire [31:0] ReadData;
reg[5:0] op_code;

output [15:0] D_out;
wire Over_Flow;
output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0;

Instruction_memory IM(address, INST);
Control cc(INST, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
ALU alu(INST,D_out,address,new_address,Over_Flow,RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
initial 
begin
address = 0;
end 

always @(posedge clk)
begin
address = new_address;
//$display("address = %h, INST = %h, ALU Output = %h",address, INST,D_out);
end
endmodule

