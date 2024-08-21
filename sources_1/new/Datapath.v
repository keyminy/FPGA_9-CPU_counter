`timescale 1ns / 1ps

module Datapath(
    input clk,
    input reset,
    input ASrcMuxSel,
    input SumSrcMuxSel,
    input ALoad,
    input SumLoad,
    input OutPort,
    //
    output ALt10,
    output ALt11,
    output [7:0] o_OutPort
    );
    wire [7:0] w_MuxOut;
    wire [7:0] w_MuxOut_Sum;
    wire [7:0] w_ARegOut;
    wire [7:0] w_SumRegOut;
    wire [7:0] w_AdderResult;
    wire [7:0] w_Adder_Sum_Result;

 mux_2x1 U_Mux (
    .sel(ASrcMuxSel),
    .x0(8'b0),
    .x1(w_AdderResult),
    .y(w_MuxOut)
);
 mux_2x1 U_Mux_sum (
    .sel(SumSrcMuxSel),
    .x0(8'b0),
    .x1(w_Adder_Sum_Result),
    .y(w_MuxOut_Sum)
);

register U_AReg (
    .clk(clk),
    .reset(reset),
    .load(ALoad),
    .d(w_MuxOut),
    //
    .q(w_ARegOut)
);
register U_SumReg(
    .clk(clk),
    .reset(reset),
    .load(SumLoad),
    .d(8'd0),
    //
    .q(w_SumRegOut)
);

adder U_Adder_Sum (
    .a(w_SumRegOut),
    .b(w_ARegOut),
    .y(w_Adder_Sum_Result)
);


comparator U_Comp(
    .a(w_ARegOut),
    .b(8'd10),
    //
    .lt(ALt10)
);
//added for sum 1 to 10
comparator U_Comp_forSum(
    .a(w_SumRegOut),
    .b(8'd11),
    //
    .lt(SumLt11)
);

adder U_Adder (
    .a(w_ARegOut),
    .b(8'd1),
    .y(w_AdderResult)
);


// removed this to remain output...!(in class lecture)
// outBuf U_OutPort (
//     .en(OutPort),
//     .a(w_ARegOut),
//     //
//     .y(o_OutPort)
// );

register U_OutPortReg (
    .clk(clk),
    .reset(reset),
    .load(OutPort),
    .d(w_Adder_Sum_Result),
    //
    .q(o_OutPort)
);

// A_register U_outPort(
//     .clk(clk),
//     .rst(rst),
//     .load(Outport),
//     .d(w_AregOut), 
//     .q(o_Outport)
// );

endmodule


module mux_2x1 (
    input sel,
    input [7:0] x0,
    input [7:0] x1,
    output reg [7:0] y
);
    always @(*) begin
        case (sel)
            1'b0: y = x0; 
            1'b1: y = x1; 
        endcase
    end
endmodule

module register (
    input      clk,
    input      reset,
    input      load,
    input       [7:0] d,
    output reg  [7:0] q
);
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            q <= 0;
        end else begin
            // load값이 1일때, d값이 q의 출력으로
            if(load) q <= d;
            else q <= q; // 자기자신 유지
        end
    end   
endmodule

module comparator (
    input   [7:0]     a,
    input   [7:0]     b,
    output  [7:0]    lt,
    output  [7:0]    gt,
    output  [7:0]    eq
);
    assign lt = (a<b) ? 1 : 0;
    // assign gt = (a>b) ? 1 : 0;
    // assign eq = (a==b) ? 1: 0;
endmodule


module adder (
    input [7:0] a,
    input [7:0] b,
    output [7:0] y
);
    assign y = a+b;
endmodule

module outBuf (
    input en,
    input [7:0] a,
    output [7:0] y
);
    assign y = (en) ? a : 1'bz;
endmodule
