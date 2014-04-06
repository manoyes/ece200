module alu (clk, ReadData1, ReadData2, Control, Overflow, WriteData);

// ===== INPUTS =====
input clk;
input [15:0] ReadData1;
input [15:0] ReadData2;
input [3:0] Control;

// ===== OUTPUTS =====
output Overflow;
output WriteData;

reg Overflow;
reg [15:0] WriteData;

reg [15:0] adder_out; 
reg [15:0] overflow_out; 


//claadder cla(ReadData1,ReadData2,adder_out,overflow_out);

always @(negedge clk) begin

case (Control) 
4'b0000 : WriteData = ReadData1 & ReadData2; // AND
4'b0001 : WriteData = ReadData1 | ReadData2; // OR
4'b0010 : WriteData = ReadData1 + ReadData2;
//begin 
//  WriteData = adder_out; 
//  Overflow = overflow_out; 
//end // ADD
4'b0110 : WriteData = ReadData1 - ReadData2; // SUB
4'b0111 : WriteData = (ReadData1 < ReadData2 ? 1 : 0); // SLT
4'b1100 : WriteData = ~(ReadData1 | ReadData2); // NOR

default : $display("Error in Control"); 
endcase 

end

endmodule