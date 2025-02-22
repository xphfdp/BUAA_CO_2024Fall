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
/////////////////////////////////////////////////////////////////////////////////
//`default_nettype none
`include "macro.v"
`define byte3 31:24
`define byte2 23:16
`define byte1 15:8
`define byte0 7:0

module M_BE(
    input [31:0] Addr,
    input [2:0] BEop,
    input [31:0] Rt_data,
    input enable,
    output reg [3:0] Byteen,
    output reg [31:0] WD
);

    always@(*) begin
        if(enable) begin
            case(BEop)
                `BEop_sw:Byteen = 4'b1111;
                `BEop_sh:begin
                    if(Addr[1] == 1'b0) begin
                        Byteen = 4'b0011;
                    end else begin
                        Byteen = 4'b1100;
                    end
                end
                `BEop_sb:begin
                    if(Addr[1:0] == 2'b00) begin
                        Byteen = 4'b0001;
                    end else if(Addr[1:0] == 2'b01) begin
                        Byteen = 4'b0010;
                    end else if(Addr[1:0] == 2'b10) begin
                        Byteen = 4'b0100;
                    end else if(Addr[1:0] == 2'b11) begin
                        Byteen = 4'b1000;
                    end
                end
                default:Byteen = 4'b0000;
            endcase
        end else begin
            Byteen = 4'b0000;
        end
    end 

    always@(*) begin
        case(BEop)
            `BEop_sw:begin
                WD = Rt_data;
            end
            `BEop_sh:begin
                if(Addr[1] == 1'b0) begin
                    WD[`byte3] = 8'b0;
                    WD[`byte2] = 8'b0;
                    WD[`byte1] = Rt_data[`byte1];
                    WD[`byte0] = Rt_data[`byte0];
                end else if(Addr[1] == 1'b1) begin
                    WD[`byte3] = Rt_data[`byte1];
                    WD[`byte2] = Rt_data[`byte0];
                    WD[`byte1] = 8'b0;
                    WD[`byte0] = 8'b0;
                end
            end
            `BEop_sb:begin
                if(Addr[1:0] == 2'b00) begin
                    WD[`byte3] = 8'b0;
                    WD[`byte2] = 8'b0;
                    WD[`byte1] = 8'b0;
                    WD[`byte0] = Rt_data[`byte0];
                end else if(Addr[1:0] == 2'b01) begin
                    WD[`byte3] = 8'b0;
                    WD[`byte2] = 8'b0;
                    WD[`byte1] = Rt_data[`byte0];
                    WD[`byte0] = 8'b0;
                end else if(Addr[1:0] == 2'b10) begin
                    WD[`byte3] = 8'b0;
                    WD[`byte2] = Rt_data[`byte0];
                    WD[`byte1] = 8'b0;
                    WD[`byte0] = 8'b0;
                end else if(Addr[1:0] == 2'b11) begin
                    WD[`byte3] = Rt_data[`byte0];
                    WD[`byte2] = 8'b0;
                    WD[`byte1] = 8'b0;
                    WD[`byte0] = 8'b0;
                end
            end
            default:WD = 32'b00;
        endcase
    end
endmodule