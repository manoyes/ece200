`timescale 1ps / 1ps
module test_lab4;
reg clk;
wire [31:0] INST;
wire [15:0] new_address, D_out;
wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0;
Main main(clk, INST, D_out, new_address, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
initial // Clock generator
  begin
    clk = 0;
    forever #40 clk = !clk;
  end
endmodule