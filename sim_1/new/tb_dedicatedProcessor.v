`timescale 1ns / 1ps

module tb_dedicatedProcessor();
    reg clk;
    reg reset;
    wire [7:0] outport;

    dedicatedProcessor dut(
    .clk(clk),
    .reset(reset),
    .outport(outport)
    );
    always #5 clk = ~clk;
    initial begin
        #00 clk = 1'b0; reset = 1'b1;
        #10 reset = 1'b0;
        #500 $finish;
    end
endmodule
