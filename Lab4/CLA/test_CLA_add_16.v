`timescale 1ps / 1ps
module test_CLA_add_16;

wire [15:0] sum;
wire c_out;
reg [15:0] a,b;
reg c_in;
CLA_add_16 cla_adder(sum, c_out, a, b, c_in);

initial	// Test stimulus
  begin
    #10 a = 16'b0000111010111100; b = 16'b0000111010100100; c_in = 1'b0; //0x0EBC + 0x0EA4 = 0x1D60
		#10 a = 16'b0000101010101000; b = 16'b0001010110100100; c_in = 1'b0; //0x0AA8 + 0x15A4 = 0x204C
		#10 a = 16'b0001010001101110; b = 16'b0000010011010010; c_in = 1'b0; //0x146E + 0x04D2 = 0x1940
  end

endmodule 