`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:00:29 10/31/2024 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
	input [15:0] Imme16,
	input ExtOp,
	output reg[31:0] Imme32
    );

	always@(*) begin
		if(ExtOp) begin
			Imme32 = {{16{Imme16[15]}}, Imme16};
		end else begin
			Imme32 = {{16{1'b0}}, Imme16};
		end
	end
endmodule
