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
    /*input [1:0] Tnew_E,
    input [1:0] Tnew_M,
    input [1:0] Tuse_rs,
    input [1:0] Tuse_rt,
    input [4:0] D_RegDst,
    input [4:0] E_RegDst,
    input [4:0] M_RegDst,*/
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
    control D_control(
        .Instr(D_Instr),
        .Rs(D_RegReadDst_rs),
        .Rt(D_RegReadDst_rt),
        .Tuse_rs(Tuse_rs),
        .Tuse_rt(Tuse_rt)
    );

    control E_control(
        .Instr(E_Instr),
        .Tnew_E(Tnew_E),
        .RegWriteDst(E_RegWriteDst)
    );

    control M_control(
        .Instr(M_Instr),
        .Tnew_M(Tnew_M),
        .RegWriteDst(M_RegWriteDst)
    );
    wire stall_E_rs = ((D_RegReadDst_rs != 5'b00_000) && (D_RegReadDst_rs == E_RegWriteDst) && (Tnew_E > Tuse_rs));
    wire stall_E_rt = ((D_RegReadDst_rt != 5'b00_000) && (D_RegReadDst_rt == E_RegWriteDst) && (Tnew_E > Tuse_rt));
    wire stall_M_rs = ((D_RegReadDst_rs != 5'b00_000) && (D_RegReadDst_rs == M_RegWriteDst) && (Tnew_M > Tuse_rs));
    wire stall_M_rt = ((D_RegReadDst_rt != 5'b00_000) && (D_RegReadDst_rt == M_RegWriteDst) && (Tnew_M > Tuse_rt));
    wire stall_E = stall_E_rs | stall_E_rt;
    wire stall_M = stall_M_rs | stall_M_rt;
    assign stall = stall_E | stall_M;
endmodule