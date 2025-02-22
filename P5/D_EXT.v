`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:19 11/13/2024 
// Design Name: 
// Module Name:    D_EXT 
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

module D_EXT(
    input [15:0] Imme16,
    input EXTop,
    output [31:0] Imme32
);
    assign Imme32 = (EXTop)?{{16{Imme16[15]}},Imme16}:{{16{1'b0}},Imme16};
endmodule
