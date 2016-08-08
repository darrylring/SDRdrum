`timescale 1ns / 1ps

module test_eth_framer (

    // Clock and Reset
    input  wire       clk_in,
    input  wire       rstn_in,

    // Ethernet
    input  wire [3:0] eth_phy_rxd,
    input  wire       eth_phy_rx_clk,
    input  wire       eth_phy_rx_dv,
    input  wire       eth_phy_rx_er,
    
    output wire [3:0] eth_phy_txd,
    input  wire       eth_phy_tx_clk,
    output wire       eth_phy_tx_en,
    
    output wire       eth_phy_clk,
    output wire       eth_phy_rstn,
    
    input  wire       eth_phy_crs,
    input  wire       eth_phy_col,
    
    inout  wire       eth_phy_mdio,
    output wire       eth_phy_mdc
);


wire clk;
wire rstn;

wire [63:0] data;
wire valid;
wire ready;

wire [12:0] eth_mac_axi_awaddr;
wire eth_mac_axi_awvalid;
wire eth_mac_axi_awready;

wire [31:0] eth_mac_axi_wdata;
wire [3:0] eth_mac_axi_wstrb;
wire eth_mac_axi_wvalid;
wire eth_mac_axi_wready;

wire [1:0] eth_mac_axi_bresp;
wire eth_mac_axi_bvalid;
wire eth_mac_axi_bready;

wire [12:0] eth_mac_axi_araddr;
wire eth_mac_axi_arvalid;
wire eth_mac_axi_arready;

wire [31:0] eth_mac_axi_rdata;
wire [1:0] eth_mac_axi_rresp;
wire eth_mac_axi_rvalid;
wire eth_mac_axi_rready;

wire eth_phy_mdio_i;
wire eth_phy_mdio_o;
wire eth_phy_mdio_t;


xlnx_clk_gen_pmod_eth clocks (
    .clk_in1(clk_in),
    .resetn(rstn_in),
    
    .axi_clk(clk),
    .eth_clk(eth_phy_clk),
    .pmod_clk(),
    
    .locked(rstn)
);

axis_phase_generator #(
    .AXIS_TDATA_WIDTH(64),
    .PHASE_WIDTH(64)
) phase_gen (
    .aclk(clk),
    .aresetn(rstn),
     
    .cfg_data(64'h0001000100010001),
    
    .m_axis_tready(ready),
    .m_axis_tdata(data),
    .m_axis_tvalid(valid)
);

xlnx_ethernetlite ethernet_mac (
    .s_axi_aclk(clk),
    .s_axi_aresetn(rstn),
    
    .ip2intc_irpt(),
    
    .s_axi_awaddr(eth_mac_axi_awaddr),
    .s_axi_awvalid(eth_mac_axi_awvalid),
    .s_axi_awready(eth_mac_axi_awready),
    
    .s_axi_wdata(eth_mac_axi_wdata),
    .s_axi_wstrb(eth_mac_axi_wstrb),
    .s_axi_wvalid(eth_mac_axi_wvalid),
    .s_axi_wready(eth_mac_axi_wready),
    
    .s_axi_bresp(eth_mac_axi_bresp),
    .s_axi_bvalid(eth_mac_axi_bvalid),
    .s_axi_bready(eth_mac_axi_bready),
    
    .s_axi_araddr(eth_mac_axi_araddr),
    .s_axi_arvalid(eth_mac_axi_arvalid),
    .s_axi_arready(eth_mac_axi_arready),
    
    .s_axi_rdata(eth_mac_axi_rdata),
    .s_axi_rresp(eth_mac_axi_rresp),
    .s_axi_rvalid(eth_mac_axi_rvalid),
    .s_axi_rready(eth_mac_axi_rready),
    
    .phy_rx_data(eth_phy_rxd),
    .phy_rx_clk(eth_phy_rx_clk),
    .phy_dv(eth_phy_rx_dv),
    .phy_rx_er(eth_phy_rx_er),
    
    .phy_tx_data(eth_phy_txd),
    .phy_tx_clk(eth_phy_tx_clk),
    .phy_tx_en(eth_phy_tx_en),
    
    .phy_rst_n(eth_phy_rstn),
    .phy_crs(eth_phy_crs),
    .phy_col(eth_phy_col),
    
    .phy_mdio_i(eth_phy_mdio_i),
    .phy_mdio_o(eth_phy_mdio_o),
    .phy_mdio_t(eth_phy_mdio_t),
    .phy_mdc(eth_phy_mdc)
);


IOBUF eth_mdio_iobuf (
    .I(eth_phy_mdio_o),
    .O(eth_phy_mdio_i),
    .T(eth_phy_mdio_t),
    .IO(eth_phy_mdio)
);


framer my_framer (
    .aclk(clk),
    .aresetn(rstn),
    
    .s_axis_tdata(64'h0123456789abcdef),
    .s_axis_tvalid(valid),
    .s_axis_tready(ready),
    
    .m_axi_awaddr(eth_mac_axi_awaddr),
    .m_axi_awvalid(eth_mac_axi_awvalid),
    .m_axi_awready(eth_mac_axi_awready),
    
    .m_axi_wdata(eth_mac_axi_wdata),
    .m_axi_wstrb(eth_mac_axi_wstrb),
    .m_axi_wvalid(eth_mac_axi_wvalid),
    .m_axi_wready(eth_mac_axi_wready),
    
    .m_axi_bresp(eth_mac_axi_bresp),
    .m_axi_bvalid(eth_mac_axi_bvalid),
    .m_axi_bready(eth_mac_axi_bready),
    
    .m_axi_araddr(eth_mac_axi_araddr),
    .m_axi_arvalid(eth_mac_axi_arvalid),
    .m_axi_arready(eth_mac_axi_arready),
    
    .m_axi_rdata(eth_mac_axi_rdata),
    .m_axi_rresp(eth_mac_axi_rresp),
    .m_axi_rvalid(eth_mac_axi_rvalid),
    .m_axi_rready(eth_mac_axi_rready)
);

endmodule
