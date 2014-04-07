module code_gen;
  
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
  
  ReadRgAddr1 = 4'b0000; // $zero
  ReadRgAddr2 = 4'b0010; // t = $t1
  WriteRgAddr = 4'b0010; 
  Control = 4'b0010; // ADD
  
  // addi $t1, $zero, 0
  sel = 1;
  immediate = 16'b0000000000000000;
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // i = 0
    
  // add $t0, $t0, $t1
   sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001;   
      
  // addi $t1, $t1, 1    
   immediate = 16'b0000000000000001;
      sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // i = 1
  
  // add $t0, $t0, $t1
 sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 
      
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
      
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
      
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
    // i = 2
  
  // add $t0, $t0, $t1
  sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 
  
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;

  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
    // i = 3
  
  // add $t0, $t0, $t1
   sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 
      
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
      
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
    // i = 4
  
  // add $t0, $t0, $t1
  sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 

  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // i = 5
  
  // add $t0, $t0, $t1
  sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 
  
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
      
  // i = 6
  
  // add $t0, $t0, $t1
   sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 

  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
      
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;

  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
        
  // i = 7
  
  // add $t0, $t0, $t1
  sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 

  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // addi $t1, $t1, 1    
  sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // i = 8
  
  // add $t0, $t0, $t1
   sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 
  
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // addi $t1, $t1, 1    
   sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;

  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  // i = 9
  
  // add $t0, $t0, $t1
   sel = 0;   
      ReadRgAddr1 = 4'b0001; // s = $t0
      WriteRgAddr = 4'b0001; 
      
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
      
  // addi $t1, $t1, 1    
   sel = 1;   
      ReadRgAddr1 = 4'b0010;
      WriteRgAddr = 4'b0010;
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
  
  // i = 10
      
  // ======================== PROGRAM ENDS ========================
  
  // Now, read value of s to make sure it is correct (expected value: 45)
   WriteRgAddr = 4'b0000;
      ReadRgAddr1 = 4'b0001; // s
      ReadRgAddr2 = 4'b0010; // i
  @(posedge clk)
  @(posedge clk)
  @(negedge clk)
   $display ("s val is: %b, i val is: %b",ReadData1, ReadData2);
    @(posedge clk)
  @(posedge clk)
  @(negedge clk)
      $finish;
end

always 
  begin 
    #1 clk = ~clk;
  end
  
  initial
  $monitor($time, "ReadData1=%b, ReadData2=%b", ReadData1,ReadData2);

endmodule
