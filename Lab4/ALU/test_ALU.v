`timescale 1ps / 1ps
module test_ALU;

wire [15:0] D_out;
reg [28:0] INST;
wire Over_Flow;
ALU alu(INST,D_out,Over_Flow);

initial	// Test stimulus
  begin
    #0  INST = 29'b00000010111001101000000000000; //and $5, $12, $13 ==> $5 = 4230 and 188 = 132 = 0x84
		#350 INST = 29'b00001110001011101000011111010; //andi $6, $5, 0xD0FA ==>$6 = 0x84 and 0xD0FA = 0x80
		#350 INST = 29'b01110001100000001000000000000; //SLT $3, $0, $1
		#350 INST = 29'b01110001100010000000000000000; //SLT $3, $1, $0
		#350 INST = 29'b00100000100100100000000000000; //add $1, $2, $4 ==> $1 = 20 + 62 = 0x52
		#350 INST = 29'b00100100101111011000000000000; //add $9, $7, $11 ==> $9 = 32767 + 4577 = 0x91E0 with over flow
 
  end
 
endmodule 