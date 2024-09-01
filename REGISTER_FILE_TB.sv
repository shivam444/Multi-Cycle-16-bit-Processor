`timescale 1ns/1ps
module REGISTER_FILE_TB;

	parameter ADDRESS_LEN = 4; 
	parameter DATA_LEN = 16;
	parameter iter = 100;
	
	bit clk; always #5 clk = ~clk;
	bit rst; 
	logic rf_wr_en; 
	logic [ADDRESS_LEN-1:0] rd_addr; 
	logic [ADDRESS_LEN-1:0] wr_addr; 
	logic [DATA_LEN-1:0] wr_data; 
	logic [DATA_LEN-1:0] rd_data;
	
	logic [(2**ADDRESS_LEN)-1:0] mem_tb [DATA_LEN-1:0];
	
	int i;
	
	REGISTER_FILE#(.ADDRESS_LEN(ADDRESS_LEN), .DATA_LEN(DATA_LEN)) rf_dut(.*);
	
	
	initial begin
		rst = 1'b0;
		repeat(10)@(posedge clk);
		rst = 1'b1;
		mem_write;
		repeat(10)@(posedge clk);
		mem_check;
		repeat(10)@(posedge clk);
		print;
		repeat(10)@(posedge clk);
		$finish;
	end
	
	task mem_write;
		repeat(iter)begin
			@(posedge clk);
			rf_wr_en = 1'b1;
			wr_addr = $urandom%16;
			wr_data = $urandom%65536;
			mem_tb[wr_addr] = wr_data;
		end
		@(posedge clk);
		rf_wr_en = 1'b0;
	endtask
	
	task mem_check;
		repeat(iter)begin
			@(posedge clk);
			rf_wr_en = 1'b0;
			rd_addr = $urandom%16;
			@(posedge clk);
			#1
			if(mem_tb[rd_addr] == rd_data)begin
				i++;
			end
			else begin
				$display("%d, iteration failed, expected = %d, got = %d", i, mem_tb[rd_addr], rd_data);
			end
		end
	endtask
	
	task print;
		if(i == iter)begin
			$display("Success, passed = %d/%d", i, iter);
		end
		else begin
			$display("Failed, passed = %d/%d", i, iter);
		end
	endtask
	
endmodule
		