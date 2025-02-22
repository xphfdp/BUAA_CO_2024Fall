`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:44 11/13/2024 
// Design Name: 
// Module Name:    M_DM 
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

module M_DM(
    input clk,
    input reset,
    input WE,
    input [31:0] PC,
    input [31:0] WA,
    input [31:0] WD,
    output [31:0] DMout
);
    integer i;
    reg [31:0] ram [0:3071];
    initial begin
        for(i=0;i<3072;i=i+1) begin
            ram[i] <= 32'b00;
        end
    end

    always@(posedge clk) begin
        if(reset) begin
            for(i=0;i<3072;i=i+1) begin
                ram[i] <= 32'b00;
            end
        end else if(WE) begin
            ram[WA[31:2]] <= WD;
            $display("%d@%h: *%h <= %h", $time, PC, WA, WD);
        end
    end

    assign DMout = ram[WA[13:2]];
endmodule