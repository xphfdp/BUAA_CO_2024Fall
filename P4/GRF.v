`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:01:35 10/31/2024 
// Design Name: 
// Module Name:    GRF 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GRF(
	input clk,
	input reset,	
	input RegWrite,
	input [4:0] RA1, 
	input [4:0] RA2, 
	input [4:0] WA,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] RD1,
	output [31:0] RD2
    );
	
	reg [31:0] grf [0:31];
	integer i;
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			grf[i] = 32'b00;
		end
	end
	
	assign RD1 = grf[RA1];
	assign RD2 = grf[RA2];
	
	always@(posedge clk) begin
		if(reset) begin
			for (i = 0; i < 32; i = i + 1) begin
				grf[i] <= 32'b00;
			end
		end
		else begin
			if(WA != 5'b00000 && RegWrite) begin
				grf[WA] <= WD;
				$display("@%h: $%d <= %h", PC, WA, WD);
			end
		end
	end
endmodule
