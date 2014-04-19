module Control(INST, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
input [31:0] INST;
reg [5:0] op_code,funct;
output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0;
reg [0:9] ot;
initial
ot=10'b0000000000;
always @(INST)
begin
op_code = INST[31:26];
funct = INST[5:0];
	case (op_code)
		6'b000000: 
			begin
			if(funct=='b001000)  //Only the special case for jr
					ot = 10'b1001000110;	//R-type (jr)
			else
					ot = 10'b1001000010;	//R-type
			end
		6'b100000: ot = 10'b0111100000;	//lb
		6'b100001: ot = 10'b0111100000;	//lh

		6'b101000: ot = 10'b0100010000;	//sb
		6'b101001: ot = 10'b0100010000;	//sh

		6'b000100: ot = 10'b0000001001;	//beq
		6'b000001: ot = 10'b0000001001;	//bgez

		6'b001000: ot = 10'b0101000011;	//I-type addi
		6'b001101: ot = 10'b0101000011;	//I-type ORi
		6'b001100: ot = 10'b0101000011;	//I-type andi
		6'b001010: ot = 10'b0101000011;	//I-type slti
		6'b001111: ot = 10'b0101000011;	//I-type lui

		6'b000010: ot = 10'b0000000100;	//j
		6'b000011: ot = 10'b0000000100;	//jal

	endcase
end
assign RegDst = ot[0];
assign ALUSrc = ot[1];
assign MemtoReg = ot[2];
assign RegWrite = ot[3];
assign MemRead = ot[4];
assign MemWrite = ot[5];
assign Branch = ot[6];
assign Jump = ot[7];
assign ALUOp1 = ot[8];
assign ALUOp0 = ot[9];
endmodule

