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
`define func_and 6'b100_100
`define func_or 6'b100_101
`define func_slt 6'b101_010
`define func_sltu 6'b101_011
`define opcode_addi 6'b001_000
`define opcode_andi 6'b001_100
`define opcode_lb 6'b100_000
`define opcode_lh 6'b100_001
`define opcode_sb 6'b101_000
`define opcode_sh 6'b101_001
`define func_mult 6'b011_000
`define func_multu 6'b011_001
`define func_div 6'b011_010
`define func_divu 6'b011_011
`define func_mfhi 6'b010_000
`define func_mflo 6'b010_010
`define func_mthi 6'b010_001
`define func_mtlo 6'b010_011
`define opcode_bne 6'b000_101

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

`define ALUop_add 4'b0000
`define ALUop_sub 4'b0001
`define ALUop_ori 4'b0010
`define ALUop_lui 4'b0011
`define ALUop_and 4'b0100
`define ALUop_slt 4'b0101
`define ALUop_sltu 4'b0110

`define MemtoReg_DMout 2'b01
`define MemtoReg_ALUout 2'b00
`define MemtoReg_PC8 2'b10

`define EXTop_0 2'b00
`define EXTop_s 2'b01

`define NPCop_PC4 3'b000
`define NPCop_b 3'b001
`define NPCop_jal 3'b010
`define NPCop_jr 3'b011

`define FwSel_pc8 3'b010
`define FwSel_aluout 3'b001
`define FwSel_dmout 3'b011
`define FwSel_mduout 3'b100

`define CMPop_beq 2'b01
`define CMPop_bne 2'b10

`define BEop_sw 3'b001
`define BEop_sh 3'b010 
`define BEop_sb 3'b011

`define DEop_lw 3'b000
`define DEop_lbu 3'b001
`define DEop_lb 3'b010
`define DEop_lhu 3'b011
`define DEop_lh 3'b100

`define MDUop_mult 4'b0000
`define MDUop_multu 4'b0001
`define MDUop_div 4'b0010
`define MDUop_divu 4'b0011
`define MDUop_mfhi 4'b0100
`define MDUop_mflo 4'b0101
`define MDUop_mthi 4'b0110
`define MDUop_mtlo 4'b0111