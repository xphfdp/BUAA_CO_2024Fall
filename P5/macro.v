`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:06 11/13/2024 
// Design Name: 
// Module Name:    macro 
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
// ÷∏¡Ó∫Í
`define special 6'b000_000
`define func_add 6'b100_000
`define func_sub 6'b100_010
`define func_jr 6'b001_000
`define opcode_beq 6'b000_100
`define opcode_jal 6'b000_011
`define opcode_lw 6'b100_011
`define opcode_sw 6'b101_011
`define opcode_ori 6'b001_101
`define opcode_lui 6'b001_111

// «–∆¨∫Í
`define opcode 31:26
`define func 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define offset 15:0
`define shamt 10:6
`define instr_index 25:0

// –≈∫≈∫Í
`define ALUSrc_RD2 1'b0
`define ALUSrc_i32 1'b1
`define RegDst_rt 2'b00
`define RegDst_rd 2'b01
`define RegDst_jr 2'b10
`define ALUop_add 2'b00
`define ALUop_sub 2'b01
`define ALUop_ori 2'b10
`define ALUop_lui 2'b11
`define MemtoReg_DMout 2'b01
`define MemtoReg_ALUout 2'b00
`define MemtoReg_PC8 2'b10
`define EXTop_0 1'b0
`define EXTop_s 1'b1
`define NPCop_PC4 3'b000
`define NPCop_b 3'b001
`define NPCop_jal 3'b010
`define NPCop_jr 3'b011
`define FwSel_pc8 3'b010
`define FwSel_aluout 3'b001
`define FwSel_dmout 3'b011
`define CMPop_beq 3'b001
`define CMPop_bltzal 3'b010
`define CMPop_bltzall 3'b011