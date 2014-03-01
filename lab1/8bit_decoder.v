module decoder (in,out);
  input in;
  output out;
  
  wire[2:0] in;
  wire[8:0] out;
  
  // Assign the decoder output
  assign out[8] = ( in[2]  &  in[1] &  in[0]);
  assign out[7] = ( in[2]  &  in[1] & ~in[0]);
  assign out[6] = ( in[2]  & ~in[1] &  in[0]);
  assign out[5] = ( in[2]  & ~in[1] & ~in[0]);
  assign out[4] = (~in[2]  &  in[1] &  in[0]);
  assign out[3] = (~in[2]  &  in[1] & ~in[0]);
  assign out[2] = (~in[2]  & ~in[1] &  in[0]);
  assign out[1] = (~in[2]  & ~in[1] & ~in[0]);
  
  // Assign parity bit  
  assign out[0] = ^out[8:1];

endmodule