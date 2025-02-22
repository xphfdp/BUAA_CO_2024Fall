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
	 input [2:0] CMPop,
	 output FDflush,
    output Jump_b
);
	 wire equ = (Rtout == Rsout);
	 wire ltz = ($signed(Rsout) < 0);
	 assign FDflush = (CMPop == `CMPop_bltzall && !Jump_b);
	 assign Jump_b = ((CMPop == `CMPop_beq) && (equ))||
						  ((CMPop == `CMPop_bltzal) && (ltz))||
						  ((CMPop == `CMPop_bltzall) && (ltz));
endmodule