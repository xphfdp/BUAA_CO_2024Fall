`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:02:49 10/31/2024 
// Design Name: 
// Module Name:    mips 
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
module mips(
	input clk, 
	input reset
    );

	wire [31:0] pc, pcPlus4, instr, npc, rd1, rd2, aluout, imme32, aluin2, wd, DMaddr, dmout;
	wire [2:0] aluop, npcop;
	wire[1:0]  regdst, memtoreg;
	wire [5:0] opcode, func;
	wire [4:0] rs, rt, rd, shamt, addr;
	wire [15:0] imme16;
	wire[25:0] imme26;
	wire extop, zero, memwrite, regwrite, alusrc;

	IFU _ifu(
		.clk(clk),
		.reset(reset), 
		.Npc(npc), 
		.Pc(pc), 
		.Instr(instr)
   );

	NPC _npc(
		.Pc(pc), 
		.NpcOp(npcop), 
		.JrReg(rd1), 
		.Imme26(imme26), 
		.Zero(zero), 
		.PcPlus4(pcPlus4), 
		.Npc(npc)
   );
	 
	EXT _ext(
		.Imme16(imme16), 
		.ExtOp(extop), 
		.Imme32(imme32)
   );
	 
	DIS _dis(
		.Instr(instr), 
		.Opcode(opcode), 
		.Rs(rs), 
		.Rt(rt), 
		.Rd(rd), 
		.Shamt(shamt), 
		.Func(func), 
		.Imme16(imme16), 
		.Imme26(imme26)
   );

	ctrl _ctrl(
		.Opcode(opcode), 
		.Func(func), 
		.NPCOp(npcop), 
		.RegDst(regdst), 
		.MemtoReg(memtoreg), 
		.RegWrite(regwrite), 
		.ExtOp(extop), 
		.ALUSrc(alusrc), 
		.ALUOp(aluop), 
		.MemWrite(memwrite)
   );

	assign aluin2 = (alusrc == 0) ? rd2 : imme32;

	ALU _alu(
		.RD1(rd1), 
		.RD2(aluin2), 
		.ALUOp(aluop), 
		.ALUout(aluout), 
		.Zero(zero)
   );

	assign addr = (regdst == 0) ? rt:
					  (regdst == 2'b01) ? rd :
				     (regdst == 2'b10) ? 5'd31:
				     0;
	assign wd = (memtoreg == 0) ? aluout : 
					(memtoreg == 2'b01) ? dmout : 
					(memtoreg == 2'b10) ? pcPlus4:
					0;
	GRF _grf(
		.clk(clk), 
		.reset(reset), 
		.RegWrite(regwrite), 
		.RA1(rs), 
		.RA2(rt), 
		.WA(addr), 
		.WD(wd), 
		.PC(pc), 
		.RD1(rd1), 
		.RD2(rd2)
   );
    
	DM _dm(
		.clk(clk), 
		.reset(reset), 
		.MemWrite(memwrite), 
		.WA(aluout), 
		.WD(rd2), 
		.PC(pc), 
		.RD(dmout)
   );
	

endmodule