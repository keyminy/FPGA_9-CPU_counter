`timescale 1ns / 1ps


module tb_dedicatedProcessor();
    reg           clk;
    reg           reset;
    wire [7:0]    outPort;

    top_counter dut_top_counter(
        .clk(clk),
        .reset(reset),
        .outPort(outPort)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        #10 reset = 0;
        // end at 350ns
        #350 $finish;
    end
endmodule
