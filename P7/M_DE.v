`timescale 1ns / 1ps
`include "macro.v"

module M_DE(
    input [31:0] A,
    input [31:0] Din,
    input [2:0] DEop,
    output reg [31:0] Dout
);
    always@(*) begin
        case(DEop)
            `DEop_lw:begin
                Dout = Din;
            end
            `DEop_lb:begin
                case(A[1:0])
                    2'b00: Dout = {{24{Din[7]}},Din[7:0]};
                    2'b01: Dout = {{24{Din[15]}},Din[15:8]};
                    2'b10: Dout = {{24{Din[23]}},Din[23:16]};
                    2'b11: Dout = {{24{Din[31]}},Din[31:24]};
                endcase
            end
            `DEop_lh:begin
                case(A[1])
                    1'b1: Dout = {{16{Din[31]}},Din[31:16]};
                    1'b0: Dout = {{16{Din[15]}},Din[15:0]};
                endcase
            end
        endcase
    end 
endmodule