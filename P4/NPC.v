`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:59:59 10/31/2024 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
	input [31:0] Pc,
	input [2:0] NpcOp,
	input [31:0] JrReg,
	input [25:0] Imme26,
	input Zero,
	output [31:0] PcPlus4,
	output reg [31:0] Npc
    );

	assign PcPlus4 = Pc + 4;
	wire [31:0] imme32 = {{14{Imme26[15]}}, Imme26[15:0], {2{1'b0}} } + PcPlus4;
	always@(*) begin
		case(NpcOp) 
			3'b000: Npc <= Pc + 32'd4;
			3'b001: Npc <= (Zero)?imme32:PcPlus4;
			3'b010: Npc <= {{Pc[31:28]},Imme26, {2{1'b0}} };
			3'b011: Npc <= JrReg;
		endcase
	end
endmodule

