module readandwrite (clk, read, write, address_in, data_in, data_found, address_out);

  parameter ADDR_WIDTH  = 2; // Number of bits in a memory address
  parameter ADDR_DEPTH = (1 << ADDR_WIDTH); // Number of possible addresses
  parameter DATA_WIDTH = 4; // Number of bits in row of mememory content
  
  // ===== INPUTS =====
  input clk; // the system clock
  input read; // a boolean stating to read the data in data_in
  input write; // a boolean stating to write the data in data_in
  input[ADDR_WIDTH-1:0] address_in; //an address to be written to
  input [DATA_WIDTH-1:0]data_in; // data to be written to searched for
  
  // ===== OUTPUTS =====
  output reg data_found; // whether or not data_in was found
  output reg [ADDR_WIDTH-1:0] address_out; // the address of data_in

  // ===== LOCAL VARS =====

  integer i; // Counter variable
  reg [3:0] datastore[DATA_WIDTH-1:0]; // Memory storage
  reg found; // Whether data was found
  reg [ADDR_WIDTH-1:0] addr; // Memory address location

  // WRITE TO DATA STORE
  always @ (negedge clk) begin
    if (write)  begin          
      datastore[address_in] <= data_in;
    end
  end

  // SEARCH FOR DATA, RETURN ADDRESS AND 'FOUND' BIT
 always @(posedge clk) begin
    
    // Clear temporary address and found flag
    addr   = {ADDR_WIDTH{1'b0}};
    found  = 1'b0;
    
    if (read == 1'b1) begin
      
     // Loop through memory contents
     for (i=0; i<ADDR_DEPTH; i=i+1) begin
       // Store memory address of first instance where data matches.
        if ((data_in == datastore[i]) && !found) begin
          found = 1'b1;
          addr  = i;
        end
      end    
      
      // Set final output variables to local vars' values; 
      // Using local vars keeps wave output clean.
      address_out = addr;
      data_found = found;
    end
  end
  
endmodule
