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

module E_M_REG(
    input clk,
    input reset,    //ºãÎª0
    input enable,   //ºãÎª1
    input [31:0] E_PC,
    input [31:0] E_Instr,
    input [31:0] E_ALUout,
    input [31:0] E_Rtout,
    input [31:0] E_MDUout,
    output reg [31:0] M_ALUout,
    output reg [31:0] M_Rtout,
    output reg [31:0] M_PC,
    output reg [31:0] M_Instr,
    output reg [31:0] M_MDUout
);
    initial begin
            M_PC <= 32'h0000_3000;
            M_Instr <= 32'b00;
            M_ALUout <= 32'b00;
            M_Rtout <= 32'b00;
            M_MDUout <= 32'b00;
    end
    always@(posedge clk) begin
        if(reset) begin
            M_PC <= 32'h0000_3000;
            M_Instr <= 32'b00;
            M_ALUout <= 32'b00;
            M_Rtout <= 32'b00;
            M_MDUout <= 32'b00;
        end else if(enable) begin
            M_PC <= E_PC;
            M_Instr <= E_Instr;
            M_ALUout <= E_ALUout;
            M_Rtout <= E_Rtout;
            M_MDUout <= E_MDUout;
        end
    end
endmodule