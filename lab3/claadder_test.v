module claadder_test;
  
  // ===== INPUTS =====
  reg clk;
reg [15:0]a;
reg [15:0]b;

// ===== OUTPUTS =====
wire Overflow;
wire [15:0]s;

claadder adder(a, b, s, overflow);

initial begin
  clk = 0;

  a = 16'b1111111110100001;  // -95
  b = 16'b0000000100000000; // 256
  #10  // Result = 161, Oveflow = 0
  a = 16'b1111111111110000; // -16
  b = 16'b1111111111110000;// -16 
  #10  // Result = -32, Oveflow = 0
  a = 16'b0000000000100000; //  32
  b = 16'b0000000001000000; // 64
  #10 // Result = 96, Oveflow = 0
  a = 16'b1000001100000000; // -32000
  b = 16'b1000001100000000; //-32000
  #10 // Result = Junk, Overflow = 1
  a = 16'b0111110100000000; //32000
  b = 16'b0111110100000000; //32000
  #10 // Result = Junk, Overflow = 1
  $finish;
end

always
  #5 clk = !clk;

initial
$monitor($time, " a=%b b=%b s=%b overflow=%b",a, b, s, overflow);

endmodule

