module INSTRUCTION_REGISTER#(parameter INSTRUCTION_LEN = 16)(input clk, input rst, input ir_wr_en, input [INSTRUCTION_LEN-1:0] instruction_in, output [INSTRUCTION_LEN-1:0] instruction);

	reg [INSTRUCTION_LEN-1:0] instruction_reg;
	
	assign instruction = instruction_reg;
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			instruction_reg <= 'b0;
		end
		else if(ir_wr_en)begin
			instruction_reg <= instruction_in;
		end
	end
endmodule