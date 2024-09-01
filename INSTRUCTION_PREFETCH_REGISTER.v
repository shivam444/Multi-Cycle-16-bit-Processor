module INSTRUCTION_PREFETCH_REGISTER#(parameter INSTRUCTION_MEMORY_SIZE = 13, PREFETCH_REG_SIZE = 4, INSTRUCTION_LEN = 16)(input clk, input rst, input ipr_wr_en, input [INSTRUCTION_LEN-1:0] instruction, input [(2**INSTRUCTION_MEMORY_SIZE)-1:0] instruction_ptr, output reg [PREFETCH_REG_SIZE-1:0] valid, output reg [INSTRUCTION_LEN-1:0] instruction_out);
	
	reg [PREFETCH_REG_SIZE-1:0] ipr_instruction [INSTRUCTION_LEN-1:0];
	reg [PREFETCH_REG_SIZE-1:0] ipr_offset [INSTRUCTION_MEMORY_SIZE-3:0];
	reg [1:0] ipr_wr_ptr;
	
	integer i;
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			for(i=0; i<=PREFETCH_REG_SIZE; i= i+1)begin
				ipr[i] <= 'b0;
				valid[i] <= 'b0;
			end
		end
		else if(ipr_wr_en)begin
			ipr_wr_ptr <= instruction_ptr[1:0];
			ipr[ipr_wr_ptr] <= instruction;
			ipr_offset[ipr_wr_ptr] <= instruction_ptr[INSTRUCTION_MEMORY_SIZE-1:2];
			valid[ipr_wr_ptr] <= 1'b1;
		end
		else begin
			instruction_out <= ipr_instruction[instruction_ptr[1:0]];
			valid[ipr_wr_ptr] <= 1'b0;
		end
	end
endmodule
			
			