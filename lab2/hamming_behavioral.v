module hamming_behavioral (A, B, C);
  
// ===== INPUTS =====
input [7:0] A, B;

output C;

reg [3:0]C;
integer i;

always @(A or B) begin

C = 0;

for (i = 0; i < 8; i = i +1) begin
  C = C + ((A[i] == B[i]) ? 0 : 1);
end

end
 
endmodule