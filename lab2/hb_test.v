module hb_test;
  
  // ===== INPUTS =====
reg [7:0]A;
reg [7:0]B;

// ===== OUTPUTS =====
wire [3:0]C;

hamming_behavioral cbt(A,B,C);

initial begin
  A = 8'b00000000;  B = 8'b00000000; // C should be 0000
  #10 A = 8'b00000001; // C should be 0001
  #10 B = 8'b00000010; // C should be 0010
  #10 A = 8'b00001111; B = 8'b11110000; // C should be 1000
  #10 A = 8'b01010101; B = 8'b10101010; // // C should be 1000
  #10 $finish;
end

initial
$monitor($time, "A=%b B=%b C=%b",A,B,C);

endmodule