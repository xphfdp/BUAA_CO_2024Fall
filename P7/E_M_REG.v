`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:34 11/13/2024 
// Design Name: 
// Module Name:    E_M_REG 
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
module E_M_REG(
    input clk,
    input reset,    //恒为0
    input enable,   //恒为1
    input req,
    input stall,
    input [31:0] E_PC,
    input [31:0] E_Instr,
    input [31:0] E_ALUout,
    input [31:0] E_Rtout,
    input [31:0] E_MDUout,
    input E_jump,
    input E_DelaySlot,
    input [4:0] E_EXCCode,
    input E_StoreOverflow,
    input E_LoadOverflow,
    output reg [31:0] M_ALUout,
    output reg [31:0] M_Rtout,
    output reg [31:0] M_PC,
    output reg [31:0] M_Instr,
    output reg [31:0] M_MDUout,
    output reg M_jump,
    output reg M_DelaySlot,
    output reg [4:0] M_EXCCode,
    output reg M_StoreOverflow,
    output reg M_LoadOverflow
);
    initial begin
            M_PC <= `instr_start;
            M_Instr <= 32'b00;
            M_ALUout <= 32'b00;
            M_Rtout <= 32'b00;
            M_MDUout <= 32'b00;
            M_jump <= 1'b0;
            M_DelaySlot <= 1'b0;
            M_EXCCode <= 5'b00;
            M_StoreOverflow <= 1'b0;
            M_LoadOverflow <= 1'b0;
    end
    always@(posedge clk) begin
        if(reset | req | stall) begin
            M_PC <= (req)?`exception_entrance:`instr_start;
            M_Instr <= 32'b00;
            M_ALUout <= 32'b00;
            M_Rtout <= 32'b00;
            M_MDUout <= 32'b00;
            M_jump <= 1'b0;
            M_DelaySlot <= 1'b0;
            M_EXCCode <= 5'b00;
            M_StoreOverflow <= 1'b0;
            M_LoadOverflow <= 1'b0;
        end else if(enable) begin
            M_PC <= E_PC;
            M_Instr <= E_Instr;
            M_ALUout <= E_ALUout;
            M_Rtout <= E_Rtout;
            M_MDUout <= E_MDUout;
            M_jump <= E_jump;
            M_DelaySlot <= E_DelaySlot;
            M_EXCCode <= E_EXCCode;
            M_StoreOverflow <= E_StoreOverflow;
            M_LoadOverflow <= E_LoadOverflow;
        end
    end
endmodule