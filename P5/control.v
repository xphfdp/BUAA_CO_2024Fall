`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:19 11/13/2024 
// Design Name: 
// Module Name:    control 
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

module control(
    input [31:0] Instr,
    //output [5:0] Opcode,
    //output [5:0] Func,
    output [4:0] Rs,
    output [4:0] Rt,
    output [4:0] Rd,
    output [4:0] Shamt,
    output [15:0] Offset,
    output [25:0] Instr_index,
    output [4:0] RegWriteDst,   //确定每个指令的写回地址
    output [2:0] ALUop,
    output EXTop,
	 output [2:0] CMPop,
    output RegWrite,
    output [2:0] NPCop,
    output [2:0] FwSel,           //选择转发数据
    output ALUsrc,
    output MemWrite,

    output [1:0] Tuse_rs,
    output [1:0] Tuse_rt,
    output [1:0] Tnew_E,
    output [1:0] Tnew_M
);
    //指令译码
	 wire [5:0] Opcode,Func;
    assign Opcode = Instr[`opcode];
    assign Func = Instr[`func];
    assign Rs = Instr[`rs];
    assign Rt = Instr[`rt];
    assign Rd = Instr[`rd];
    assign Shamt = Instr[`shamt];
    assign Offset = Instr[`offset];
    assign Instr_index = Instr[`instr_index];

    //指令定义
    wire special = (Opcode == `special);
    wire add = (special && (Func == `func_add));
    wire sub = (special && (Func == `func_sub));
    wire ori = (Opcode == `opcode_ori);
    wire lw = (Opcode == `opcode_lw);
    wire sw = (Opcode == `opcode_sw);
    wire lui = (Opcode == `opcode_lui);
    wire beq = (Opcode == `opcode_beq);
    wire jal = (Opcode == `opcode_jal);
    wire jr = (special && (Func == `func_jr));
	 wire bltzal = (Opcode == 6'b000_001 && Rt == 5'b10_000);
	 wire bltzall = (Opcode == 6'b000_001 && Rt == 5'b10_010);
	 
    //控制信号生成
	 assign RegWrite = 1'b1;
	 assign CMPop = (beq)?`CMPop_beq:
						 (bltzal)?`CMPop_bltzal:
						 (bltzall)?`CMPop_bltzall:
						 2'b00;
    assign ALUop = (sub)?`ALUop_sub:
                    (ori)?`ALUop_ori:
                    (lui)?`ALUop_lui:
                    `ALUop_add;
    assign EXTop = (lw | sw)?`EXTop_s:
                    `EXTop_0;
    assign NPCop = (beq | bltzal | bltzall)?`NPCop_b:
                   (jal)?`NPCop_jal:
                   (jr)?`NPCop_jr:
                   `NPCop_PC4;
    assign MemWrite = (sw)?1:0;
    assign ALUsrc = (lw | sw | lui | ori)?1:0;

    //阻塞及转发信号生成
    wire cal = add | sub | ori | lui;   //返回ALUout的指令
	 wire dm = lw;
    assign FwSel = (jal | bltzal | bltzall)?`FwSel_pc8:
               (cal)?`FwSel_aluout:
               (dm)?`FwSel_dmout:
               0;
    assign RegWriteDst = (add | sub) ? Rd:
                         (ori | lw | lui) ? Rt:
                         (jal | bltzal | bltzall) ? 5'd31:
                         5'b00_000;
    assign Tnew_E = (add | sub | ori | lui)? 2'b01:
                    (lw)? 2'b10:
                    2'b00;
    assign Tnew_M = (lw)?2'b01:
                    2'b00;
    assign Tuse_rs = (add | sub | ori | lw | sw | lui) ? 2'b01:
                     (beq | jr | bltzal | bltzall)?2'b00:
                     2'b11;//2'b11表示该指令不会用到该寄存器
    assign Tuse_rt = (add | sub)?2'b01:
                     (sw)?2'b10:
                     (beq)?2'b00:
                     2'b11;
endmodule