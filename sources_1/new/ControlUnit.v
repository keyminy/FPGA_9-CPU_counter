`timescale 1ns / 1ps


module ControlUnit(
    input clk,
    input reset,
    input iLe10,
    //
    output reg sumSrcMuxSel,
    output reg iSrcMuxSel,
    output reg sumLoad,
    output reg iLoad,
    output reg outLoad,
    output reg adderSrcMuxSel
    );
    localparam S0 = 3'd0,S1=3'd1,S2=3'd2,S3=3'd3,S4=3'd4,S5=3'd5;
    reg [2:0] state,next_state;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S0: next_state = S1;
            S1: begin
                if(iLe10) next_state = S2;
                else next_state = S5; // go to HALT
            end
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S1;
            S5: next_state = S5;
        endcase
    end

    always @(*) begin
        // prevent latch
        sumSrcMuxSel = 0;
        iSrcMuxSel = 0;
        sumLoad = 0;
        iLoad = 0;
        adderSrcMuxSel = 0;
        outLoad = 0;
        case (state)
            S0:begin
                sumSrcMuxSel = 0;
                iSrcMuxSel = 0;
                sumLoad = 1;
                iLoad = 1;
                adderSrcMuxSel = 0;// don't care
                outLoad = 0;
            end 
            S1:begin // i=0,sum=0
                sumSrcMuxSel = 0;
                iSrcMuxSel = 0;
                sumLoad = 0;
                iLoad = 0;
                adderSrcMuxSel = 0;
                outLoad = 0;
            end
            S2:begin // iLe10 = 1
                sumSrcMuxSel = 1;
                iSrcMuxSel = 0;
                sumLoad = 1;
                iLoad = 0;
                adderSrcMuxSel = 0;
                outLoad = 0;
            end
            S3: begin // sum=sum+i
                sumSrcMuxSel = 0;
                iSrcMuxSel = 1;
                sumLoad = 0;
                iLoad = 1;
                adderSrcMuxSel = 1;
                outLoad = 0;
            end
            S4:begin // output = sum
                sumSrcMuxSel = 0;
                iSrcMuxSel = 0;
                sumLoad = 0;
                iLoad = 0;
                adderSrcMuxSel = 0;
                outLoad = 1;
            end
            S5: begin // halt
                sumSrcMuxSel = 0;
                iSrcMuxSel = 0;
                sumLoad = 0;
                iLoad = 0;
                adderSrcMuxSel = 0;
                outLoad = 0;
            end
        endcase
    end

endmodule
