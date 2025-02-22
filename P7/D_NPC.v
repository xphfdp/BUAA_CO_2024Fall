`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:52 11/13/2024 
// Design Name: 
// Module Name:    D_NPC 
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
`include "macro.v"
//`default_nettype none

module D_NPC(
    input [15:0] Offset,
    input [25:0] Instr_index,
    input [2:0] NPCop,
    input [31:0] JrReg,
    input [31:0] F_PC,
    input [31:0] D_PC,
    input Zero,
    input req,
    input eret,
    input [31:0] EPC,

    output reg [31:0] Npc
);
    wire [31:0] D_PC4 = D_PC + 32'd4;
    wire [31:0] F_PC4 = F_PC + 32'd4;
    wire [31:0] EPC4 = EPC + 32'd4;
    wire [31:0] imme32 = {{14{Offset[15]}},Offset,2'b00} + D_PC4;
    always@(*) begin
        if(req) begin
            Npc = `exception_entrance;
        end else if(eret) begin
            Npc = EPC4;
        end else if(NPCop == `NPCop_jr) begin
            Npc = JrReg;
        end else if(NPCop == `NPCop_b && Zero) begin
            Npc = imme32;
        end else if(NPCop == `NPCop_jal) begin
            Npc = {D_PC[31:28],Instr_index,2'b00};
        end else begin
            Npc = F_PC4;
        end

    end
endmodule