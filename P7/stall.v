`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:21 11/13/2024 
// Design Name: 
// Module Name:    stall 
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

module stall(
    input [31:0] D_Instr,
    input [31:0] E_Instr,
    input [31:0] M_Instr,
    output stall
);
    wire [4:0] D_RegReadDst_rs;
    wire [4:0] D_RegReadDst_rt;
    wire [4:0] E_RegWriteDst;
    wire [4:0] M_RegWriteDst;
	wire [1:0] Tuse_rs,Tuse_rt,Tnew_E,Tnew_M;
    wire D_eret,E_mtc0,M_mtc0;
    wire [4:0] E_RegReadDst_rd;
    wire [4:0] M_RegReadDst_rd;

    control D_control(
        .Instr(D_Instr),
        .Rs(D_RegReadDst_rs),
        .Rt(D_RegReadDst_rt),
        .Tuse_rs(Tuse_rs),
        .Tuse_rt(Tuse_rt),
        .Eret(D_eret)
    );

    control E_control(
        .Instr(E_Instr),
        .Tnew_E(Tnew_E),
        .RegWriteDst(E_RegWriteDst),
        .Mtc0(E_mtc0),
        .Rd(E_RegReadDst_rd)
    );

    control M_control(
        .Instr(M_Instr),
        .Tnew_M(Tnew_M),
        .RegWriteDst(M_RegWriteDst),
        .Mtc0(M_mtc0),
        .Rd(M_RegReadDst_rd)
    );
    wire stall_E_rs = ((D_RegReadDst_rs != 5'b00_000) && (D_RegReadDst_rs == E_RegWriteDst) && (Tnew_E > Tuse_rs));
    wire stall_E_rt = ((D_RegReadDst_rt != 5'b00_000) && (D_RegReadDst_rt == E_RegWriteDst) && (Tnew_E > Tuse_rt));
    wire stall_M_rs = ((D_RegReadDst_rs != 5'b00_000) && (D_RegReadDst_rs == M_RegWriteDst) && (Tnew_M > Tuse_rs));
    wire stall_M_rt = ((D_RegReadDst_rt != 5'b00_000) && (D_RegReadDst_rt == M_RegWriteDst) && (Tnew_M > Tuse_rt));
    wire stall_M_eret = D_eret && ((E_mtc0 && E_RegReadDst_rd == 5'd14) || (M_mtc0 && M_RegReadDst_rd == 5'd14));
    wire stall_E = stall_E_rs | stall_E_rt;
    wire stall_M = stall_M_rs | stall_M_rt | stall_M_eret;
    assign stall = stall_E | stall_M;
endmodule