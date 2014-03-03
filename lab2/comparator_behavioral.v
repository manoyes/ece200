module comparator_behavioral (A, B, C);

// ===== INPUTS =====
input [7:0] A, B;

// ===== OUTPUTS =====
output C;

reg [1:0]C;

always @(A or B) begin
  
  if(A == B)
    C = 0;
  else if (A > B)
    C = 1;
  else
    C = 2;
end

endmodule