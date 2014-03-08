module cb_test;
  
  // ===== INPUTS =====
reg [7:0]A;
reg [7:0]B;

// ===== OUTPUTS =====
wire [1:0]C;

comparator_behavioral cbt(A,B,C);

initial begin
  A = 8'b00000000;  B = 8'b00000000; // C should be 00
  #10 A = 8'b00000001; B = 8'b00000001; // C should be 00
  #10 A = 8'b00000010; // C should be 01
  #10 B = 8'b00000100; // C should be 10
  #10 A = 8'b11111110; // C should be 01
  #10 $finish;
end

initial
$monitor($time, "A=%b B=%b C=%b",A,B,C);

endmodule