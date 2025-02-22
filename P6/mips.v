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

module mips(
    input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
);
    //新增端口相关
    assign f_instr = i_inst_rdata;
    assign de_in = m_data_rdata;
    assign i_inst_addr = f_pc;
    assign m_data_addr = m_aluout;
    assign m_data_wdata = be_wd;
    assign m_data_byteen = byteen;
    assign w_inst_addr = w_pc;
    assign m_inst_addr = m_pc;
    assign w_grf_wdata = w_grfwd;
    assign w_grf_we = 1'b1;
    assign w_grf_addr = w_regdst;

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
                     (m_fwsel == `FwSel_mduout)?m_mduout:
                     (m_fwsel == `FwSel_pc8)?m_pc + 32'd8:
                     32'bz;
    assign w_grfwd = (w_fwsel == `FwSel_aluout)?w_aluout:
                     (w_fwsel == `FwSel_pc8)?w_pc + 32'd8:
                     (w_fwsel == `FwSel_mduout)?w_mduout:
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
    wire stall_mdu;
    /*wire stall_e_mdu;
    wire STALL;
    assign STALL = stall | stall_e_mdu;*/
    wire STALL = stall | (stall_mdu && (D_mt | D_mf | D_md));
    stall _stall(
        .D_Instr(d_instr),
        .E_Instr(e_instr),
        .M_Instr(m_instr),
        .stall(stall)
    );

    //F级
	wire [31:0] d_npc;

    F_PC _pc(
        .clk(clk),
        .reset(reset),
        .enable(~STALL),
        .NPC(d_npc),
        .PC(f_pc)
    );

	 //D级
	wire [15:0] d_offset;
    wire [25:0] d_instr_index;
    wire [2:0] d_npcop;
    wire [1:0] d_extop;
    wire jump_b;
    wire [1:0] cmpop;
	wire regwrite;
    wire [4:0] d_rs,d_rt;
    wire [31:0] d_rs_out,d_rt_out;      //GRF输出
    wire [31:0] d_extout;
    wire D_mt;
    wire D_mf;
    wire D_md;

    F_D_REG _dreg(
        .clk(clk),
        .reset(reset),
        .enable(~STALL),
        .F_PC(f_pc),
        .F_Instr(f_instr),
        .D_PC(d_pc),
        .D_Instr(d_instr)
    );


    control D_contrl(
        .Instr(d_instr),
        .Rs(d_rs),
        .Rt(d_rt),
        .Md(D_md),
        .Mf(D_mf),
        .Mt(D_mt),
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
    wire [3:0] e_aluop;
    wire [4:0] e_rs,e_rt;
    wire [31:0] e_aluout;
    wire [31:0] e_ALUA,e_ALUB;
    wire [31:0] e_rs_out,e_rt_out;
    wire [31:0] e_mduout;
    wire alusrc;
    wire e_busy;
    wire e_start;
    wire [3:0] e_mduop;
    wire [31:0] hi;
    wire [31:0] lo;

    assign e_ALUA = e_fw_rs;
    assign e_ALUB = (alusrc == 0)?e_fw_rt:e_extout;
	assign e_mduout = (e_mduop == `MDUop_mfhi)?hi:
                      (e_mduop == `MDUop_mflo)?lo:
                      32'bz;//处理mflo、mfhi指令

    D_E_REG _ereg(
        .clk(clk),
        .reset(STALL | reset),
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
        .Start(e_start),
        .MDUop(e_mduop),
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

    E_MDU _mdu(
        .clk(clk),
        .reset(reset),
        .Start(e_start),
        .MDUop(e_mduop),
        .Rs_data(e_fw_rs),
        .Rt_data(e_fw_rt),
        .Stall_mdu(stall_mdu),
        .HI(hi),
        .LO(lo)
    );

	 //M级
    wire [2:0] beop;
    wire [2:0] deop;
    wire [4:0] m_rt;
    wire [31:0] m_rt_out;
    wire [31:0] m_dmout;
    wire [31:0] m_aluout;
    wire [31:0] de_in;
    wire [31:0] be_wd;
    wire [3:0] byteen;
    wire [31:0] m_mduout;
    wire [31:0] w_mduout;
    								  
    E_M_REG _mreg(
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .E_PC(e_pc),
        .E_Instr(e_instr),
        .E_ALUout(e_aluout),
        .E_Rtout(e_fw_rt),
        .E_MDUout(e_mduout),
        .M_ALUout(m_aluout),
        .M_Rtout(m_rt_out),
        .M_PC(m_pc),
        .M_Instr(m_instr),
        .M_MDUout(m_mduout)
    );

    control M_control(
        .Instr(m_instr),
        .Rt(m_rt),
        .DEop(deop),
        .BEop(beop),
        .RegWriteDst(m_regdst),
        .FwSel(m_fwsel)
    );

    M_BE _be(
        .Addr(m_aluout),
        .BEop(beop),
        .Rt_data(m_fw_rt),
        .Byteen(byteen),
        .WD(be_wd)
    );

    M_DE _de(
        .A(m_aluout),
        .Din(de_in),
        .DEop(deop),
        .Dout(m_dmout)
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
        .M_MDUout(m_mduout),
        .W_PC(w_pc),
        .W_Instr(w_instr),
        .W_DMout(w_dmout),
        .W_ALUout(w_aluout),
        .W_MDUout(w_mduout)
    );

    //W级
    control W_control(
        .Instr(w_instr),
        .RegWriteDst(w_regdst),
        .FwSel(w_fwsel)
    );
endmodule
