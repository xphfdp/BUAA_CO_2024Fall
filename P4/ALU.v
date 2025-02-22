`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:56:37 10/31/2024 
// Design Name: 
// Module Name:    ALU 
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
module ALU(input [31:0] RD1,
           input [31:0] RD2,
           input [2:0] ALUOp,
           output reg [31:0]ALUout,
           output Zero);
    
    always@(*) begin
        case(ALUOp)
            3'b000: ALUout <= RD1 + RD2;
            3'b001: ALUout <= RD1 - RD2;
            3'b010: ALUout <= RD1 & RD2;
            3'b011: ALUout <= RD1 | RD2;
            3'b100: ALUout <= {{RD2[15:0]}, {16{1'b0}}};
        endcase
    end
    assign Zero = (RD1 == RD2)?1:0;
endmodule
