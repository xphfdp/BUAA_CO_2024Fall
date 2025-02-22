`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:58:23 10/31/2024 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(input [5:0] Opcode,
            input [5:0] Func,
            output [2:0] NPCOp,
            output [1:0] RegDst,
            output [1:0] MemtoReg,
            output RegWrite,
            output ExtOp,
            output ALUSrc,
            output [2:0] ALUOp,
            output MemWrite);
    
    assign special = (Opcode == 6'b000000);
    assign add     = (special && Func == 6'b100_000);
    assign sub     = (special && Func == 6'b100_010);
    assign ori     = (Opcode == 6'b001_101);
    assign lui     = (Opcode == 6'b001_111);
    assign jal     = (Opcode == 6'b000_011);
    assign jr      = (special && Func == 6'b001_000);
    assign lw      = (Opcode == 6'b100_011);
    assign sw      = (Opcode == 6'b101_011);
    assign beq     = (Opcode == 6'b000_100);
    
    assign NPCOp = (jr)? 3'b011:
    			   (jal) ? 3'b010:
    			   (beq)? 3'b001:
    			   3'b000;
    assign RegDst = (jal) ? 2'b10:
					(add | sub) ? 2'b01:
					2'b00;
    assign MemtoReg = (jal) ? 2'b10:
					  (lw) ? 2'b01:
					  2'b00;
    assign RegWrite = (add | sub | ori | lw | lui | jal) ? 1 : 0;
    assign ExtOp    = (sw | lw | beq) ? 1 : 0;
    assign ALUSrc   = (sw | lw | ori | lui) ? 1 : 0;
    assign ALUOp = (lui) ? 3'b100 :
				   (ori) ? 3'b011:
				   (sub) ? 3'b001:
				   3'b000;
    assign MemWrite = (sw) ? 1 : 0;
endmodule

