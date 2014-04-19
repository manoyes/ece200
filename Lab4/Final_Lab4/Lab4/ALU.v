<<<<<<< HEAD:Lab4/Final_Lab4/Lab4/ALU.v
module ALU(INST,D_out,Old_PC,New_PC,Over_Flow,RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
output [15:0] D_out;
output Over_Flow;
input[15:0] Old_PC;
output[15:0] New_PC;
reg[15:0] PC_4,PC_immediate,Jump_target;
reg ALU_op_zero;
input [31:0] INST;
input RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0;
reg [15:0] Registers[0:15];
wire [15:0] DataMemory_ReadData;
reg OF;
reg [5:0] op_code, funct;
reg [4:0] op1_addr, op2_addr, op3_addr, shamt;
reg [15:0] ReadData1, ReadData2,Alu_output, Alu_operand2, Effective_address, DataMemory_WriteData;
reg [15:0] Immed;
reg mode;
reg [31:0] Prod_reg;

Data_memory DM(MemRead, MemWrite, Effective_address, DataMemory_WriteData, DataMemory_ReadData, mode);
initial // we will put some values in the registers to test the ALU
begin
Registers[4'b0000] = 0;
Registers[4'b0001] = 10;
Registers[4'b0010] = 20;
Registers[4'b0011] = 30;
Registers[4'b0100] = 40;
Registers[4'b0101] = 50;
Registers[4'b0110] = 60;
Registers[4'b0111] = 70;
Registers[4'b1000] = 80;
Registers[4'b1001] = 90;
Registers[4'b1010] = 100;
Registers[4'b1011] = 110;
Registers[4'b1100] = 120;
Registers[4'b1101] = 500;
Registers[4'b1110] = 140;
Registers[4'b1111] = 9999;
end

always @(INST)
begin
op_code = INST[31:26];
op1_addr = INST[25:21];
#2 ReadData1 = Registers[op1_addr];
op2_addr = INST[20:16];
ReadData2 = Registers[op2_addr];

op3_addr = RegDst==0?INST[20:16]:INST[15:11];
shamt = INST[10:6];
funct = INST[5:0];
OF = 0;
Immed = INST[15:0];
Alu_operand2 = ALUSrc==0?ReadData2:Immed;
PC_4 = Old_PC + 4;
PC_immediate = PC_4 + 4*Immed;
Jump_target = 4*Immed;
ALU_op_zero = 0;

if ({ALUOp1, ALUOp0}==2'b00)
begin
 Alu_output = ReadData1 + Alu_operand2;
if(Jump==1'b0) //is it a Jump
begin
	case (op_code) // load or store
		6'b100000: //lb
			begin
				mode = 0;
				Effective_address = Alu_output;
			end
		6'b100001: //lh
			begin
				mode = 1;
				Effective_address = Alu_output;
			end

		6'b101000: //sb
			begin
				mode = 0;
				DataMemory_WriteData = ReadData2;
				Effective_address = Alu_output;
			end
		6'b101001: //sh
			begin
				mode = 1;
				DataMemory_WriteData = ReadData2;
				Effective_address = Alu_output;
			end
	endcase
#6 Effective_address = 0; //wait until memory data is ready
end
else  //Jump type
	begin
		case (op_code) 
		6'b000011: // jal
			begin
				Registers[4'b1111] = PC_4; //save the next address in register 15 ($ra)
			end
		endcase
	end
end
else if ({ALUOp1, ALUOp0}==2'b01) // beq instruction
begin
		case (op_code) 
			6'b000100 : 
				begin
					Alu_output = ReadData1 - Alu_operand2; // beq
					ALU_op_zero = Alu_output==0?1:0;
				end
			6'b000001 : 
				begin
					Alu_output = ReadData1; // bgez
					ALU_op_zero = (Alu_output[15]==1'b0)?1:0;
				end
		endcase
end
if ({ALUOp1, ALUOp0}==2'b11) //I-type as addi, ori, ..
begin
case (op_code) // which I-type instruction
			6'b001100 : Alu_output = ReadData1 & Alu_operand2; // ANDi
			6'b001101 : Alu_output = ReadData1 | Alu_operand2; // ORi
			6'b001000 : 
					begin
						Alu_output = ReadData1 + Alu_operand2; // ADDi
						if((ReadData1[15]==Alu_operand2[15])&&(Alu_output[15]==~ReadData1[15])) //check for over flow
							OF = 1;
					end
			6'b001010 : Alu_output = (ReadData1<Alu_operand2)? 1 : 0; // SLTi
			6'b001111 : Alu_output = Alu_operand2; // lui
		endcase
end
else if ({ALUOp1, ALUOp0}==2'b10)  //R-Type, op_code is 0
	begin
#2  case (funct) //
			6'b100100 : Alu_output = ReadData1 & Alu_operand2; // AND
			6'b100101 : Alu_output = ReadData1 | Alu_operand2; // OR
			6'b100000 : 
					begin
						Alu_output = ReadData1 + Alu_operand2; // ADD
						if((ReadData1[15]==Alu_operand2[15])&&(Alu_output[15]==~ReadData1[15])) //check for over flow
							OF = 1;
					end
			6'b100010 : 
					begin 	
						Alu_output = ReadData1 - Alu_operand2; // SUB
					  if((ReadData1[15]==~Alu_operand2[15])&&(Alu_output[15]!=ReadData1[15])) //check for over flow
							OF = 1;
					end
			6'b101010 : Alu_output = (ReadData1<Alu_operand2)? 1 : 0; // SLT
			6'b100111 : Alu_output = ~(ReadData1 | Alu_operand2); // NOR
			6'b011000 : Prod_reg = ReadData1 * Alu_operand2; // mult
			6'b011010 : 
				begin
					Prod_reg[31:16] = ReadData1 % Alu_operand2; // div
					Prod_reg[15:0] = ReadData1 / Alu_operand2;
				end
			6'b010000 : Alu_output = Prod_reg[31:16]; // mfhi
			6'b010010 : Alu_output = Prod_reg[15:0]; // mflo

			6'b000000 : Alu_output = Alu_operand2<<shamt; // sll
			6'b000010 : Alu_output = Alu_operand2>>shamt; // srl

			6'b001000 : Jump_target = ReadData1; // jr
		endcase
	end 
if((RegWrite==1)&(op3_addr!=0))
	begin
	  #2 Registers[op3_addr] = MemtoReg==0?Alu_output:DataMemory_ReadData;
		$display("Register %h written by a value of %h",op3_addr, MemtoReg==0?Alu_output:DataMemory_ReadData);
	end

$display("Old_PC = %h, INST = %h, ALU Output = %h",Old_PC, INST,D_out);
end
assign New_PC = Jump? Jump_target : ((ALU_op_zero&Branch)? PC_immediate:PC_4);
assign {D_out, Over_Flow} = {MemtoReg==0?Alu_output:DataMemory_ReadData , OF}; 
endmodule





=======
`timescale 1ps / 1ps

// -----------------------------------------------------------------------------
// ASSIGNMENT: ECE 200 LAB 4
// AUTHORS : AHMED ABDEL FATAH & MATTHEW NOYES
// -----------------------------------------------------------------------------
// PURPOSE : IMPLEMENTATION OF ECE 200 LAB 4, RISC CPU
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// MODULE: test_lab4
// -----------------------------------------------------------------------------
// PURPOSE : Test implementation of Lab 4, RISC CPU and define clock.
// -----------------------------------------------------------------------------
// INPUTS
// -----------------------------------------------------------------------------
// OUTPUTS
// -----------------------------------------------------------------------------

module test_lab4;

  reg clk;
  wire [31:0] INST;
  wire [15:0] new_address, D_out;

  Lab4 ll(clk, INST, D_out, new_address);

  // Clock generator
  initial begin
    clk = 0;
    forever #40 clk = !clk;
  end
endmodule // test_lab4

// -----------------------------------------------------------------------------
// MODULE: Lab4
// -----------------------------------------------------------------------------
// PURPOSE : Implementation of Lab 4, RISC CPU
// -----------------------------------------------------------------------------
// INPUTS
// clk         : system clock
// INST [31,0] : 32-bit instruction to execute
// -----------------------------------------------------------------------------
// OUTPUTS
// D_out [15,0]       :
// new_address [15,0] :
// -----------------------------------------------------------------------------

module Lab4(clk, INST, D_out, new_address);
  input clk;

  output [15:0] new_address;
  output [31:0] INST;
  
  reg [15:0] address;

  reg [31:0] WriteData;
  wire [31:0] ReadData;
  reg[5:0] op_code;

  output [15:0] D_out;
  wire Over_Flow;

  Instruction_memory IM(address, INST);
  ALU alu(INST,D_out,address,new_address,Over_Flow);

  initial begin
    address = 0;
  end 

  always @(posedge clk) begin
    address = new_address;
    //$display("address = %h, INST = %h, ALU Output = %h",address, INST,D_out);
  end
endmodule // Lab4

// -----------------------------------------------------------------------------
// MODULE: Control
// -----------------------------------------------------------------------------
// PURPOSE : Manages all control lines for CPU
// -----------------------------------------------------------------------------
// INPUTS
// INST [31,0]  : 32-bit instruction to execute
// -----------------------------------------------------------------------------
// OUTPUTS
// RegDst       :
// ALUSrc       :
// MemtoReg     :
// RegWrite     :
// MemRead      :
// MemWrite     :
// Branch       :
// Jump         :
// ALUOp1       :
// ALUOp0       :
// -----------------------------------------------------------------------------

module Control(INST, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
  input [31:0] INST;
  reg [5:0] op_code,funct;
  output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0;
  reg [0:9] ot;
  
  initial
    ot=10'b0000000000;
  
  always @(INST) begin
    op_code = INST[31:26];
    funct = INST[5:0];
  	 case (op_code)
      6'b000000: begin
        if(funct=='b001000)  //Only the special case for jr
					ot = 10'b1001000110;	//R-type (jr)
        else
					ot = 10'b1001000010;	//R-type
      end
		  
		  6'b100000: ot = 10'b0111100000;	//lb
    		6'b100001: ot = 10'b0111100000;	//lh

		  6'b101000: ot = 10'b0100010000;	//sb
		  6'b101001: ot = 10'b0100010000;	//sh

		  6'b000100: ot = 10'b0000001001;	//beq
 	   	6'b000001: ot = 10'b0000001001;	//bgez

		  6'b001000: ot = 10'b0101000011;	//I-type addi
		  6'b001101: ot = 10'b0101000011;	//I-type ORi
		  6'b001100: ot = 10'b0101000011;	//I-type andi
		  6'b001010: ot = 10'b0101000011;	//I-type slti
		  6'b001111: ot = 10'b0101000011;	//I-type lui

		  6'b000010: ot = 10'b0000000100;	//j
		  6'b000011: ot = 10'b0000000100;	//jal

	   endcase
  end
  
  assign RegDst = ot[0];
  assign ALUSrc = ot[1];
  assign MemtoReg = ot[2];
  assign RegWrite = ot[3];
  assign MemRead = ot[4];
  assign MemWrite = ot[5];
  assign Branch = ot[6];
  assign Jump = ot[7];
  assign ALUOp1 = ot[8];
  assign ALUOp0 = ot[9];
endmodule // Control

// -----------------------------------------------------------------------------
// MODULE: ALU
// -----------------------------------------------------------------------------
// PURPOSE : Arithmetic Logic Unit imeplementation
// -----------------------------------------------------------------------------
// INPUTS
// INST [31,0]  : 32-bit instruction to execute
// Old_PC       :
// -----------------------------------------------------------------------------
// OUTPUTS
// D_out [15,0] :
// Over_Flow    :
// New_PC       :
// -----------------------------------------------------------------------------

module ALU(INST, D_out, Old_PC, New_PC, Over_Flow);
  
  input [31:0] INST;
  input[15:0] Old_PC;
  
  output [15:0] D_out;
  output Over_Flow;
  output[15:0] New_PC;
  
  reg[15:0] PC_4,PC_immediate,Jump_target;
  reg ALU_op_zero;
  
  wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0;
  reg [15:0] Registers[0:15];
  wire [15:0] DataMemory_ReadData;
  reg OF;
  reg [5:0] op_code, funct;
  reg [4:0] op1_addr, op2_addr, op3_addr, shamt;
  reg [15:0] ReadData1, ReadData2,Alu_output, Alu_operand2, Effective_address, DataMemory_WriteData;
  reg [15:0] Immed;
  reg mode;
  reg [31:0] Prod_reg;
  
  Control cc(INST, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0);
  Data_memory DM(MemRead, MemWrite, Effective_address, DataMemory_WriteData, DataMemory_ReadData, mode);
  
  // we will put some values in the registers to test the ALU
  initial begin
    Registers[4'b0000] = 0;
    Registers[4'b0001] = 10;
    Registers[4'b0010] = 20;
    Registers[4'b0011] = 30;
    Registers[4'b0100] = 40;
    Registers[4'b0101] = 50;
    Registers[4'b0110] = 60;
    Registers[4'b0111] = 70;
    Registers[4'b1000] = 80;
    Registers[4'b1001] = 90;
    Registers[4'b1010] = 100;
    Registers[4'b1011] = 110;
    Registers[4'b1100] = 120;
    Registers[4'b1101] = 500;
    Registers[4'b1110] = 140;
    Registers[4'b1111] = 9999;
  end

  always @(INST) begin
    op_code = INST[31:26];
    op1_addr = INST[25:21];
    #2 ReadData1 = Registers[op1_addr];
    op2_addr = INST[20:16];
    ReadData2 = Registers[op2_addr];

    op3_addr = RegDst==0?INST[20:16]:INST[15:11];
    shamt = INST[10:6];
    funct = INST[5:0];
    OF = 0;
    Immed = INST[15:0];
    Alu_operand2 = ALUSrc==0?ReadData2:Immed;
    PC_4 = Old_PC + 4;
    PC_immediate = PC_4 + 4*Immed;
    Jump_target = 4*Immed;
    ALU_op_zero = 0;

    if ({ALUOp1, ALUOp0}==2'b00) begin
      Alu_output = ReadData1 + Alu_operand2;
      //is it a Jump
      if(Jump==1'b0) begin
        case (op_code) // load or store
          6'b100000: begin //lb			
  				    mode = 0;
				    Effective_address = Alu_output;
          end
        
          6'b100001: begin //lh
            mode = 1;
            Effective_address = Alu_output;
          end

          6'b101000: begin //sb
            mode = 0;
            DataMemory_WriteData = ReadData2;
            Effective_address = Alu_output;
          end
        
          6'b101001: begin //sh
            mode = 1;
            DataMemory_WriteData = ReadData2;
            Effective_address = Alu_output;
          end
        endcase
        #6 Effective_address = 0; //wait until memory data is ready
      end
  
      else begin //Jump type
  	
		    case (op_code) 
		      6'b000011: begin // jal
            Registers[4'b1111] = PC_4; //save the next address in register 15 ($ra)
          end
		    endcase
      end
    end

    else if ({ALUOp1, ALUOp0}==2'b01) begin // beq instruction
      case (op_code) 
        6'b000100 : begin
          Alu_output = ReadData1 - Alu_operand2; // beq
				  ALU_op_zero = Alu_output==0?1:0;
        end
        6'b000001 : begin
          Alu_output = ReadData1; // bgez
				  ALU_op_zero = (Alu_output[15]==1'b0)?1:0;
        end
		  endcase
    end
  
    if ({ALUOp1, ALUOp0}==2'b11) begin //I-type as addi, ori, ..
      case (op_code) // which I-type instruction
        6'b001100 : Alu_output = ReadData1 & Alu_operand2; // ANDi
        6'b001101 : Alu_output = ReadData1 | Alu_operand2; // ORi
        6'b001000 : begin
          Alu_output = ReadData1 + Alu_operand2; // ADDi
          if((ReadData1[15]==Alu_operand2[15])&&(Alu_output[15]==~ReadData1[15])) //check for over flow
            OF = 1;
				  end
        6'b001010 : Alu_output = (ReadData1<Alu_operand2)? 1 : 0; // SLTi
        6'b001111 : Alu_output = Alu_operand2; // lui
		  endcase
    end
    else if ({ALUOp1, ALUOp0}==2'b10) 	begin //R-Type, op_code is 0
      #2  case (funct) //
            6'b100100 : Alu_output = ReadData1 & Alu_operand2; // AND
            6'b100101 : Alu_output = ReadData1 | Alu_operand2; // OR
            6'b100000 : begin
              Alu_output = ReadData1 + Alu_operand2; // ADD
              if((ReadData1[15]==Alu_operand2[15])&&(Alu_output[15]==~ReadData1[15])) //check for over flow
                OF = 1;
              end
            6'b100010 : begin
              Alu_output = ReadData1 - Alu_operand2; // SUB
              if((ReadData1[15]==~Alu_operand2[15])&&(Alu_output[15]!=ReadData1[15])) //check for over flow
                OF = 1;
              end
            6'b101010 : Alu_output = (ReadData1<Alu_operand2)? 1 : 0; // SLT
            6'b100111 : Alu_output = ~(ReadData1 | Alu_operand2); // NOR
            6'b011000 : Prod_reg = ReadData1 * Alu_operand2; // mult
            6'b011010 : begin
              Prod_reg[31:16] = ReadData1 % Alu_operand2; // div
              Prod_reg[15:0] = ReadData1 / Alu_operand2;
            end
            6'b010000 : Alu_output = Prod_reg[31:16]; // mfhi
            6'b010010 : Alu_output = Prod_reg[15:0]; // mflo

            6'b000000 : Alu_output = Alu_operand2<<shamt; // sll
            6'b000010 : Alu_output = Alu_operand2>>shamt; // srl

            6'b001000 : Jump_target = ReadData1; // jr
      endcase
    end 
  
    if((RegWrite==1)&(op3_addr!=0)) begin
      #2 Registers[op3_addr] = MemtoReg==0?Alu_output:DataMemory_ReadData;
      $display("Register %h written by a value of %h",op3_addr, MemtoReg==0?Alu_output:DataMemory_ReadData);
    end

    $display("Old_PC = %h, INST = %h, ALU Output = %h",Old_PC, INST,D_out);
  end

  assign New_PC = Jump? Jump_target : ((ALU_op_zero&Branch)? PC_immediate:PC_4);
  assign {D_out, Over_Flow} = {MemtoReg==0?Alu_output:DataMemory_ReadData , OF}; 

endmodule // ALU


// -----------------------------------------------------------------------------
// MODULE: Instruction_Memory
// -----------------------------------------------------------------------------
// PURPOSE : Memory storage for program instructions
// -----------------------------------------------------------------------------
// INPUTS
// clk         : system clock
// INST [31,0] : 32-bit instruction to execute
// -----------------------------------------------------------------------------
// OUTPUTS
// D_out [15,0]       :
// new_address [15,0] :
// -----------------------------------------------------------------------------

module Instruction_memory(Read_address, INST);
  input [15:0] Read_address;

  output [31:0] INST;

  reg [7:0] Mem[0:65535];
  reg [7:0] a1,a2,a3,a4;

  // Scan in memory from text file to test factorial
  initial $readmemb("test_fact.txt",Mem); 

  always @(Read_address) begin
    a1 = Mem[Read_address];
    a2 = Mem[Read_address+1];
    a3 = Mem[Read_address+2];
    a4 = Mem[Read_address+3];
  end
  
  assign #5 INST = {a1, a2, a3, a4};
  
endmodule // Instruction_memory


// -----------------------------------------------------------------------------
// MODULE: Data_Memory
// -----------------------------------------------------------------------------
// PURPOSE : Memory storage for program data
// -----------------------------------------------------------------------------
// INPUTS
// address   [15,0] : 
// WriteData [15,0] :
// mode             :
// MemRead          :
// MemWrite         :
// -----------------------------------------------------------------------------
// OUTPUTS
// ReadData         :
// -----------------------------------------------------------------------------

module Data_memory(MemRead, MemWrite, address, WriteData, ReadData, mode);

  input [15:0] address;
  input [15:0] WriteData;
  input mode;
  input MemRead, MemWrite;

  output [15:0] ReadData;

  reg [7:0] Mem[0:65535];
  reg [7:0] a1,a2;
  
  initial $readmemb("DataMem.txt",Mem); 

  initial begin
    a1 = 0;
    a2 = 0;
  end
  
  always @(address) begin
    if(address!=0)
      if(MemRead==1)begin
        if(mode==0) begin
          #5 a1 = Mem[address];
          $display("Memory read from address %h value %h",address, a1);
        end
        else begin
          #5 a1 = Mem[address];
          a2 = Mem[address+1];
          $display("Memory read from address %h value %h",address, {a1, a2});
        end
      end
      
      else if (MemWrite==1) begin
        if(mode==0) begin
        #5 Mem[address] = WriteData[15:8];
        $display("Memory write in address %h value %h",address, WriteData[15:8]);
			end
      else begin
        #5 Mem[address] = WriteData[15:8];
        Mem[address+1] = WriteData[7:0];
        $display("Memory write in address %h value %h",address, {WriteData[15:8], WriteData[7:0]});
      end
    end
  end
  assign ReadData = mode==0? {a1, 8'b00000000} : {a1, a2};

endmodule // Data_memory
>>>>>>> FETCH_HEAD:Lab4/Final_Lab4/lab4.v
