`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:02 11/13/2024 
// Design Name: 
// Module Name:    M_W_REG 
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
module M_W_REG(
    input clk,
    input reset,    //恒为0
    input enable,   //恒为1
    input req,
    input stall,
    input [31:0] M_PC,
    input [31:0] M_Instr,
    input [31:0] M_DMout,
    input [31:0] M_ALUout,
    input [31:0] M_MDUout,
    input M_jump,
    input [31:0] M_CP0out,
    output reg [31:0] W_PC,
    output reg [31:0] W_Instr,
    output reg [31:0] W_ALUout,
    output reg [31:0] W_DMout,
    output reg [31:0] W_MDUout,
    output reg W_jump,
    output reg [31:0] W_CP0out
);
    initial begin
            W_PC <= `instr_start;
            W_Instr <= 32'b00;
            W_ALUout <= 32'b00;
            W_DMout <= 32'b00;
            W_MDUout <= 32'b00;
            W_jump <= 1'b0;
            W_CP0out <= 32'b00;
    end
    always@(posedge clk) begin
        if(reset | req | stall) begin
            W_PC <= (req)?`exception_entrance:`instr_start;
            W_Instr <= 32'b00;
            W_ALUout <= 32'b00;
            W_DMout <= 32'b00;
            W_MDUout <= 32'b00;
            W_jump <= 1'b0;
            W_CP0out <= 32'b00;
        end else if(enable) begin
            W_PC <= M_PC;
            W_Instr <= M_Instr;
            W_ALUout <= M_ALUout;
            W_DMout <= M_DMout;
            W_MDUout <= M_MDUout;
            W_jump <= M_jump;
            W_CP0out <= M_CP0out;
        end
    end
endmodule