module comparator_structural (A, B, C);

// ===== INPUTS =====
input [7:0] A, B;

// ===== OUTPUTS =====
output [1:0] C;
wire[7:0] eq;

assign eq = (A & B) | (~A & ~B);

// (A > B)
assign C[0] = (A[7] & ~B[7]) |
              (A[6] & ~B[6] & eq[7]) |
              (A[5] & ~B[5] & eq[7] & eq[6]) |
              (A[4] & ~B[4] & eq[7] & eq[6] & eq[5]) |
              (A[3] & ~B[3] & eq[7] & eq[6] & eq[5] & eq[4]) |
              (A[2] & ~B[2] & eq[7] & eq[6] & eq[5] & eq[4] & eq[3]) |
              (A[1] & ~B[1] & eq[7] & eq[6] & eq[5] & eq[4] & eq[3] & eq[2]) |
              (A[0] & ~B[0] & eq[7] & eq[6] & eq[5] & eq[4] & eq[3] & eq[2] & eq[1]);
                            
// (A < B)
assign C[1] = (~A[7] & B[7]) |
              (~A[6] & B[6] & eq[7]) |
              (~A[5] & B[5] & eq[7] & eq[6]) |
              (~A[4] & B[4] & eq[7] & eq[6] & eq[5]) |
              (~A[3] & B[3] & eq[7] & eq[6] & eq[5] & eq[4]) |
              (~A[2] & B[2] & eq[7] & eq[6] & eq[5] & eq[4] & eq[3]) |
              (~A[1] & B[1] & eq[7] & eq[6] & eq[5] & eq[4] & eq[3] & eq[2]) |
              (~A[0] & B[0] & eq[7] & eq[6] & eq[5] & eq[4] & eq[3] & eq[2] & eq[1]);
endmodule
