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

module F_IFU(
    input [31:0] NPC,
    input clk,
    input reset,
    input enable,
    output reg [31:0] PC,
    output [31:0] Instr
);
    reg [31:0] rom [0:4095];
    wire [31:0] pcMinus = PC - 32'h0000_3000;
    wire [11:0] address = pcMinus[13:2];
    initial begin
        PC <= 32'h0000_3000;
        $readmemh("code.txt",rom);    
    end

    always@(posedge clk) begin
        if(reset) begin
            PC <= 32'h0000_3000;
        end else if(enable) begin
            PC <= NPC;
        end
    end

    assign Instr = rom[address];
endmodule