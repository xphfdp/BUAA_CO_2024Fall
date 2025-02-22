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

module M_W_REG(
    input clk,
    input reset,    //ºãÎª0
    input enable,   //ºãÎª1
    input [31:0] M_PC,
    input [31:0] M_Instr,
    input [31:0] M_DMout,
    input [31:0] M_ALUout,
    input [31:0] M_MDUout,
    output reg [31:0] W_PC,
    output reg [31:0] W_Instr,
    output reg [31:0] W_ALUout,
    output reg [31:0] W_DMout,
    output reg [31:0] W_MDUout
);
    initial begin
            W_PC <= 32'h0000_3000;
            W_Instr <= 32'b00;
            W_ALUout <= 32'b00;
            W_DMout <= 32'b00;
            W_MDUout <= 32'b00;
    end
    always@(posedge clk) begin
        if(reset) begin
            W_PC <= 32'h0000_3000;
            W_Instr <= 32'b00;
            W_ALUout <= 32'b00;
            W_DMout <= 32'b00;
            W_MDUout <= 32'b00;
        end else if(enable) begin
            W_PC <= M_PC;
            W_Instr <= M_Instr;
            W_ALUout <= M_ALUout;
            W_DMout <= M_DMout;
            W_MDUout <= M_MDUout;
        end
    end
endmodule