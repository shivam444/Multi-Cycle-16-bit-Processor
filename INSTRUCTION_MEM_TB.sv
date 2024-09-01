`timescale 1ns/1ps
module INSTRUCTION_MEM_TB;
	
	parameter INSTRUCTION_LEN = 16; 
	parameter INSTRUCTION_MEM_SIZE = 8; 
	parameter IPR_SIZE = 8;
	
	localparam iter = 1000;
	
	bit clk; always #5 clk = ~clk;
	logic rst; 
	logic ipr_write; 
	logic [INSTRUCTION_MEM_SIZE-1:0] instruction_ptr; 
	logic [INSTRUCTION_LEN-1:0] instruction;
	
	reg [INSTRUCTION_LEN-1:0] instruction_mem [(2**INSTRUCTION_MEM_SIZE)-1:0];
	
	int i, j, m;
	
	
	INSTRUCTION_MEM#(.INSTRUCTION_LEN(INSTRUCTION_LEN), .INSTRUCTION_MEM_SIZE(INSTRUCTION_MEM_SIZE), .IPR_SIZE(IPR_SIZE)) ins_mem_dut(.*);
	
	initial begin
		$finish;
		rst = 1'b0;
		#100
		rst = 1'b1;
		repeat(10)@(posedge clk);
		mem_in;
		check;
		print;
		repeat(10)@(posedge clk);
		$finish;
	end
	
	task mem_in;
        for(j=0;j<(2**INSTRUCTION_MEM_SIZE);j=j+1)begin
            instruction_mem[j] <= j;
        end
	endtask
	
	task check;
		repeat(iter)begin
			@(posedge clk);
			//ipr_write = $urandom%2;
			ipr_write = 1'b1;
			instruction_ptr = m;
			#1
			if(instruction == instruction_mem[instruction_ptr])begin
				i++;
			end
			else begin
				$display("Failed %d,th iteration, Expected = %d, Got = %d",i, instruction_mem[instruction_ptr], instruction);
			end
			m++;
		end
	endtask
	
	task print;
		if(i == iter)begin
			$display("Success, Passed = %d/%d", i, iter);
		end
		else begin
			$display("Failed, Passed = %d/%d", i, iter);
		end
	endtask
endmodule
			