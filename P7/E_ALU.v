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
    input ALUCalOverflow,
    input ALUStoreOverflow,
    input ALULoadOverflow,
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUop,
    output reg [31:0] ALUout,
    output reg CalOverflow,
    output reg StoreOverflow,
    output reg LoadOverflow
);
    wire [32:0] AA = {A[31],A};
    wire [32:0] BB = {B[31],B};
    wire [32:0] add_overflow = AA + BB;
    wire [32:0] sub_overflow = AA - BB;

    always@(*) begin
        case(ALUop)
            `ALUop_add: ALUout = A + B;
            `ALUop_sub: ALUout = A - B;
            `ALUop_ori: ALUout = A | B;
            `ALUop_lui: ALUout = {{B[15:0]}, {16{1'b0}}};
            `ALUop_and: ALUout = A & B;
            `ALUop_slt: ALUout = $signed(A) < $signed(B);
            `ALUop_sltu: ALUout = A < B;
            default: ALUout <= 32'b00;
        endcase
    end 

    always@(*) begin
        CalOverflow = (ALUCalOverflow && ((ALUop == `ALUop_add && add_overflow[32] != add_overflow[31]) || (ALUop == `ALUop_sub && sub_overflow[32] != sub_overflow[31])));
        StoreOverflow = (ALUStoreOverflow && ((ALUop == `ALUop_add && add_overflow[32] != add_overflow[31]) || (ALUop == `ALUop_sub && sub_overflow[32] != sub_overflow[31])));
        LoadOverflow = (ALULoadOverflow && ((ALUop == `ALUop_add && add_overflow[32] != add_overflow[31]) || (ALUop == `ALUop_sub && sub_overflow[32] != sub_overflow[31])));
    end 
endmodule