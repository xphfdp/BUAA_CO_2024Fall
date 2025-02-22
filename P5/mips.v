`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:50 11/13/2024 
// Design Name: 
// Module Name:    mips 
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
//`default_nettype none
`include "macro.v"

module mips(input clk,
            input reset
            );
    //各级流水线传递的PC和Instr
    wire [31:0] f_pc,f_instr;
    wire [31:0] d_pc,d_instr;
    wire [31:0] e_pc,e_instr;
    wire [31:0] m_pc,m_instr;
    wire [31:0] w_pc,w_instr;

    //各级流水线写入GRF的地址
    wire [4:0] f_regdst;
    wire [4:0] d_regdst;
    wire [4:0] e_regdst;
    wire [4:0] m_regdst;
    wire [4:0] w_regdst;

    //转发选择信号
    wire [2:0] e_fwsel;
    wire [2:0] m_fwsel;
    wire [2:0] w_fwsel;

    //各级流水线写入GRF的数据
    wire [31:0] e_grfwd;
    wire [31:0] m_grfwd;
    wire [31:0] w_grfwd;
    assign e_grfwd = (e_fwsel == `FwSel_pc8)?e_pc + 32'd8:
                     32'bz;
    assign m_grfwd = (m_fwsel == `FwSel_aluout)?m_aluout:
                     (m_fwsel == `FwSel_pc8)?m_pc + 32'd8:
                     32'bz;
    assign w_grfwd = (w_fwsel == `FwSel_aluout)?w_aluout:
                     (w_fwsel == `FwSel_pc8)?w_pc + 32'd8:
                     (w_fwsel == `FwSel_dmout)?w_dmout:
                     32'bz;
    
    //转发
    wire [31:0] d_fw_rs,d_fw_rt;
    wire [31:0] e_fw_rs,e_fw_rt;
    wire [31:0] m_fw_rt;
    assign d_fw_rs = (d_rs == 5'b00_000)?32'b00:
                     (d_rs == e_regdst)?e_grfwd:
                     (d_rs == m_regdst)?m_grfwd:
                     d_rs_out;
    assign d_fw_rt = (d_rt == 5'b00_000) ?32'b00:
                     (d_rt == e_regdst)?e_grfwd:
                     (d_rt == m_regdst)?m_grfwd:
                     d_rt_out;
	
    assign e_fw_rs = (e_rs == 5'b00_000)?32'b00:
                     (e_rs == m_regdst)?m_grfwd:
                     (e_rs == w_regdst)?w_grfwd:
                     e_rs_out;
    assign e_fw_rt = (e_rt == 5'b00_000)?32'b00:
                     (e_rt == m_regdst)?m_grfwd:
                     (e_rt == w_regdst)?w_grfwd:
                     e_rt_out;

    assign m_fw_rt = (m_rt == 5'b00_000)?32'b00:
                     (m_rt == w_regdst)?w_grfwd:
                     m_rt_out;
                     
    //阻塞
    wire stall;
    stall _stall(
        .D_Instr(d_instr),
        .E_Instr(e_instr),
        .M_Instr(m_instr),
        .stall(stall)
    );
    //F级
	 wire [31:0] d_npc;

    F_IFU _ifu(
        .clk(clk),
        .reset(reset),
        .enable(~stall),
        .NPC(d_npc),
        .PC(f_pc),
        .Instr(f_instr)
    );

	 //D级
	 wire [15:0] d_offset;
    wire [25:0] d_instr_index;
    wire [2:0] d_npcop;
    wire d_extop;
    wire jump_b;
	 wire fdflush;
	 wire [2:0] cmpop;
	 wire regwrite;
    wire [4:0] d_rs,d_rt;
    wire [31:0] d_rs_out,d_rt_out;      //GRF输出
    wire [31:0] d_extout;

    F_D_REG _dreg(
        .clk(clk),
        .reset(reset || (fdflush && ~stall)),
        .enable(~stall),
        .F_PC(f_pc),
        .F_Instr(f_instr),
        .D_PC(d_pc),
        .D_Instr(d_instr)
    );


    control D_contrl(
        .Instr(d_instr),
        .Rs(d_rs),
        .Rt(d_rt),
        .Offset(d_offset),
        .Instr_index(d_instr_index),
		  .CMPop(cmpop),
		  .RegWrite(regwrite),
        .EXTop(d_extop),
        .NPCop(d_npcop)
    );

    D_NPC _npc(
        .Offset(d_offset),
        .Instr_index(d_instr_index),
        .NPCop(d_npcop),
        .JrReg(d_fw_rs),
        .F_PC(f_pc),
        .D_PC(d_pc),
        .Zero(jump_b),
        .Npc(d_npc)
    );

    D_EXT _ext(
        .Imme16(d_offset),
        .EXTop(d_extop),
        .Imme32(d_extout)
    );

    D_CMP _cmp(
        .Rsout(d_fw_rs),
        .Rtout(d_fw_rt),
		  .CMPop(cmpop),
		  .FDflush(fdflush),
        .Jump_b(jump_b)
    );

    D_GRF _grf(
        .clk(clk),
        .reset(reset),
        .RegWrite(regwrite),
        .RA1(d_rs),
        .RA2(d_rt),
        .WA(w_regdst),
        .WD(w_grfwd),
        .PC(w_pc),
        .RD1(d_rs_out),
        .RD2(d_rt_out)
    );
	 
	 //E级
	 wire [31:0] e_extout;
    wire [2:0] e_aluop;
    wire [4:0] e_rs,e_rt;
    wire [31:0] e_aluout;
    wire [31:0] e_ALUA,e_ALUB;
    wire [31:0] e_rs_out,e_rt_out;
    wire alusrc;
    //wire e_reset = stall | reset;

    assign e_ALUA = e_fw_rs;
    assign e_ALUB = (alusrc == 0)?e_fw_rt:e_extout;
	
    D_E_REG _ereg(
        .clk(clk),
        .reset(stall | reset),
        .enable(1'b1),
        .D_PC(d_pc),
        .D_Instr(d_instr),
        .D_EXTout(d_extout),
        .D_Rsout(d_fw_rs),
        .D_Rtout(d_fw_rt),
        .E_PC(e_pc),
        .E_Instr(e_instr),
        .E_EXTout(e_extout),
        .E_Rsout(e_rs_out),
        .E_Rtout(e_rt_out)
    );


    control E_control(
        .Instr(e_instr),
        .Rs(e_rs),
        .Rt(e_rt),
        .ALUsrc(alusrc),
        .ALUop(e_aluop),
        .RegWriteDst(e_regdst),
        .FwSel(e_fwsel)
    );

    E_ALU _alu(
        .A(e_ALUA),
        .B(e_ALUB),
        .ALUop(e_aluop),
        .ALUout(e_aluout)
    );

	 //M级
	 wire memwrite;
    wire [4:0] m_rt;
    wire [31:0] m_rt_out;
    wire [31:0] m_dmout;
    wire [31:0] m_aluout;
								  
    E_M_REG _mreg(
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .E_PC(e_pc),
        .E_Instr(e_instr),
        .E_ALUout(e_aluout),
        .E_Rtout(e_fw_rt),
        .M_ALUout(m_aluout),
        .M_Rtout(m_rt_out),
        .M_PC(m_pc),
        .M_Instr(m_instr)
    );

    control M_control(
        .Instr(m_instr),
        .Rt(m_rt),
        .MemWrite(memwrite),
        .RegWriteDst(m_regdst),
        .FwSel(m_fwsel)
    );

    M_DM _dm(
        .clk(clk),
        .reset(reset),
        .WE(memwrite),
        .PC(m_pc),
        .WA(m_aluout),
        .WD(m_fw_rt),
        .DMout(m_dmout)
    );
	 
    wire [31:0] w_aluout;
    wire [31:0] w_dmout;
	 
    M_W_REG _wreg(
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .M_PC(m_pc),
        .M_Instr(m_instr),
        .M_DMout(m_dmout),
        .M_ALUout(m_aluout),
        .W_PC(w_pc),
        .W_Instr(w_instr),
        .W_DMout(w_dmout),
        .W_ALUout(w_aluout)
    );

    //W级
    control W_control(
        .Instr(w_instr),
        .RegWriteDst(w_regdst),
        .FwSel(w_fwsel)
    );
endmodule
