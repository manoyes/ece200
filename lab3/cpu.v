module cpu;

integer DELAY = 30;

// ===== INPUTS =====
reg clk;
reg rst;
reg [3:0] ReadRgAddr1;
reg [3:0] ReadRgAddr2;
reg [3:0] WriteRgAddr;
wire [15:0] WriteData;

reg [15:0] immediate;
reg sel;

reg [3:0] Control;


// ===== OUTPUTS =====
wire [15:0] ReadData1;
wire [15:0] ReadData2;
wire [15:0] mux_out;
wire Overflow;

memory mem (
.clk          (clk),
.rst          (rst),
.ReadRgAddr1  (ReadRgAddr1), 
.ReadRgAddr2  (ReadRgAddr2), 
.WriteRgAddr  (WriteRgAddr), 
.WriteData    (WriteData), 
.ReadData1    (ReadData1), 
.ReadData2    (ReadData2)
);

mux m2amux(
.data       (ReadData2), 
.immediate  (immediate), 
.sel        (sel), 
.out        (mux_out)
);

alu myalu(
.clk        (clk),
.ReadData1  (ReadData1), 
.ReadData2  (mux_out), 
.Control    (Control), 
.Overflow   (Overflow), 
.WriteData  (WriteData)
);

initial begin
  clk = 0; 
  ReadRgAddr1 = 4'b0000;
  ReadRgAddr2 = 4'b0010;
  WriteRgAddr = 4'b0001; // Write 3 to R1
  immediate = 16'b0000000000000011; 
  sel = 1; 
  Control = 4'b0010;
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  immediate = 16'b0000000000001111; 
      WriteRgAddr = 4'b0010; // Write 15 to R2
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
        
  sel = 0; 
      ReadRgAddr1 = 4'b0001; 
      WriteRgAddr = 4'b0011; 
      Control = 4'b0000; // R3 = R1 & R2
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  WriteRgAddr = 4'b0100; 
      Control = 4'b0001; // R4 = R1 | R2
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  WriteRgAddr = 4'b0101; 
  
   Control = 4'b0010; // R5 = R1 + R2
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  WriteRgAddr = 4'b0110; 
      Control = 4'b0110; // R6 = R1 - R2
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  WriteRgAddr = 4'b0111; 
      Control = 4'b0111; // R7 = (R1 < R2) ? 1 : 0

  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  WriteRgAddr = 4'b1000; 
      Control = 4'b1100; // R8 = R1 ~| R2
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  // Stop Writes by "writing to 0"
  WriteRgAddr = 4'b0000;
  
  $display("============================================================");
  
  // Now Iterate through memory and Read Values
       ReadRgAddr1 = 4'b0011; // Expected = 0000000000000011
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  $display("============================================================");
       ReadRgAddr1 = 4'b0100; // Expected = 0000000000001111
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  $display("============================================================");
       ReadRgAddr1 = 4'b0101; // Expected = 0000000000010010
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  $display("============================================================");
       ReadRgAddr1 = 4'b0110; // Expected = 1111111111110100
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  $display("============================================================");
       ReadRgAddr1 = 4'b0111; // Expected = 0000000000000001
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
    
  $display("============================================================");
       ReadRgAddr1 = 4'b1000; // Expected = 1111111111110000
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
   $finish;
end

always
  #5 clk = !clk;

initial
  $monitor($time, " ReadRgAddr1=%b, ReadData1=%b", ReadRgAddr1,ReadData1);

endmodule
