`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:40 11/13/2024 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
    input [31:0] Rtout,
    input [31:0] Rsout,
	 input [1:0] CMPop,
    output Jump_b
);
	 wire equ = (Rtout == Rsout);
     wire nequ = (Rtout != Rsout);
	 assign Jump_b = ((CMPop == `CMPop_beq) && (equ))?1'b1:
                     ((CMPop == `CMPop_bne) && (nequ))?1'b1:
                     1'b0;
endmodule