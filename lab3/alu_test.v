module alu_test;
  
  // ===== INPUTS =====
  reg clk;
reg [15:0]ReadData1;
reg [15:0]ReadData2;
reg [3:0] Control;

// ===== OUTPUTS =====
wire Overflow;
wire [15:0]WriteData;

alu myalu(clk,ReadData1,ReadData2,Control,Overflow,WriteData);

initial begin
  clk = 0;

  ReadData1 = 16'b0000111100001111;  
  ReadData2 = 16'b1111000011110000;
  Control = 4'b0000;
  #10 Control = 4'b0001;
  #10 Control = 4'b0010;
  #10 Control = 4'b0110; 
  #10 Control = 4'b0111;
  #10 Control = 4'b1100;
  #10 $finish;
end

always
  #5 clk = !clk;

initial
$monitor($time, " Control=%b WriteData=%b ",Control,WriteData);

endmodule