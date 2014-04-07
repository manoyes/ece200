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

wire [15:0] add_out; 
wire [15:0] add_of_out; 

wire [15:0] sub_out; 
wire [15:0] sub_of_out; 

claadder adder(
.a        (ReadData1),
.b        (ReadData2),
.s        (add_out),
.overflow (add_of_out)
);

claadder subber(
.a        (ReadData1),
.b        (~ReadData2 + 1),
.s        (sub_out),
.overflow (sub_of_out)
);

always @(posedge clk) begin

case (Control) 
4'b0000 : WriteData = ReadData1 & ReadData2; // AND
4'b0001 : WriteData = ReadData1 | ReadData2; // OR
4'b0010 : 
begin 
  WriteData = add_out; 
  Overflow = add_of_out; 
end // ADD
4'b0110 :
begin 
  WriteData = sub_out; 
  Overflow = sub_of_out; 
end // SUB
4'b0111 : WriteData = ($signed(ReadData1) < $signed(ReadData2) ? 1 : 0); // SLT
4'b1100 : WriteData = ~(ReadData1 | ReadData2); // NOR
endcase 

end

endmodule