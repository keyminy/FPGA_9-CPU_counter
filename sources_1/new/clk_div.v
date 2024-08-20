module clk_div #(
    parameter HZ = 10
)(
    input clk,
    input reset,
    output o_clk
);
    reg [$clog2(100_000_000/HZ)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always @(posedge clk , posedge reset) begin
        if(reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == 100_000_000/HZ-1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule
