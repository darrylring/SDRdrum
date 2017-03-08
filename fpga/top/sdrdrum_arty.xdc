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
