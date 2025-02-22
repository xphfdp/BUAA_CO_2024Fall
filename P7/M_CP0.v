`timescale 1ns/1ps
`include "macro.v"

`define IM SR[15:10]
`define EXL SR[1]
`define IE SR[0]
`define BD Cause[31]
`define IP Cause[15:10]
`define ExcCode Cause[6:2]
module M_CP0(
    input clk,
    input reset,
    input enable,
    input [4:0] CP0Address,
    input [31:0] CP0In,
    output reg [31:0] CP0Out,
    input [31:0] VPC,
    input BDIn,
    input [4:0] ExcCodeIn,
    input [5:0] HWInt,
    input EXLClr,
    output reg [31:0] EPCOut,
    output reg Req
);
    reg [31:0] SR;
    reg [31:0] Cause;
    reg [31:0] EPC;
    initial begin
        SR <= 32'b00;
        Cause <= 32'b00;
        EPC <= 32'b00;
    end
    reg ExcReq,IntReq;
    wire [31:0] temp_EPC = (Req)?((BDIn)?VPC - 32'd4:VPC):EPC;
    wire [5:0] interrupt = `IM & HWInt;

    always@(posedge clk) begin
        if(reset) begin
            SR <= 32'b00;
            Cause <= 32'b00;
            EPC <= 32'b00;
        end else begin
            if(EXLClr) begin
                `EXL <= 1'b0;
            end
            
            if(Req) begin
                `ExcCode <= (IntReq) ? 5'b00_000 : ExcCodeIn;
                `EXL <= 1'b1;
                EPC <= temp_EPC;
                `BD <= BDIn;
            end else if(enable) begin
                if(CP0Address == 5'd12) begin
                    SR <= CP0In;
                end else if(CP0Address == 5'd14) begin
                    EPC <= CP0In;
                end
            end
            `IP <= HWInt;
        end
    end

    always@(*) begin
        ExcReq = (ExcCodeIn != 5'b00_000) && !`EXL;
        IntReq = (interrupt != 6'b000_000) && !`EXL && `IE;
        Req = ExcReq | IntReq;
        EPCOut = temp_EPC;

        if(CP0Address == `Status_address) begin
            CP0Out = SR;
        end else if(CP0Address == `Cause_address) begin
            CP0Out = Cause;
        end else if(CP0Address == `EPC_address) begin
            CP0Out = EPC;
        end else begin
            CP0Out = 32'b00;
        end
    end
endmodule