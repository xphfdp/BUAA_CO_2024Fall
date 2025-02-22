`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:57:43 10/31/2024 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
	input clk,
	input reset,
	input [31:0] Npc,
	output reg [31:0] Pc, 
	output [31:0] Instr
    );
	reg [31:0] rom [0:4095];
   wire [31:0] pcMinus = Pc - 32'h00003000;
   wire [11:0] address = pcMinus[13:2];
	
	initial begin
		Pc <= 32'h00003000;
		$readmemh("code.txt", rom);
	end
	
	always@(posedge clk) begin
		if(reset) begin
			Pc <= 32'h00003000;
		end
		else begin
			Pc <= Npc;
		end
	end
	
	assign Instr = rom[address];
endmodule

