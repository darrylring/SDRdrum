`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2017 05:36:32 PM
// Design Name: 
// Module Name: sdrdrum_arty_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sdrdrum_arty_tb;

reg clk = 1'b0;
reg eth_clk = 1'b0;
reg rstn = 1'b0;

sdrdrum_arty dut (
    
    .clk_in(clk),
    .rstn_in(rstn),

    .adc_a_data(1'b0),
    .adc_b_data(1'b0),
    .adc_c_data(1'b0),
    .adc_d_data(1'b0),
    
    // Ethernet
    .eth_phy_rxd(4'b0),
    .eth_phy_rx_clk(1'b0),
    .eth_phy_rx_dv(1'b0),
    .eth_phy_rx_er(1'b0),
    
    .eth_phy_tx_clk(eth_clk),
    
    .eth_phy_crs(1'b0),
    .eth_phy_col(1'b0),
    
    // IO
    .switches(4'b0),
    .buttons(4'b0)
);

initial begin
    #500 rstn = 1'b1;
end

always begin
    #20 eth_clk = ~eth_clk;
end

always begin
    #5 clk = ~clk;
end

endmodule
