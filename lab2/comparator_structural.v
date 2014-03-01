module comparator_structural (A, B, C);

// ===== INPUTS =====
input [7:0] A, B;

// ===== OUTPUTS =====
output [1:0] C;

assign C[0] = (A & ~B);
assign C[1] = (~A & B);

endmodule
