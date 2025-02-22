`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:27 11/13/2024 
// Design Name: 
// Module Name:    F_IFU 
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
module F_PC(
    input clk,
    input reset,
    input enable,
    input [31:0] NPC,
    output reg [31:0] PC
);
    initial begin
        PC <= 32'h0000_3000;
    end
    always@(posedge clk) begin
        if(reset) begin
            PC <= 32'h0000_3000;
        end else if(enable) begin
            PC <= NPC;
        end
    end
endmodule