`timescale 1ns / 1ps


module DataPath(
    input clk,
    input reset,
    input sumSrcMuxSel,
    input iSrcMuxSel,
    input sumLoad,
    input iLoad,
    input outLoad,
    input adderSrcMuxSel,
    //
    output iLe10,
    output [7:0] outport
    );
    wire [7:0] w_adderResult,w_sumSrcMuxOut;
    wire [7:0] w_iSrcMuxOut,w_sumRegOut,w_iRegOut;
    wire [7:0] w_adderSrcMuxOut;

    mux_2x1 U_sumSrcMux(
    .sel(sumSrcMuxSel),
    .x0(8'b0),
    .x1(w_adderResult),
    .y(w_sumSrcMuxOut)
    );
    mux_2x1 U_iSrcMux(
    .sel(iSrcMuxSel),
    .x0(8'b0),
    .x1(w_adderResult),
    .y(w_iSrcMuxOut)
    );
    register U_sumReg(
        .clk(clk),
        .reset(reset),
        .load(sumLoad),
        .d(w_sumSrcMuxOut),
        .q(w_sumRegOut)
    );
    register U_iReg(
        .clk(clk),
        .reset(reset),
        .load(iLoad),
        .d(w_iSrcMuxOut),
        .q(w_iRegOut)
    );
    comparator U_iLe10(
        .a(w_iRegOut),
        .b(8'd10),
        .le(iLe10)
    );

    mux_2x1 U_adderSrcMux (
    .sel(adderSrcMuxSel),
    .x0(w_sumRegOut),
    .x1(8'd1),
    .y(w_adderSrcMuxOut)
    );

adder U_Adder(
    .a(w_adderSrcMuxOut),
    .b(w_iRegOut),
    .y(w_adderResult)
);
register U_outReg(
    .clk(clk),
    .reset(reset),
    .load(outLoad),
    .d(w_sumRegOut),
    .q(outport)
);
endmodule


module mux_2x1 (
    input             sel,
    input       [7:0] x0,
    input       [7:0] x1,
    output reg  [7:0] y
);
    always @(*) begin
        case (sel)
            1'b0: y = x0; 
            1'b1: y = x1; 
        endcase
    end
endmodule

module register (
    input             clk,
    input             reset,
    input             load,
    input       [7:0] d,
    output reg  [7:0] q
);
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            q <= 0;
        end else begin
            if(load) q <= d;
            else q <= q; // remain 자기 자신
        end
    end
endmodule

module comparator (
    input       [7:0] a,
    input       [7:0] b,
    output            le
);
    assign le = (a <= b)? 1 : 0;
endmodule

module adder (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] y
);
    assign y = a+b;
endmodule

