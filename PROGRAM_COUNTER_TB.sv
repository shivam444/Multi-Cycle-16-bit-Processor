`timescale 1ns/1ps

module PROGRAM_COUNTER_TB;

	parameter POINTER_LEN = 16; 
	parameter DATA_LEN = 16;
	
	localparam iter = 20;
	
	bit clk; always #5 clk = ~clk;
	bit rst; 
	logic pc_src; 
	logic pc_wr_en; 
	logic [DATA_LEN-1:0] data; 
	logic [POINTER_LEN-1:0] instruction_ptr;
	
	int i,j;
	int ptr_exp;
	
	PROGRAM_COUNTER#(.POINTER_LEN(POINTER_LEN), .DATA_LEN(DATA_LEN))
					pc_dut(.*);
		

	initial begin
		rst = 1'b0;
		repeat(100)@(posedge clk);
		rst = 1'b1;
		//repeat(100)@(posedge clk);;
		check;
		repeat(100)@(posedge clk);
		print;
		repeat(100)@(posedge clk);
		$finish;
	end
			
	task check;
		repeat(iter)begin
			@(posedge clk);
			pc_src = $urandom%2;
			//pc_src = 'b0;
			pc_wr_en = $urandom%2;
			data = $urandom;
			
			#1
			if(pc_wr_en)begin
				j++;
				if(~pc_src)begin
					ptr_exp++;
					if(instruction_ptr == ptr_exp)begin
						i++;
					end
					else begin
						$display("%d, iteration failed, expected = %d, got = %d", i, ptr_exp, instruction_ptr);
					end
					
				end
				else begin
					repeat(2)@(posedge clk);
					if(instruction_ptr == data)begin
						i++;
					end
					else begin
						$display("%d, iteration failed, expected = %d, got = %d", i, data, instruction_ptr);
					end
				end
				
			end
		end
	endtask
	
	task print;
		if(i == j)begin
			$display("Success, passed = %d/%d", i, j);
		end
		else begin
			$display("Failed, passed = %d/%d", i, j);
		end
	endtask
endmodule

	