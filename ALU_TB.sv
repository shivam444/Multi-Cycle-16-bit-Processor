module ALU_TB;

	parameter DATA_LEN = 16;
	
	localparam iter = 1000;
	
	bit clk; always #5 clk = ~clk;
	bit rst; 
	logic [1:0] ALU_OP; 
	logic tr1_wr_en; 
	logic alu_en; 
	logic tr2_wr_en; 
	logic [DATA_LEN-1:0] data_1; 
	logic [DATA_LEN-1:0] data_2; 
	logic [DATA_LEN-1:0] alu_out;
	
	int i;
	
	ALU#(.DATA_LEN(DATA_LEN)) alu_dut(.*);
	
	initial begin
		rst = 1'b0;
		repeat(10)@(posedge clk);
		rst = 1'b1;
		repeat(10)@(posedge clk);
		check;
		repeat(10)@(posedge clk);
		print;
		repeat(10)@(posedge clk);
		$finish;
	end
	
	task check;
		repeat(iter)begin
			@(posedge clk);
			tr1_wr_en = 1'b1;
			tr2_wr_en = 1'b0;
			alu_en = 1'b0;
			data_1 = $urandom%65536;
			repeat(2)@(posedge clk);
			tr2_wr_en = 1'b1;
			tr1_wr_en = 1'b0;
			alu_en = 1'b0;
			data_2 = $urandom%65536;
			repeat(3)@(posedge clk);
			alu_en = 1'b1;
			ALU_OP = 'b00;
			#1
			if(alu_out == (data_1 + data_2))begin
				i++;
			end
			else begin
				$display("%d, iteration failed, expected = %d, got = %d", i, data_1+data_2, alu_out);
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
			