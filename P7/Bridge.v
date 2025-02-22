`timescale 1ns / 1ps
`include "macro.v"
module Bridge(
	input interrupt,
	output [5:0] HWInt,
	output [3:0] m_int_byteen,
	output [31:0] m_int_addr,

	output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
	input [31:0] m_data_rdata,
	output [3:0] m_data_byteen,
	
	input [31:0] temp_m_data_addr,
    input [31:0] temp_m_data_wdata,
	output [31:0] temp_m_data_rdata,
    input [3:0] temp_m_data_byteen,
	
	output [31:0] Timer0_address,
    output Timer0_enable,
    output [31:0] Timer0_Din,
    input [31:0] Timer0_Dout,
	input Timer0_IRQ,

    output [31:0] Timer1_address,
    output Timer1_enable,
    output [31:0] Timer1_Din,
    input [31:0] Timer1_Dout,
	input Timer1_IRQ
    );
	
	assign HWInt = {3'b000,interrupt,Timer1_IRQ,Timer0_IRQ};
	assign m_int_addr = ((temp_m_data_addr >= `interrupt_start && temp_m_data_addr <= `interrupt_end) && (temp_m_data_byteen != 4'b0000))?temp_m_data_addr:32'b00;
	assign m_int_byteen = ((temp_m_data_addr >= `interrupt_start && temp_m_data_addr <= `interrupt_end) && (temp_m_data_byteen != 4'b0000))?temp_m_data_byteen:4'b0000;

	assign m_data_addr = temp_m_data_addr;
	assign m_data_wdata = temp_m_data_wdata;
	
	assign Timer0_address = temp_m_data_addr;
	assign Timer0_Din = temp_m_data_wdata;
	assign Timer0_enable = (temp_m_data_byteen != 4'b0000) && (Timer0_address >= `Timer0_start && Timer0_address <= `Timer0_end);

	assign Timer1_address = temp_m_data_addr;
	assign Timer1_Din = temp_m_data_wdata;
	assign Timer1_enable = (temp_m_data_byteen != 4'b0000) && (Timer1_address >= `Timer1_start && Timer1_address <= `Timer1_end);

	assign m_data_byteen = ((Timer0_address >= `Timer0_start && Timer0_address <= `Timer0_end) || (Timer1_address >= `Timer1_start && Timer1_address <= `Timer1_end))?4'b0000:temp_m_data_byteen;
	assign temp_m_data_rdata = (Timer0_address >= `Timer0_start && Timer0_address <= `Timer0_end)?Timer0_Dout:
							   (Timer1_address >= `Timer1_start && Timer1_address <= `Timer1_end)?Timer1_Dout:
							   m_data_rdata;
endmodule
