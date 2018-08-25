////////////////////////////////////////////////////////////////////////////////
// 
//  Copyright (c) 2018, Darryl Ring.
// 
//  This program is free software: you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation, either version 3 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along with
//  this program; if not, see <https://www.gnu.org/licenses/>.
//
//  Additional permission under GNU GPL version 3 section 7:
//  If you modify this program, or any covered work, by linking or combining it
//  with independent modules provided by the FPGA vendor only (this permission
//  does not extend to any 3rd party modules, "soft cores" or macros) under
//  different license terms solely for the purpose of generating binary
//  "bitstream" files and/or simulating the code, the copyright holders of this
//  program give you the right to distribute the covered work without those
//  independent modules as long as the source code for them is available from
//  the FPGA vendor free of charge, and there is no dependence on any encrypted
//  modules for simulating of the combined code. This permission applies to you
//  if the distributed code contains all the components and scripts required to
//  completely simulate it with at least one of the Free Software programs.
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

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
