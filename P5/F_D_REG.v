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

module F_D_REG(
    input [31:0] F_PC,
    input [31:0] F_Instr,
    input clk,
    input reset,
    input enable,   // ~stall
    output reg [31:0] D_PC,
    output reg [31:0] D_Instr
);
    always@(posedge clk) begin
        if(reset) begin
            D_PC <= 32'h0000_3000;
            D_Instr <= 32'b00;
        end else if(enable) begin
            D_PC <= F_PC;
            D_Instr <= F_Instr;
        end
    end
endmodule