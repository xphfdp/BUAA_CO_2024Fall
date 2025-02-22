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

module control(
    input [31:0] Instr,
    input jump_b,
    output [4:0] Rs,
    output [4:0] Rt,
    output [4:0] Rd,
    output [4:0] Shamt,
    output [15:0] Offset,
    output [25:0] Instr_index,
    output [4:0] RegWriteDst,   //确定每个指令的写回地址
    output [3:0] ALUop,
    output [1:0] EXTop,
	output [1:0] CMPop,
    output RegWrite,
    output [2:0] NPCop,
    output [2:0] BEop,
    output [2:0] DEop,
    output [2:0] FwSel,           //选择转发数据
    output ALUsrc,
    output MemWrite,
    output Load,
    output Store,
    output DelaySlotInstr,

    output [3:0] MDUop,
    output Md,
    output Mf,
    output Mt,
    output Start,

    output [1:0] Tuse_rs,
    output [1:0] Tuse_rt,
    output [1:0] Tnew_E,
    output [1:0] Tnew_M,

    output RI,
    output Syscall,
    output Eret,
    output Mtc0,
    output ALUCalOverflow,      //计算指令溢出
    output ALUStoreOverflow,        //存取指令地址计算溢出
    output ALULoadOverflow
);
    //指令译码
	wire [5:0] Opcode;
    wire [5:0] Func;
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
    wire _and = (special && (Func == `func_and));
    wire _or = (special && (Func == `func_or));
    wire slt = (special && (Func == `func_slt));
    wire sltu = (special && (Func == `func_sltu));
    wire addi = (Opcode == `opcode_addi);
    wire andi = (Opcode == `opcode_andi);
    wire lb = (Opcode == `opcode_lb);
    wire lh = (Opcode == `opcode_lh);
    wire sb = (Opcode == `opcode_sb);
    wire sh = (Opcode == `opcode_sh);
    wire mult = (special && (Func == `func_mult));
    wire multu = (special && (Func == `func_multu));
    wire div = (special && (Func == `func_div));
    wire divu = (special && (Func == `func_divu));
    wire mfhi = (special && (Func == `func_mfhi));
    wire mflo = (special && (Func == `func_mflo));
    wire mthi = (special && (Func == `func_mthi));
    wire mtlo = (special && (Func == `func_mtlo));
    wire bne = (Opcode == `opcode_bne);
    wire syscall = (special && (Func == `func_syscall));
    wire eret = (Instr == `eret);
    wire mfc0 = (Opcode == `opcode_mfc0 && Rs == `rs_mfc0);
    wire mtc0 = (Opcode == `opcode_mtc0 && Rs == `rs_mtc0);
    wire nop = (Instr == `nop);
    
    //指令分类
    wire all_instr = (nop | add | sub | _and | _or | slt | sltu | lui | addi | andi | ori |
                  lb | lh | lw | sb | sh | sw | mult | multu | div | divu | mfhi | mflo |
                  mthi | mtlo | beq | bne | jal | jr | mfc0 | mtc0 | eret | syscall);
    assign Md = mult | multu | div | divu;
    assign Mf = mfhi | mflo;
    assign Mt = mthi | mtlo;
    wire cal_r = add |sub | slt | sltu | _and | _or;
    wire cal_i = lui | ori | addi | andi;
    wire branch = beq | bne;
    wire load = lw | lh | lb;
    wire store = sw | sh | sb;
    assign Load = load;
    assign Store = store;
    assign DelaySlotInstr = branch | jal | jr;

    //异常相关
    assign RI = !all_instr;
    assign Syscall = syscall;
    assign Eret = eret;
    assign Mtc0 = mtc0;
    assign ALUCalOverflow = add | addi | sub;
    assign ALUStoreOverflow = store;
    assign ALULoadOverflow = load;

    //控制信号生成
	assign RegWrite = 1'b1;
    assign Start = (Md);
    assign MDUop = (mult)?`MDUop_mult:
                   (multu)?`MDUop_multu:
                   (div)?`MDUop_div:
                   (divu)?`MDUop_divu:
                   (mfhi)?`MDUop_mfhi:
                   (mflo)?`MDUop_mflo:
                   (mthi)?`MDUop_mthi:
                   (mtlo)?`MDUop_mtlo:
                   `MDUop_null;
    assign BEop = (sw)?`BEop_sw:
                  (sh)?`BEop_sh:
                  (sb)?`BEop_sb:
                  3'b000;
    assign DEop = (lw)?`DEop_lw:
                  (lh)?`DEop_lh:
                  (lb)?`DEop_lb:
                  3'b000;
	assign CMPop = (beq)?`CMPop_beq:
                   (bne)?`CMPop_bne:
                   2'b00;
    assign ALUop = (sub)?`ALUop_sub:
                    (ori | _or)?`ALUop_ori:
                    (lui)?`ALUop_lui:
                    (_and | andi)?`ALUop_and:
                    (slt)?`ALUop_slt:
                    (sltu)?`ALUop_sltu:
                    `ALUop_add;
    assign EXTop = (load | store | addi)?`EXTop_s:
                    `EXTop_0;
    assign NPCop = (branch)?`NPCop_b:
                   (jal)?`NPCop_jal:
                   (jr)?`NPCop_jr:
                   `NPCop_PC4;
    assign MemWrite = (store)?1:0;
    assign ALUsrc = (load | store | cal_i)?1:0;

    //阻塞及转发信号生成
    assign FwSel = (jal)?`FwSel_pc8:
               (cal_r | cal_i)?`FwSel_aluout:
               (load)?`FwSel_dmout:
               (Mf)?`FwSel_mduout:
               (mfc0)?`FwSel_CP0out:
               3'b000;
    assign RegWriteDst = (cal_r | Mf) ? Rd:
                         (load | cal_i | mfc0) ? Rt:
                         (jal) ? 5'd31:
                         5'b00_000;
    assign Tnew_E = (cal_r | cal_i | Mf)? 2'b01:
                    (load | mfc0)? 2'b10:
                    2'b00;
    assign Tnew_M = (load | mfc0)?2'b01:
                    2'b00;
    assign Tuse_rs = (cal_r | cal_i | load | store | Md | Mt) ? 2'b01:
                     (branch | jr)?2'b00:
                     2'b11;//2'b11表示该指令不会用到该寄存器
    assign Tuse_rt = (cal_r| Md)?2'b01:
                     (store | mtc0)?2'b10:
                     (branch)?2'b00:
                     2'b11;
endmodule