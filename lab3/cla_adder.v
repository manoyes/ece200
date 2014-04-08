module claadder (a, b, s, overflow);

  // ===== INPUTS =====
  input [15:0]a;
  input [15:0]b;

  // ===== OUTPUTS =====
  output [15:0]s;
  output overflow;
  
  // ===== INTERNAL =====
  wire [15:0] p;
  wire [15:0] g;
  wire [15:0] c;
  
  assign g = a & b;
  assign p = a ^ b;
  
  assign c[0] = 0;
  assign c[15:1] = g[14:0] | (p[14:0] & c[14:0]);
  
  assign s = p ^ c;
  assign overflow = (a[15] & b[15] & ~s[15]) | (~a[15] & ~b[15] & s[15]);

endmodule