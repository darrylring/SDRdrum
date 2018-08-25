################################################################################
# Copyright (c) 2018, Darryl Ring.
# 
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/>.
#
# Additional permission under GNU GPL version 3 section 7:
# If you modify this program, or any covered work, by linking or combining it
# with independent modules provided by the FPGA vendor only (this permission
# does not extend to any 3rd party modules, "soft cores" or macros) under
# different license terms solely for the purpose of generating binary
# "bitstream" files and/or simulating the code, the copyright holders of this
# program give you the right to distribute the covered work without those
# independent modules as long as the source code for them is available from the
# FPGA vendor free of charge, and there is no dependence on any encrypted
# modules for simulating of the combined code. This permission applies to you if
# the distributed code contains all the components and scripts required to
# completely simulate it with at least one of the Free Software programs.

set_property CONFIG_MODE                 SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33    [current_design]
set_property BITSTREAM.GENERAL.COMPRESS  TRUE  [current_design]

set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk_in }];
set_property -dict { PACKAGE_PIN C2 IOSTANDARD LVCMOS33 } [get_ports { rstn_in }];

set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { dac_data }]; # IO 38
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { dac_cs }];   # IO 39
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { dac_ldac }]; # IO 40
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { dac_clk }];  # IO 41

set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports { adc_ab_clk }]; # IO 8
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { adc_ab_cnv }]; # IO 7
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { adc_a_data }]; # IO 37
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { adc_b_data }]; # IO 36

set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { adc_cd_clk }]; # IO 33
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports { adc_cd_cnv }]; # IO 32
set_property -dict { PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports { adc_c_data }]; # IO 35
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { adc_d_data }]; # IO 34

set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_col }];
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_crs }];
# set_property -dict { PACKAGE_PIN F16 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_mdc }];
# set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_mdio }];
set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_clk }];
set_property -dict { PACKAGE_PIN C16 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rstn }];
set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rx_clk }];
set_property -dict { PACKAGE_PIN G16 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rx_dv }];
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rxd[0] }];
set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rxd[1] }];
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rxd[2] }];
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rxd[3] }];
set_property -dict { PACKAGE_PIN C17 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_rx_er }];
set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_tx_clk }];
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_tx_en }];
set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_txd[0] }];
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_txd[1] }];
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_txd[2] }];
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_txd[3] }];

set_property -dict { PACKAGE_PIN A9  IOSTANDARD LVCMOS33 } [get_ports { usb_uart_rxd }];
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports { usb_uart_txd }];

set_property -dict { PACKAGE_PIN A8  IOSTANDARD LVCMOS33 } [get_ports { switches[0] }];
set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33 } [get_ports { switches[1] }];
set_property -dict { PACKAGE_PIN C10 IOSTANDARD LVCMOS33 } [get_ports { switches[2] }];
set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports { switches[3] }];

set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports { buttons[0] }];
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports { buttons[1] }];
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports { buttons[2] }];
set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports { buttons[3] }];

set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { leds[0] }];
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { leds[1] }];
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { leds[2] }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { leds[3] }];

set_property -dict { PACKAGE_PIN E1  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[0] }];
set_property -dict { PACKAGE_PIN F6  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[1] }];
set_property -dict { PACKAGE_PIN G6  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[2] }];
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[3] }];
set_property -dict { PACKAGE_PIN J4  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[4] }];
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[5] }];
set_property -dict { PACKAGE_PIN H4  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[6] }];
set_property -dict { PACKAGE_PIN J2  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[7] }];
set_property -dict { PACKAGE_PIN J3  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[8] }];
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[9] }];
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[10] }];
set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports { rgb_leds[11] }];
