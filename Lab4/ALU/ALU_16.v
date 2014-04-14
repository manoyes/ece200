`timescale 1ps / 1ps
module ALU(INST,D_out,Over_Flow);
output [15:0] D_out;
output Over_Flow;
input [28:0] INST;
reg [15:0] Registers[0:15];
reg OF;
reg [4:0] op_code;
reg [3:0] funct;
reg [3:0] op1_addr, op2_addr, result_addr;
reg [15:0] op1_val, op2_val,result_val;
initial // we will put some values in the registers to test the ALU
begin
Registers[0'b0000] = 0;
Registers[0'b0001] = 10;
Registers[0'b0010] = 20;
Registers[0'b0011] = 34;
Registers[0'b0100] = 62;
Registers[0'b0101] = 2240;
Registers[0'b0110] = 407;
Registers[0'b0111] = 32767;
Registers[0'b1000] = 15;
Registers[0'b1001] = 13;
Registers[0'b1010] = 2240;
Registers[0'b1011] = 4577;
Registers[0'b1100] = 4230;
Registers[0'b1101] = 188;
Registers[0'b1110] = 131;
Registers[0'b1111] = 156;
end

always @(INST)
begin
op_code = INST[28:24];
result_addr = INST[23:20];
op1_addr = INST[19:16];
OF = 0;
#50 op1_val = Registers[op1_addr]; //assume it will get the 2 operands after this delay
 if(op_code[0]==0) //R-type instruction
	begin
	op2_addr = INST[15:12];
  op2_val = Registers[op2_addr];
	end
else							// I-type instruction
	op2_val = INST[15:0];

funct = INST[28:25];

#200 case (funct) //delay for the ALU 
	4'b0000 : result_val = op1_val & op2_val; // AND
	4'b0001 : result_val = op1_val | op2_val; // OR
	4'b0010 : 
			begin 
				result_val = op1_val + op2_val; // ADD
				if((op1_val[15]==op2_val[15])&&(result_val[15]==~op1_val[15])) //check for over flow
					OF = 1;
			end
	4'b0110 : 
			begin 	
				result_val = op1_val - op2_val; // SUB
			  if((op1_val[15]==~op2_val[15])&&(result_val[15]!=op1_val[15])) //check for over flow
					OF = 1;
			end
	4'b0111 : result_val = (op1_val<op2_val)? 1 : 0; // SLT
	4'b1100 : result_val = ~(op1_val | op2_val); // NOR
endcase
Registers[result_addr] = result_val;
end 
assign #50 {D_out, Over_Flow} = {result_val , OF}; //allow delay for writing the result to the register file
endmodule