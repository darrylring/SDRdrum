`timescale 1ns / 1ps

module test_eth_framer_tb;

reg clk = 1'b0;
reg reset = 1'b0;
reg eth_clk = 1'b0;

test_eth_framer dut (
    .clk_in(clk),
    .rstn_in(reset),
    .eth_phy_tx_clk(eth_clk),
    .eth_phy_rx_clk(eth_clk)
);

initial begin
    #5 clk <= ~clk;
    #5 clk <= ~clk;
    #5 clk <= ~clk;
    #5 clk <= ~clk; reset = 1'b1;
    #5 clk <= ~clk;
    #5 clk <= ~clk;
end

always begin
    #5 clk <= ~clk;
end

always begin
    #20 eth_clk <= ~eth_clk;
end

endmodule
