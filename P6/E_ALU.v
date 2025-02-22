`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:14 11/13/2024 
// Design Name: 
// Module Name:    E_ALU 
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
`include "macro.v"
//`default_nettype none

module E_ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUop,
    output reg [31:0] ALUout
);
    always@(*) begin
        case(ALUop)
            `ALUop_add: ALUout = A + B;
            `ALUop_sub: ALUout = A - B;
            `ALUop_ori: ALUout = A | B;
            `ALUop_lui: ALUout = {{B[15:0]}, {16{1'b0}}};
            `ALUop_and: ALUout = A & B;
            `ALUop_slt: ALUout = ($signed(A) < $signed(B));
            `ALUop_sltu: ALUout = (A < B);
        endcase
    end 
endmodule