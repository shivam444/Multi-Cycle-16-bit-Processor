module CONTROLLER_#(parameter INSTRUCTION_LEN = 16)(input clk, input rst, input neg, input [INSTRUCTION_LEN-1:0] instruction, output reg pc_wr_en, output reg pc_src, output reg ir_wr_en, output reg ipr_wr_en, output reg rf_wr_en, output reg tr1_wr_en, output reg tr2_wr_en, output reg alu_en, output reg [3:0] db_0_s, output reg [3:0] db_1_s, output reg [1:0] alu_op, output reg dm_wr_en);

	//STATE ASSIGNMENT
	localparam reset_state = 50;
	localparam s0 = 0;
	localparam s1 = 1;
	localparam s1_ = 23;
	localparam s2 = 2;
	localparam s2_ = 24;
	localparam s3 = 3;
	localparam s4 = 4;
	localparam s4_ = 27;
	localparam s5 = 5;
	localparam s6 = 6;
	localparam s7 = 7;
	localparam s8 = 8;
	localparam s7_ = 25;
	localparam s8_ = 26;
	localparam s9 = 9;
	localparam s10 = 10;
	localparam s11 = 11;
	localparam s12 = 12;
	localparam s13 = 13;
	localparam s14 = 14;
	localparam s15 = 15;
	localparam s16 = 16;
	localparam s17 = 17;
	localparam s18 = 18;
	localparam s19 = 19;
	localparam s20 = 20;
	localparam s21 = 21;
	localparam s22 = 22;
	
	//OPCODES
	localparam r_format = 0;
	localparam beq = 1;
	localparam ld = 2;
	localparam sd = 3;
	
	//ALU OPERATIONS
	localparam add = 0;
	localparam sub = 1;
	localparam or_op = 2;
	localparam and_op = 3;
	
	wire [1:0] opcode;
	wire [1:0] alu_op_ins;
	wire [3:0] rd;
	wire [3:0] rs1;
	wire [3:0] rs2;
	wire [3:0] offset;
	
	reg [5:0] present_state, next_state;
	
	assign opcode = instruction[INSTRUCTION_LEN-1:INSTRUCTION_LEN-2];
	assign alu_op_ins = instruction[INSTRUCTION_LEN-3:INSTRUCTION_LEN-4];
	assign rd = ((opcode == r_format) | (opcode == ld))?instruction[INSTRUCTION_LEN-5:INSTRUCTION_LEN-8] : 'b0;
	assign rs1 = ((opcode == r_format) | (opcode == beq) | (opcode == sd))?instruction[INSTRUCTION_LEN-9:INSTRUCTION_LEN-12] : instruction[INSTRUCTION_LEN-13:INSTRUCTION_LEN-16];
	assign rs2 = ((opcode == r_format) | (opcode == beq) | (opcode == sd))?instruction[INSTRUCTION_LEN-13:INSTRUCTION_LEN-16] : 'b0;
	assign offset = ((opcode == beq) | (opcode == ld) | (opcode == sd))?(((opcode == beq) | (opcode == sd))?instruction[INSTRUCTION_LEN-5:INSTRUCTION_LEN-8] : instruction[INSTRUCTION_LEN-9:INSTRUCTION_LEN-12]) : 'b0;
	
	always@* begin
		case(present_state)
			reset_state: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b1;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s0: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b1;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0000;//PC
					db_1_s = 4'b0001;//IPR
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s1: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0010;//RS1_ADDR
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s2: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0010;//RS1_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s1_: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0011;//RS2_ADDR
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s2_: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0011;//RS2_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s3: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b1;
					db_0_s = 4'bxxxx;
					db_1_s = 4'bxxxx;
					alu_op = sub;
					dm_wr_en = 1'b0;
				end
			s4: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0000;//PC
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s4_: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0100;//OFFSET
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s5: begin
					pc_wr_en = 1'b1;
					pc_src = 1'b1;
					ipr_wr_en = 1'b1;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b1;
					db_0_s = 4'b0110;//PC_MUX
					db_1_s = 4'b0101;//ALU OUT
					alu_op = alu_op_ins;
					dm_wr_en = 1'b0;
				end
			s6: begin
					pc_wr_en = 1'b1;
					pc_src = 1'b0;
					ipr_wr_en = 1'b1;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0110;//PC MUX
					db_1_s = 4'bXXXX;//ALU OUT
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s7: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0010;//RS1_ADDR
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s8: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0010;//RS1_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s7_: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0011;//RS2_ADDR
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s8_: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0011;//RS2_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s9: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b1;
					db_0_s = 4'b0111;//RD
					db_1_s = 4'b0101;//ALU_OUT
					alu_op = alu_op_ins;
					dm_wr_en = 1'b0;
				end
			s10: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b1;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b1010;//TR2
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s11: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0100;//OFFSET
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s12: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0010;//RS1_ADDR
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s13: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0010;//RS1_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s14: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b1;
					db_0_s = 4'b0101;//RS1_ADDR
					db_1_s = 4'bxxxx;//RS1_DATA
					alu_op = alu_op_ins;
					dm_wr_en = 1'b0;
				end
			s15: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b1110;//DATA_MEMORY_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s16: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0111;//RD
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s17: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b1;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//RD_ADDR
					db_1_s = 4'b1011;//TR1_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s18: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b1;
					db_0_s = 4'bxxxx;//
					db_1_s = 4'b0101;//ALU OUT
					alu_op = alu_op_ins;
					dm_wr_en = 1'b0;
				end
			s19: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0011;//RS2_ADDR
					db_1_s = 4'bxxxx;//
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s20: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;
					db_1_s = 4'b0011;//RS2_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s21: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b1;
					tr2_wr_en = 1'b0;
					alu_en = 1'b1;
					db_0_s = 4'b1011;
					db_1_s = 4'bxxxx;//ALU_OUT
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
			s22: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b1;
					alu_en = 1'b0;
					db_0_s = 4'bxxxx;//RS1_ADDR
					db_1_s = 4'b1010;//RS1_DATA
					alu_op = 'bxx;
					dm_wr_en = 1'b1;
				end
			default: begin
					pc_wr_en = 1'b0;
					pc_src = 'bx;
					ipr_wr_en = 1'b0;
					ir_wr_en = 1'b0;
					rf_wr_en = 1'b0;
					tr1_wr_en = 1'b0;
					tr2_wr_en = 1'b0;
					alu_en = 1'b0;
					db_0_s = 4'b0000;
					db_1_s = 4'b0000;
					alu_op = 'bxx;
					dm_wr_en = 1'b0;
				end
		endcase
	end
		
	always@* begin
		case(present_state)
			reset_state: next_state = s0;
			s0: begin
				case(opcode)
					beq: next_state = s1;
					r_format: next_state = s7;
					ld: next_state = s11;
					sd: next_state = s11;
					default: next_state = reset_state;
				endcase
				end
			s1: next_state = s2;
			s2: next_state = s1_;
			s1_: next_state = s2_;
			s2_: next_state = s3;
			s3: begin
					if(neg)begin
						next_state = s4;
					end
					else begin
						next_state = s6;
					end
				end
			s4: next_state = s4_;
			s4_: next_state = s5;
			s5: next_state = s0;
			s6: next_state = s0;
			s7: next_state = s8;
			s8: next_state = s7_;
			s7_: next_state = s8_;
			s8_: next_state = s9;
			s9: next_state = s10;
			s10: next_state = s6;
			s11: next_state = s12;
			s12: next_state = s13;
			s13: begin
					if(opcode == ld)begin
						next_state = s14;
					end
					else if(opcode==sd)begin
						next_state = s18;
					end
					else begin
						next_state = reset_state;
					end
				end
			s14: next_state = s15;
			s15: next_state = s16;
			s16: next_state = s17;
			s17: next_state = s6;
			s18: next_state = s19;
			s19: next_state = s20;
			s20: next_state = s21;
			s21: next_state = s22;
			s22: next_state = s6;
			default: next_state = reset_state;
		endcase
	end
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			present_state <= reset_state;
		end
		else begin
			present_state <= next_state;
		end
	end
endmodule
	