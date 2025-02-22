`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:01:04 10/31/2024 
// Design Name: 
// Module Name:    DIS 
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
module DIS(
	input [31:0] Instr,
	output [5:0] Opcode,
	output [4:0] Rs, 
	output [4:0] Rt,
	output [4:0] Rd,
	output [4:0] Shamt,
	output [5:0] Func,
	output [15:0] Imme16,
	output [25:0] Imme26
    );

	assign Opcode = {Instr[31:26]};
	assign Rs = {Instr[25:21]};
	 assign Rt = {Instr[20:16]};
	 assign Rd = {Instr[15:11]};
	 assign Shamt = {Instr[10:6]};
	 assign Func = {Instr[5:0]};
	 assign Imme16 = {Instr[15:0]};
	 assign Imme26 = {Instr[25:0]};

endmodule
