`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:02:15 10/31/2024 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input clk,
	input reset,
	input MemWrite,
	input [31:0] WA,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] RD
    );
	integer i;
	reg [31:0] ram [0:3071];
	
	initial begin
		for( i = 0; i < 3072; i = i + 1) begin
			ram[i] <= 0;
		end
	end

	always@(posedge clk) begin
		if(reset) begin
			for( i = 0; i < 3072; i = i + 1) begin
				ram[i] <= 0;
			end
		end
		else if(MemWrite) begin
			ram[WA[13:2]] <= WD;
			$display("@%h: *%h <= %h", PC, WA, WD);
		end
	end
	
	assign RD = ram[WA[13:2]];
endmodule