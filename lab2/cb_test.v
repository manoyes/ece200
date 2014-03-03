module cb_test;
  
  // ===== INPUTS =====
reg [7:0]A;
reg [7:0]B;

// ===== OUTPUTS =====
wire [1:0]C;

comparator_behavioral cbt(A,B,C);

initial begin
  A = 8'b00000000;  B = 8'b00000000;
  #10 A = 8'b00000001;
  #10 B = 8'b00000010;
  //#10 $finish;
end

initial
$monitor($time, "A=%b B=%b C=%b",A,B,C);

endmodule