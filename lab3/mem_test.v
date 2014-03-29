module mem_test;  
  
  // ===== INPUTS =====
  reg clk;
  reg [3:0] ReadRgAddr1;
  reg [3:0] ReadRgAddr2;
  reg [3:0] WriteRgAddr;
  reg [15:0]WriteData;

// ===== OUTPUTS =====

wire [15:0]ReadData1;
wire [15:0]ReadData2;

 // counter U0 ( 
 //   .clk    (clk)
 // ); 

memory mem(clk, ReadRgAddr1, ReadRgAddr2, WriteRgAddr, WriteData, ReadData1, ReadData2);

initial begin
  
  clk = 0;
  
  ReadRgAddr1 = 4'b0000; ReadRgAddr2 = 4'b0001;
  #10 WriteRgAddr = 4'b0000; WriteData = 16'b0000000000000011;
  #10 WriteRgAddr = 4'b0001; WriteData = 16'b0000000000001111;
  #10 WriteRgAddr = 4'b0010; WriteData = 16'b1111111111111100;
  #10 WriteRgAddr = 4'b0011; WriteData = 16'b1111111111111111;
  #10 ReadRgAddr1 = 4'b0011; ReadRgAddr2 = 4'b0010;
  #10 $finish;
end

always
  #5 clk = !clk;

initial
$monitor($time, " ReadRgAddr1=%b ReadRgAddr2=%b WriteRgAddr=%b WriteData=%b ReadData1=%b ReadData2=%b",ReadRgAddr1,ReadRgAddr2,WriteRgAddr,WriteData,ReadData1,ReadData2);

endmodule