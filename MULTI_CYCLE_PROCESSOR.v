module MULTI_CYCLE_PROCESSOR#(parameter INSTRUCTION_LEN = 16, INSTRUCTION_MEM_SIZE = 5, DATA_LEN = 16)(input clk ,input reset, output reg [DATA_LEN-1:0] res);
	
	localparam IPR_SIZE = 8;
	localparam ADDRESS_LEN = 4;
	localparam DATA_MEM_SIZE = 5;
	
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
	
	reg [1:0] reset_sync;
	
	reg [DATA_LEN-1:0] data_bus_0;
	reg [DATA_LEN-1:0] data_bus_1;
	
	wire [DATA_LEN-1:0] data_1;
	wire [DATA_LEN-1:0] data_2;
	reg [DATA_MEM_SIZE-1:0] dm_rd_ptr;
	reg [DATA_MEM_SIZE-1:0] dm_wr_ptr;
	reg [ADDRESS_LEN-1:0] rf_rd_addr;
	reg [ADDRESS_LEN-1:0] rf_wr_addr;
	
	wire [DATA_LEN-1:0] rf_wr_data;
	wire [DATA_LEN-1:0] dm_wr_data;
	wire rst;
	wire [DATA_LEN-1:0] alu_out;
	wire [INSTRUCTION_MEM_SIZE-1:0] instruction_ptr;
	wire [INSTRUCTION_LEN-1:0] instruction;
	wire [INSTRUCTION_LEN-1:0] instruction_ir;
	wire if_zero;
	wire pc_wr_en;
	wire pc_src;
	wire ir_wr_en;
	wire ipr_wr_en;
	wire rf_wr_en;
	wire tr1_wr_en;
	wire tr2_wr_en;
	wire alu_en;
	wire [3:0] db_0_s;
	wire [3:0] db_1_s;
	wire [1:0] alu_op;
	wire dm_wr_en;
	wire negative;
	
	wire [DATA_LEN-1:0] rf_rd_data;
	
	wire [DATA_LEN-1:0] dm_rd_data;
	wire [DATA_LEN-1:0] tr1;
	wire [DATA_LEN-1:0] tr2;
	
	assign if_zero = (alu_out=='b0)?1'b0:1'b1;
	assign rst = reset_sync[0];
		
	assign opcode = instruction_ir[INSTRUCTION_LEN-1:INSTRUCTION_LEN-2];
	assign alu_op_ins = instruction_ir[INSTRUCTION_LEN-3:INSTRUCTION_LEN-4];
	assign rd = ((opcode == r_format) | (opcode == ld))?instruction_ir[INSTRUCTION_LEN-5:INSTRUCTION_LEN-8] : 'b0;
	assign rs1 = ((opcode == r_format) | (opcode == beq) | (opcode == sd))?instruction_ir[INSTRUCTION_LEN-9:INSTRUCTION_LEN-12] : instruction_ir[INSTRUCTION_LEN-13:INSTRUCTION_LEN-16];
	assign rs2 = ((opcode == r_format) | (opcode == beq) | (opcode == sd))?instruction_ir[INSTRUCTION_LEN-13:INSTRUCTION_LEN-16] : 'b0;
	assign offset = ((opcode == beq) | (opcode == ld) | (opcode == sd))?(((opcode == beq) | (opcode == sd))?instruction_ir[INSTRUCTION_LEN-5:INSTRUCTION_LEN-8] : instruction_ir[INSTRUCTION_LEN-9:INSTRUCTION_LEN-12]) : 'b0;
	
	assign data_1 = data_bus_1;
	assign data_2 = data_bus_1;
	assign rf_wr_data = data_bus_1;
	assign dm_wr_data = data_bus_1;
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			rf_rd_addr <= 'b0;
			rf_wr_addr <= 'b0;
			dm_rd_ptr <= 'b0;
			dm_wr_ptr <= 'b0;
		end
		else begin
			rf_rd_addr <= data_bus_0;
			rf_wr_addr <= data_bus_0;
			dm_rd_ptr <= data_bus_0;
			dm_wr_ptr <= data_bus_0;
		end
	end
	
	always@(posedge clk or negedge reset)begin
		if(~reset)begin
			reset_sync <= 'b0;
		end
		else begin
			reset_sync[1] <= 1'b1;
			reset_sync[0] <= reset_sync[1];
		end
	end
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			res <= 'b0;
		end
		else if((opcode == r_format) && alu_en)begin
			res <= alu_out;
		end
	end
	
	always@*begin
		case(db_0_s)
			4'b0000: data_bus_0 = instruction_ptr;
			4'b0001: data_bus_0 = instruction;
			4'b0010: data_bus_0 = rs1;
			4'b0011: data_bus_0 = rs2;
			4'b0100: data_bus_0 = offset;
			4'b0101: data_bus_0 = alu_out;
			4'b0110: data_bus_0 = instruction_ptr; //DOUBTFUL
			4'b0111: data_bus_0 = rd;
			4'b1110: data_bus_0 = dm_rd_data;
			4'b1011: data_bus_0 = tr1;
			4'b1010: data_bus_0 = tr2;
			default: data_bus_0 = 'bx;
		endcase
		case(db_1_s)
			4'b0000: data_bus_1 = instruction_ptr;
			4'b0001: data_bus_1 = instruction;
			4'b0010: data_bus_1 = rf_rd_data;
			4'b0011: data_bus_1 = rf_rd_data;
			4'b0100: data_bus_1 = offset;
			4'b0101: data_bus_1 = alu_out;
			4'b0110: data_bus_1 = instruction_ptr; //DOUBTFUL
			4'b0111: data_bus_1 = rd;
			4'b1110: data_bus_1 = dm_rd_data;
			4'b1011: data_bus_1 = tr1;
			4'b1010: data_bus_1 = tr2;
			default: data_bus_1 = 'bxx;
		endcase
	end			
	
	PROGRAM_COUNTER#(.POINTER_LEN(INSTRUCTION_MEM_SIZE), .DATA_LEN(DATA_LEN)) program_counter(.clk(clk),.rst(rst),.pc_src(pc_src),.pc_wr_en(pc_wr_en),.data(data_bus_1),.instruction_ptr(instruction_ptr));
	INSTRUCTION_MEM_#(.INSTRUCTION_LEN(INSTRUCTION_LEN),.INSTRUCTION_MEM_SIZE(INSTRUCTION_MEM_SIZE),.IPR_SIZE(IPR_SIZE)) instruction_memory(.clk(clk),.rst(rst),.ipr_write(ipr_wr_en),.instruction_ptr(instruction_ptr),.instruction(instruction));
	INSTRUCTION_REGISTER#(.INSTRUCTION_LEN(INSTRUCTION_LEN)) instruction_register(.clk(clk),.rst(rst),.ir_wr_en(ir_wr_en),.instruction_in(instruction),.instruction(instruction_ir));
	CONTROLLER_#(.INSTRUCTION_LEN(INSTRUCTION_LEN)) controller(.clk(clk),.rst(rst),.neg(negative),.instruction(instruction),.pc_wr_en(pc_wr_en),.pc_src(pc_src),.ir_wr_en(ir_wr_en),.ipr_wr_en(ipr_wr_en),.rf_wr_en(rf_wr_en),.tr1_wr_en(tr1_wr_en),.tr2_wr_en(tr2_wr_en),.alu_en(alu_en),.db_0_s(db_0_s),.db_1_s(db_1_s),.alu_op(alu_op),.dm_wr_en(dm_wr_en));
	ALU#(.DATA_LEN(DATA_LEN)) alu(.clk(clk),.rst(rst),.ALU_OP(alu_op),.tr1_wr_en(tr1_wr_en),.alu_en(alu_en),.tr2_wr_en(tr2_wr_en),.data_1(data_1),.data_2(data_2),.tr1_out(tr1),.tr2_out(tr2),.alu_out(alu_out), .negative(negative));
	REGISTER_FILE#(.ADDRESS_LEN(ADDRESS_LEN),.DATA_LEN(DATA_LEN)) register_file(.clk(clk),.rst(rst),.rf_wr_en(rf_wr_en),.rd_addr(rf_rd_addr),.wr_addr(rf_wr_addr),.wr_data(rf_wr_data),.rd_data(rf_rd_data));
	DATA_MEMORY#(.DATA_LEN(DATA_LEN),.DATA_MEM_SIZE(DATA_MEM_SIZE)) data_memory(.clk(clk),.rst(rst),.rd_ptr(dm_rd_ptr),.wr_ptr(dm_wr_ptr),.dm_wr_en(dm_wr_en),.wr_data(dm_wr_data),.rd_data(dm_rd_data));

	
endmodule