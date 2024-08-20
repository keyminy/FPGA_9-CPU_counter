`timescale 1ns / 1ps

module top (
    input clk,
    input reset,
    output [3:0] fndCom,
    output [7:0] fndFont
);
    wire [7:0] w_counter; //8비트 카운터 출력

    top_counter U_DediProc(
    .clk(clk),
    .reset(reset),
    //
    .outPort(w_counter) 
    );

    FndController U_FndCont (
    .clk(clk),
    .reset(reset),
    .digit({6'b0,w_counter}),
    .fndCom(fndCom),
    .fndFont(fndFont)
    );
    
endmodule

module top_counter(
    input           clk,
    input           reset,
    output [7:0]    outPort
    );

    wire w_ASrcMuxSel, w_ALoad, w_ALt10, w_OutPort;
    wire w_clk_10hz;

    Datapath U_DP(
    .clk(w_clk_10hz),
    .reset(reset),
    .ASrcMuxSel(w_ASrcMuxSel),
    .ALoad(w_ALoad),
    .OutPort(w_OutPort),
    //
    .ALt10(w_ALt10),
    .o_OutPort(outPort)
    );

    ControlUnit U_CU(
    .clk(w_clk_10hz),
    .reset(reset),
    .ALt10(w_ALt10),
    //
    .ASrcMuxSel(w_ASrcMuxSel),
    .ALoad(w_ALoad),
    .OutPort(w_OutPort)
    );

    clk_div # (
        .HZ(10)
    ) U_clkDiv(
        .clk(clk),
        .reset(reset),
        .o_clk(w_clk_10hz)
    );


endmodule
