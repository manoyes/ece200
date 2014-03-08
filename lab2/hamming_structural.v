module hamming_structural (A, B, C);

// ===== INPUTS =====
input [7:0] A, B;

// ===== OUTPUTS =====
output [3:0]C;

  assign C = (A[0] ^ B[0]) +
      (A[1] ^ B[1]) +
      (A[2] ^ B[2]) + 
      (A[3] ^ B[3]) + 
      (A[4] ^ B[4]) + 
      (A[5] ^ B[5]) + 
      (A[6] ^ B[6]) + 
      (A[7] ^ B[7]);
 
endmodule