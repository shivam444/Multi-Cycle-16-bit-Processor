module REGISTER_FILE#(parameter ADDRESS_LEN = 4, DATA_LEN = 16)(input clk, input rst, input rf_wr_en, input [ADDRESS_LEN-1:0] rd_addr, input [ADDRESS_LEN-1:0] wr_addr, input [DATA_LEN-1:0] wr_data, output [DATA_LEN-1:0] rd_data);

	reg [(2**ADDRESS_LEN)-1:0] mem [DATA_LEN-1:0];
	integer i;
	
	assign rd_data = mem[rd_addr];
	
	always@(posedge clk or negedge rst)begin
		if(~rst)begin
			mem[0] = 1'b0;
		end
		else if(rf_wr_en)begin
			mem[wr_addr] <= wr_data;
		end
	end
endmodule