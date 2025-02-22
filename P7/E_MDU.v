`timescale 1ns / 1ps
`include "macro.v"

module E_MDU(
    input clk,
    input reset,
    input Start,
    input req,
    input [3:0] MDUop,
    input [31:0] Rs_data,
    input [31:0] Rt_data,
    output Stall_mdu,
    output reg [31:0] HI,
    output reg [31:0] LO
);
    reg busy;
    reg [31:0] temp_HI;
    reg [31:0] temp_LO;
    reg [31:0] cycle_count;
    assign Stall_mdu = busy | Start;

    initial begin
        cycle_count <= 32'b0;
        busy <= 1'b0;
        HI <= 32'b0;
        LO <= 32'b0;
        temp_HI <= 32'b0;
        temp_LO <= 32'b0;
    end


    always@(posedge clk) begin
        if(reset) begin
            cycle_count <= 32'b0;
            busy <= 1'b0;
            HI <= 32'b0;
            LO <= 32'b0;
            temp_HI <= 32'b0;
            temp_LO <= 32'b0;
        end else if(!req) begin
            if(cycle_count == 32'b00) begin
                if(Start) begin
                    busy <= 1'b1;
                    if(MDUop == `MDUop_mult || MDUop == `MDUop_multu) begin
                        cycle_count <= 32'd5;
                    end else if(MDUop == `MDUop_div || MDUop == `MDUop_divu) begin
                        cycle_count <= 32'd10;
                    end
                    case(MDUop)
                        `MDUop_mult:begin
                            {temp_HI,temp_LO} <= $signed(Rs_data) * $signed(Rt_data);
                        end
                        `MDUop_multu:begin
                            {temp_HI,temp_LO} <= Rs_data * Rt_data;
                        end
                        `MDUop_div:begin
                            temp_HI <= $signed(Rs_data) % $signed(Rt_data);
                            temp_LO <= $signed(Rs_data) / $signed(Rt_data);
                        end
                        `MDUop_divu:begin
                            temp_HI <= Rs_data % Rt_data;
                            temp_LO <= Rs_data / Rt_data;
                        end
                        default:begin
                            temp_HI <= 32'b00;
                            temp_LO <= 32'b00;
                        end
                    endcase 
                end else begin
                    cycle_count <= 32'b00;
                end
            end else if(cycle_count == 32'd1) begin
                HI <= temp_HI;
                LO <= temp_LO;
                busy <= 1'b0;
                cycle_count <= 32'b00;
            end else begin
                cycle_count <= cycle_count - 32'd1;
            end
        end
    end

    always@(posedge clk) begin
        if(MDUop == `MDUop_mthi) begin
            HI <= Rs_data;
        end else if(MDUop == `MDUop_mtlo) begin
            LO <= Rs_data;
        end
    end
endmodule