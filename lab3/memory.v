module memory(clk, ReadRgAddr1, ReadRgAddr2, WriteRgAddr, WriteData, ReadData1, ReadData2);
  
// ===== INPUTS =====
input clk;
input [3:0] ReadRgAddr1;
input [3:0] ReadRgAddr2;
input [3:0] WriteRgAddr;
input [15:0] WriteData;

// ===== OUTPUTS =====  

output ReadData1;
output ReadData2;

reg [15:0] ReadData1;
reg [15:0] ReadData2;

reg [15:0] datastore[15:0]; // Memory storage

  // WRITE TO DATA STORE
  always @ (negedge clk) begin    
    datastore[WriteRgAddr] <= WriteData;
  end
  
  // READ FROM DATA STORE
  always @ (posedge clk) begin
    ReadData1 <= datastore[ReadRgAddr1];
    ReadData2 <= datastore[ReadRgAddr2];
  end
  
endmodule
