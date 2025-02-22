`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:53 11/13/2024 
// Design Name: 
// Module Name:    F_D_REG 
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
module F_D_REG(
    input [31:0] F_PC,
    input [31:0] F_Instr,
    input F_DelaySlot,
    input [4:0] F_EXCCode,
    input clk,
    input reset,
    input enable,   // ~stall
    input req,
    input stall,
    output reg [31:0] D_PC,
    output reg [4:0] D_EXCCode,
    output reg D_DelaySlot,
    output reg [31:0] D_Instr
);
    initial begin
        D_PC <= `instr_start;
        D_Instr <= 32'b00;
        D_DelaySlot <= 1'b0;
        D_EXCCode <= 5'b00;
    end
    always@(posedge clk) begin
        if(reset | req | stall) begin
            D_PC <= (req)?`exception_entrance:`instr_start;
            D_Instr <= 32'b00;
            D_DelaySlot <= 1'b0;
            D_EXCCode <= 5'b00;
        end else if(enable) begin
            D_PC <= F_PC;
            D_Instr <= F_Instr;
            D_DelaySlot <= F_DelaySlot;
            D_EXCCode <= F_EXCCode;
        end
    end
endmodule