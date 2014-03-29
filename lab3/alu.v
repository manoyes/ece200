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

always @(negedge clk) begin

case (Control) 
4'b0000 : WriteData = ReadData1 & ReadData2;
4'b0001 : WriteData = ReadData1 | ReadData2;
4'b0010 : WriteData = ReadData1 + ReadData2;
4'b0110 : WriteData = ReadData1 - ReadData2; 
4'b0111 : WriteData = (ReadData1 < ReadData2 ? 1 : 0);
4'b1100 : WriteData = ~(ReadData1 | ReadData2);

  default : $display("Error in Control"); 
endcase 

end

endmodule