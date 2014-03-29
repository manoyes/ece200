module mux_test;
  
  // ===== INPUTS =====
  reg clk;
reg [15:0]data;
reg [15:0]immediate;
reg sel;

// ===== OUTPUTS =====
wire [15:0]out;

mux m(data,immediate,sel,out);

initial begin
  data = 16'b1111111111111111;
  immediate = 16'b0000000000000011;
  sel = 0;
  #10 sel = 1;
  #10 $finish;
end

initial
$monitor($time, " sel=%b out=%b ",sel,out);

endmodule
