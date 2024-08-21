`timescale 1ns / 1ps


module top(
    input clk,
    input reset,
    output [3:0] fndCom,
    output [7:0] fndFont
);
    wire [7:0] w_counter; //8비트 카운터 출력
      wire w_clk_10hz;
    dedicatedProcessor U_dedicated(
    .clk(w_clk_10hz),
    .reset(reset),
    .outport(w_counter)
    );

    FndController U_FndCont (
    .clk(clk),
    .reset(reset),
    .digit({6'b0,w_counter}),
    .fndCom(fndCom),
    .fndFont(fndFont)
    );

     clk_div # (
        .HZ(10)
    ) U_clkDiv(
        .clk(clk),
        .reset(reset),
        .o_clk(w_clk_10hz)
    );
endmodule
