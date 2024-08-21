`timescale 1ns / 1ps

module dedicatedProcessor(
    input clk,
    input reset,
    output [7:0] outport
    );
    wire sumSrcMuxSel;
    wire iSrcMuxSel;
    wire sumLoad;
    wire iLoad;
    wire outLoad;
    wire adderSrcMuxSel;
    //
    wire iLe10;

    ControlUnit U_CU(
    .clk(clk),
    .reset(reset),
    .iLe10(iLe10),
    //
    .sumSrcMuxSel(sumSrcMuxSel),
    .iSrcMuxSel(iSrcMuxSel),
    .sumLoad(sumLoad),
    .iLoad(iLoad),
    .outLoad(outLoad),
    .adderSrcMuxSel(adderSrcMuxSel)
    );

    DataPath U_DP(
    .clk(clk),
    .reset(reset),
    .sumSrcMuxSel(sumSrcMuxSel),
    .iSrcMuxSel(iSrcMuxSel),
    .sumLoad(sumLoad),
    .iLoad(iLoad),
    .outLoad(outLoad),
    .adderSrcMuxSel(adderSrcMuxSel),
    //
    .iLe10(iLe10),
    .outport(outport)
    );
endmodule


