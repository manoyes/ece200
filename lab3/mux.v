module mux (data, immediate, sel, out);
  input [15:0] data;
  input [15:0] immediate;
  input sel;
  
  output [15:0] out;
  
  assign out = (sel) ? immediate : data;
  
endmodule
