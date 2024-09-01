module INSTRUCTION_CONTROLLER#(parameter PREFETCH_REG_SIZE = 4)(input clk, input rst, input [PREFETCH_REG_SIZE-1:0] valid, output ipr_wr_en);
	