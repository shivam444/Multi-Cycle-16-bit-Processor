module PROGRAM_COUNTER#(parameter POINTER_LEN = 16, DATA_LEN = 16)(input clk, input rst, input pc_src, input pc_wr_en, input [DATA_LEN-1:0] data, output [POINTER_LEN-1:0] instruction_ptr);

	reg [POINTER_LEN-1:0] next_instruction_ptr;
	reg [POINTER_LEN-1:0] present_instruction_ptr;
	
	always@* begin
		if(pc_src)begin
			next_instruction_ptr = data;
		end
		else begin
			next_instruction_ptr = present_instruction_ptr + 1'b1;
		end
	end
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			present_instruction_ptr <= 'b0;
		end
		else if(pc_wr_en)begin
			present_instruction_ptr <= next_instruction_ptr;
		end
	end
	
	assign instruction_ptr = present_instruction_ptr;
endmodule