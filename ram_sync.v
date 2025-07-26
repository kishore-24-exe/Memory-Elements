 `timescale 1us / 1ns
module ram_sp_sync_read(
    input clk,
	input [7:0] din,  
	input [3:0] add,  
	input wr_en,       
	output [7:0] dout 
    );

	reg [7:0] ram [0:15];
    reg [3:0] address_buffer;

	always @(posedge clk) begin
	    if (wr_en) begin
		    ram[add] <= din;
	    end
        address_buffer <= add;
	end
	assign dout = ram[address_buffer];
endmodule

module tb_ram_sp_sync_read;
    reg clk = 0;
    reg [7:0] din;
    reg [3:0] add;
    reg wr_en;
    wire [7:0] dout;

    ram_sp_sync_read uut (
        .clk(clk),
        .din(din),
        .add(add),
        .wr_en(wr_en),
        .dout(dout)
    );

    always #0.5 clk = ~clk;

    initial begin
        din = 8'h00;
        add = 4'd0;
        wr_en = 0;

        #1;
        din = 8'hAA; add = 4'd1; wr_en = 1;
        #1;
        din = 8'hFF; add = 4'd2;
        #1;
        wr_en = 0;

        #1; add = 4'd1;
        #1; $display("dout at address 1 = %h (expected AA)", dout);

        #1; add = 4'd2;
        #1; $display("dout at address 2 = %h (expected FF)", dout);

        #1; add = 4'd0;
        #1; $display("dout at address 0 = %h (expected 00)", dout);

        #2;
        $stop;
    end
endmodule