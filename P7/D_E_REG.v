`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:00 11/13/2024 
// Design Name: 
// Module Name:    D_E_REG 
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
module D_E_REG(
    input enable,   // ��Ϊ1
    input clk,
    input reset,    // stall
    input req,
    input stall,
    input [31:0] D_PC,
    input [31:0] D_Instr,
    input [31:0] D_EXTout,
    input [31:0] D_Rsout,
    input [31:0] D_Rtout,
    input D_jump,
    input D_DelaySlot,
    input [4:0] D_EXCCode,
    output reg [31:0] E_PC,
    output reg [31:0] E_Instr,
    output reg [31:0] E_EXTout,
    output reg [31:0] E_Rsout,
    output reg [31:0] E_Rtout,
    output reg E_jump,
    output reg E_DelaySlot,
    output reg [4:0] E_EXCCode
);
    initial begin
        E_PC <= `instr_start;
        E_Instr <= 32'b00;
        E_EXTout <= 32'b00;
        E_Rsout <= 32'b00;
        E_Rtout <= 32'b00;
        E_jump <= 1'b0;
        E_DelaySlot <= 1'b0;
        E_EXCCode <= 5'b00;
    end
    always@(posedge clk) begin
        if(reset | req) begin
            //E_PC <= (req)?`exception_entrance:`instr_start;
            E_PC <= (stall)? D_PC : (req ? `exception_entrance : `instr_start);
            E_Instr <= 32'b00;
            E_EXTout <= 32'b00;
            E_Rsout <= 32'b00;
            E_Rtout <= 32'b00;
            E_jump <= 1'b0;
            E_DelaySlot <= stall? D_DelaySlot:1'b0;
            E_EXCCode <= 5'b00;
        end else if(enable) begin
            E_PC <= D_PC;
            E_Instr <= D_Instr;
            E_EXTout <= D_EXTout;
            E_Rsout <= D_Rsout;
            E_Rtout <= D_Rtout;
            E_jump <= D_jump;
            E_DelaySlot <= D_DelaySlot;
            E_EXCCode <= D_EXCCode;
        end
    end
endmodule