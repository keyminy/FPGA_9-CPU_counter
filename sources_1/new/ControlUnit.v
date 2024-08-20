`timescale 1ns / 1ps

module ControlUnit (
    input clk,
    input reset,
    input ALt10,
    //
    output reg ASrcMuxSel,
    output reg ALoad,
    output reg OutPort
    );
    reg [2:0] state,next_state;

    localparam  S0 = 3'b000;
    localparam  S1 = 3'b001;
    localparam  S2 = 3'b010;
    localparam  S3 = 3'b011;
    localparam  S4 = 3'b100;

    // 1. state register
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end
    // 2. next_state combinational logic
    always @(*) begin
        // default value
        next_state = state;
        ASrcMuxSel  = 1'b0;
        ALoad       = 1'b0;
        OutPort     = 1'b0;
        next_state = S1;
        // Moore machine
        case (state)
            S0: begin
                ASrcMuxSel  = 1'b0;
                ALoad       = 1'b1;
                OutPort     = 1'b0;
                next_state = S1;
            end 
            S1 : begin
                ASrcMuxSel  = 1'b0;
                ALoad       = 1'b0;
                OutPort     = 1'b0;
                if(ALt10) next_state = S2;
                else next_state = S4;
            end
            S2 : begin
                ASrcMuxSel  = 1'b0;
                ALoad       = 1'b0;
                OutPort     = 1'b1;
                next_state = S3;
            end
            S3 : begin
                ASrcMuxSel  = 1'b1;
                ALoad       = 1'b1;
                OutPort     = 1'b0;
                next_state = S1;
            end
            S4 : begin
                ASrcMuxSel  = 1'b0;
                ALoad       = 1'b0;
                OutPort     = 1'b0;
                next_state = S4;
            end
        endcase
    end

endmodule