set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk_in }];
set_property -dict { PACKAGE_PIN C2 IOSTANDARD LVCMOS33 } [get_ports { rstn_in }];

set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports { dac_data }]; # IO 26
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { dac_cs }];   # IO 27
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { dac_ldac }]; # IO 28
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { dac_clk }];  # IO 29
