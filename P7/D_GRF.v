`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:36 11/13/2024 
// Design Name: 
// Module Name:    D_GRF 
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

module D_GRF(
    input clk,
    input reset,
    input RegWrite,
    input [4:0] RA1,
    input [4:0] RA2,
    input [4:0] WA,
    input [31:0] WD,
    input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
);
    integer i;
    reg [31:0] grf [0:31];

    initial begin
        for(i=0;i<32;i=i+1) begin
            grf[i] <= 0;
        end
    end

    always@(posedge clk) begin
        if(reset) begin
            for(i=0;i<32;i=i+1) begin
                grf[i] <= 0;
            end
        end else if(RegWrite && (WA!=5'b00_000)) begin
            grf[WA] <= WD;
        end
    end

    assign RD1 = (RA1 == 5'b00_000)?32'b00:
                 ((RA1 == WA) && RegWrite)?WD:
                 grf[RA1];
    assign RD2 = (RA2 == 5'b00_000)?32'b00:
                 ((RA2 == WA) && RegWrite)?WD:
                 grf[RA2];
endmodule