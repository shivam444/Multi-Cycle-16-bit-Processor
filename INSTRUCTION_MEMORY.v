module INSTRUCTION_MEM_#(parameter INSTRUCTION_LEN = 16, INSTRUCTION_MEM_SIZE = 8, IPR_SIZE = 8)(input clk, input rst, input ipr_write, input [INSTRUCTION_MEM_SIZE-1:0] instruction_ptr, output [INSTRUCTION_LEN-1:0] instruction);

	localparam IPR_PTR_SIZE = $clog2(IPR_SIZE);
	reg [INSTRUCTION_LEN-1:0] ipr_mem [IPR_SIZE-1:0];	//IPR MEMORY
	reg [INSTRUCTION_MEM_SIZE-IPR_PTR_SIZE-1:0] ipr_mem_offset [IPR_SIZE-1:0];	//OFFSET HOLDS
	//(*rom_style = "block"*) reg [INSTRUCTION_LEN-1:0] instruction_mem [(2**INSTRUCTION_MEM_SIZE)-1:0]; //INSTRUCTION MEMORY
	
	wire [INSTRUCTION_LEN-1:0] instruction_ipr, instruction_i_mem;
	wire [INSTRUCTION_LEN-1:0] spo;
	reg [INSTRUCTION_MEM_SIZE-1:0] instruction_mem_rd_ptr;
	reg [INSTRUCTION_MEM_SIZE-1:0] instruction_ptr_hold;
	wire [INSTRUCTION_MEM_SIZE-1:0] a;
	wire valid;
	reg a_sel;
	reg [15:0] count,total;
	
	dist_mem_gen_0 instruction_mem (
  .a(a),      // input wire [7 : 0] a
  .spo(spo)  // output wire [15 : 0] spo
);
	
	integer i,j;
	
	wire [IPR_PTR_SIZE-1:0] ipr_rd_ptr;
	wire [INSTRUCTION_MEM_SIZE-IPR_PTR_SIZE-1:0] offset_addr, ins_ptr_msb;
	wire [IPR_PTR_SIZE-1:0] ipr_wr_ptr;
	
	assign offset_addr = ipr_mem_offset[instruction_ptr[IPR_PTR_SIZE-1:0]];
	assign ins_ptr_msb = instruction_ptr[INSTRUCTION_MEM_SIZE-1:IPR_PTR_SIZE];
	assign ipr_rd_ptr = instruction_ptr[IPR_PTR_SIZE-1:0];
	assign ipr_wr_ptr = instruction_mem_rd_ptr[IPR_PTR_SIZE-1:0];
	assign a = ipr_write?instruction_mem_rd_ptr:instruction_ptr;
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			count <= 'b0;
		end
		else if(valid)begin
			count<=count+1'b1;
		end
	end
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			total <= 'b0;
		end
		else begin
			total<=total+1'b1;
		end
	end
			
	
	//INITIAL BLOCK
	/* initial begin
		//instruction_mem[0] <= 'b0000001100010010;
		//for(j=0;j<(2**INSTRUCTION_MEM_SIZE);j=j+1)begin
			//instruction_mem[j] <= 'b0000001100010010;
			//instruction_mem[j] <= 'b1000001000010000;
			//instruction_mem[j] <= 'b1100100000010010;
			//instruction_mem[j] <= 'b0100010000100000;
		//end
		instruction_mem[0] <= 'b1000000100000000;
		instruction_mem[1] <= 'b1000001000010000;
		instruction_mem[2] <= 'b1000001100100000;
		instruction_mem[3] <= 'b1000010000110000;
		instruction_mem[4] <= 'b1000010100110001;
		instruction_mem[5] <= 'b0100010001000101;
		instruction_mem[6] <= 'b0000000100010010;
		instruction_mem[7] <= 'b0101001100010011;
		instruction_mem[8] <= 'b0100001100000001;
		instruction_mem[9] <= 'b1000010000110001;
		instruction_mem[10] <= 'b0101001100000011;
		instruction_mem[11] <= 'b0000010001000000;
		//instruction_mem[12] <= 'b0101000100000001;
		/* instruction_mem[0] <= 'b1000000100000000;
		instruction_mem[1] <= 'b1000001000010000;
		instruction_mem[2] <= 'b1000001100100000;
		instruction_mem[3] <= 'b1000010000000000;
		instruction_mem[4] <= 'b1000010100110001;
		instruction_mem[5] <= 'b0000010001000101;
		instruction_mem[6] <= 'b0000000100010010;
		instruction_mem[7] <= 'b0101001100010011;
		instruction_mem[8] <= 'b0000010001000000; */
		//instruction_mem[9] <= 'b1000010000110001;
		//instruction_mem[10] <= 'b0101001100000011;
		//instruction_mem[11] <= 'b0000010001000000;
//	end */
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			a_sel <= 1'b0;
			ipr_mem[i] <= spo;
			instruction_mem_rd_ptr <= 'b0;
			/* for(i=0; i<IPR_SIZE; i=i+1)begin
				ipr_mem[i] <= spo;
				ipr_mem_offset[i] <= i[INSTRUCTION_MEM_SIZE-1:IPR_PTR_SIZE];
				instruction_mem_rd_ptr <= i+1;
			end */
		end
		else if(ipr_write)begin
			a_sel <= 1'b0;
			ipr_mem[ipr_wr_ptr] <= spo;
			ipr_mem_offset[ipr_wr_ptr] <= instruction_mem_rd_ptr[INSTRUCTION_MEM_SIZE-1:IPR_PTR_SIZE];
			if(valid)begin
				instruction_mem_rd_ptr <= instruction_mem_rd_ptr+1'b1;
			end
			else begin
				instruction_mem_rd_ptr <= instruction_ptr+1'b1;
			end
		end
		else begin
			a_sel <= 1'b1;
		end
	end
	
/* 	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			instruction_ipr <= 'b0;
			instruction_i_mem <= 'b0;
		end
		else begin
			instruction_i_mem <= instruction_mem[instruction_ptr];
			instruction_ipr <= ipr_mem[ipr_rd_ptr];
		end
	end */
	
	assign instruction_i_mem = spo;
	assign instruction_ipr = ipr_mem[ipr_rd_ptr];
	
	assign valid = (offset_addr == ins_ptr_msb)?1'b1:1'b0;
	assign instruction = valid?instruction_ipr:instruction_i_mem;
	
endmodule
	
	