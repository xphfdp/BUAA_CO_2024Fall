`timescale 1ns / 1ps
`include "macro.v"
module M_LSEXC(
    input [31:0] Address,
    input [2:0] DEop,
    input [2:0] BEop,
    input Load,
    input Store,
    input StoreOverflow,
    input LoadOverflow,
    output excAdEL_load,
    output excAdES_store
);
    wire StoreAlign = ((BEop == `BEop_sw) && (Address[1:0] != 2'b00)) || ((BEop == `BEop_sh) && Address[0]);
    wire StoreOutOfRange = !((Address >= `DM_start && Address <= `DM_end) || (Address >= `Timer0_start && Address <= `Timer0_end) || (Address >= `Timer1_start && Address <= `Timer1_end));
    wire StoreTimer = (Address >= `Timer_count0_start && Address <= `Timer_count0_end) || (Address >= `Timer_count1_start && Address <= `Timer_count1_end) || (Address >= `Timer0_start && BEop != `BEop_sw);

    wire LoadAlign = ((DEop == `DEop_lw) && (Address[1:0] != 2'b00)) || ((DEop == `DEop_lh) && Address[0]);
    wire LoadOutOfRange = !((Address >= `DM_start && Address <= `DM_end) || (Address >= `Timer0_start && Address <= `Timer0_end) || (Address >= `Timer1_start && Address <= `Timer1_end));
    wire LoadTimer = ((DEop != `DEop_lw) && Address >= `Timer0_start);

    assign excAdEL_load = (Load) && (LoadAlign || LoadOutOfRange || LoadTimer || LoadOverflow);
    assign excAdES_store = (Store) && (StoreAlign || StoreOutOfRange || StoreTimer || StoreOverflow);
endmodule