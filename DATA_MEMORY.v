module DATA_MEMORY#(parameter DATA_LEN = 16, DATA_MEM_SIZE = 5)(input clk, input rst, input [DATA_MEM_SIZE-1:0] rd_ptr, input [DATA_MEM_SIZE-1:0] wr_ptr, input dm_wr_en, input [DATA_LEN-1:0] wr_data, output [DATA_LEN-1:0] rd_data);

	integer i;
	initial begin
		data_mem[0] <= 'b0;
		data_mem[1] <= 'd1;
		data_mem[2] <= 'd10;
		/* data_mem[3] <= $urandom%65536;
		data_mem[4] <= $urandom%65536;
		data_mem[5] <= $urandom%65536;
		data_mem[6] <= $urandom%65536;
		data_mem[7] <= $urandom%65536;
		data_mem[8] <= $urandom%65536;
		data_mem[9] <= $urandom%65536;
		data_mem[10] <= $urandom%65536;
		data_mem[11] <= $urandom%65536;
		data_mem[12] <= $urandom%65536; */
		data_mem[3] <= 53;
		data_mem[4] <= 22;
		data_mem[5] <= 867;
		data_mem[6] <= 13;
		data_mem[7] <= 46;
		data_mem[8] <= 2225;
		data_mem[9] <= 644;
		data_mem[10] <= 345;
		data_mem[11] <= 4352;
		data_mem[12] <= 234;
		//data_mem[13] <= 'd2;
	end
	
	(*ram_style = "block"*)reg [DATA_LEN-1:0] data_mem [(2**DATA_MEM_SIZE)-1:0];
	
	assign rd_data = data_mem[rd_ptr];
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			for(i=13;i<2**DATA_MEM_SIZE;i=i+1)begin
				data_mem[i] <= 'b0;
			end
			
		end 
		else if(dm_wr_en)begin
			data_mem[wr_ptr] <= wr_data;
		end
	end
endmodule