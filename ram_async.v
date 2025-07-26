`timescale 1us / 1ns
module ram_sp_async_read(
    input clk,
	input [7:0] din,  
	input [3:0] add,  
	input wr_en,       
	output [7:0] dout 
    );

	reg [7:0] ram [0:15];

	always @(posedge clk) begin
	    if (wr_en) begin
		    ram[add] <= din;
	    end
	end
    // The read is asynchronous
	assign dout = ram[add];
endmodule



module tb_ram_sp_async_read;
    reg clk=0;
    reg [7:0] din;
    reg [3:0] add;
    reg wr_en;
    wire [7:0] dout;

    ram_sp_async_read uut (
        .clk(clk),
        .din(din),
        .add(add),
        .wr_en(wr_en),
        .dout(dout)
    );
    always #0.5 clk = ~clk;

    initial begin
        din = 8'b0;
        add = 4'b0;
        wr_en = 0;

        #10;
        din = 8'hAA;
        add = 4'd3;
        wr_en = 1;

        #10;
        din = 8'h55;
        add = 4'd7;

        #10;
        wr_en = 0;
        din = 8'h00;
        add = 4'd3;

        #5;
        $display("Read from address 3: dout = %h (Expected: AA)", dout);

        add = 4'd7;
        
        #5;
        $display("Read from address 7: dout = %h (Expected: 55)", dout);

        add = 4'd0;
        #5;
        $display("Read from address 0: dout = %h (Expected: 00)", dout);

        #10;
        $stop;
    end

endmodule
