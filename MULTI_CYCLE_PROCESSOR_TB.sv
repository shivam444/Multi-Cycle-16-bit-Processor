`timescale 1ns/1ps
module MULTI_CYCLE_PROCESSOR_TB;

	localparam INSTRUCTION_LEN = 16; 
	localparam INSTRUCTION_MEM_SIZE = 8; 
	localparam DATA_LEN = 16;
	
	bit clk ;always#5 clk = ~clk;
	logic reset; 
	logic [DATA_LEN-1:0] res;
	
	MULTI_CYCLE_PROCESSOR#(.INSTRUCTION_LEN(INSTRUCTION_LEN),.INSTRUCTION_MEM_SIZE(INSTRUCTION_MEM_SIZE),.DATA_LEN(DATA_LEN)) multi_cycle_processor_dut(.*);
	
	initial begin
		$finish;
		reset = 1'b0;
		#50
		reset = 1'b1;
		$monitor("Result = %d", res);
		#10000
		$finish;
	end
	
endmodule