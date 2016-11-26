set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk_in }];
set_property -dict { PACKAGE_PIN C2 IOSTANDARD LVCMOS33 } [get_ports { rstn_in }];

set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports { dac_data }]; # IO 26
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { dac_cs }];   # IO 27
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { dac_ldac }]; # IO 28
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { dac_clk }];  # IO 29

set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { adc_ab_clk }]; # IO 12
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { adc_ab_cnv }]; # IO 13
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { adc_a_data }]; # IO 11
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { adc_b_data }]; # IO 10

set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { adc_cd_clk }]; # IO 0
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { adc_cd_cnv }]; # IO 2
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { adc_c_data }]; # IO 3
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { adc_d_data }]; # IO 1

set_property -dict { PACKAGE_PIN D17 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_col }];
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_crs }];
set_property -dict { PACKAGE_PIN F16 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_mdc }];
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { eth_phy_mdio }];
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
