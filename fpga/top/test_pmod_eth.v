module test_pmod_eth (

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
    output wire       eth_phy_mdc,
    
    // ADCs
    output wire       adc_clk,
    input  wire       adc_data0,
    input  wire       adc_data1,
    output wire       adc_cs,

    output wire       adc2_clk,
    input  wire       adc2_data0,
    input  wire       adc2_data1,
    output wire       adc2_cs,
    
    // DACs
    output wire       dac_clk,
    output wire       dac_data,
    output wire       dac_ldac,
    output wire       dac_cs,
    
    output wire       dac2_clk,
    output wire       dac2_data,
    output wire       dac2_ldac,
    output wire       dac2_cs
);



//==============================================================================
// Clock Generator
//==============================================================================

wire clk;
wire rstn;
wire pmod_clk;

xlnx_clk_gen_pmod_eth clocks (
    .clk_in1(clk_in),
    .resetn(rstn_in),
    
    .axi_clk(clk),
    .eth_clk(eth_phy_clk),
    .pmod_clk(pmod_clk),
    
    .locked(rstn)
);


//==============================================================================
// Stick Signal Generation
//==============================================================================

wire        stick_1_phase_ready;
wire [23:0] stick_1_phase_data;
wire        stick_1_phase_valid;

wire        stick_1_signal_ready;
wire        stick_1_signal_valid;
wire [16:0] stick_1_signal_data;
reg  [15:0] stick_1_out_data;

wire        stick_2_phase_ready;
wire [23:0] stick_2_phase_data;
wire        stick_2_phase_valid;

wire        stick_2_signal_ready;
wire        stick_2_signal_valid;
wire [16:0] stick_2_signal_data;
reg  [15:0] stick_2_out_data;

axis_phase_generator #(
    .AXIS_TDATA_WIDTH(24),
    .PHASE_WIDTH(15)
) stick_1_phase (
    .aclk(clk),
    .aresetn(rstn),
    
    .cfg_data(13'h0EB8),
    
    .m_axis_tready(stick_1_phase_ready),
    .m_axis_tdata(stick_1_phase_data),
    .m_axis_tvalid(stick_1_phase_valid)
);

axis_phase_generator #(
    .AXIS_TDATA_WIDTH(24),
    .PHASE_WIDTH(15)
) stick_2_phase (
    .aclk(clk),
    .aresetn(rstn),
    
    .cfg_data(13'h1000),
    
    .m_axis_tready(stick_2_phase_ready),
    .m_axis_tdata(stick_2_phase_data),
    .m_axis_tvalid(stick_2_phase_valid)
);

generator stick_1_gen (
    .aclk(clk),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(stick_1_phase_ready),
    .phase_tvalid(stick_1_phase_valid),
    
    .signal_tdata(stick_1_signal_data),
    .signal_tvalid(stick_1_signal_valid),
    .signal_tready(stick_1_signal_ready)
);

generator stick_2_gen (
    .aclk(clk),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(stick_2_phase_ready),
    .phase_tvalid(stick_2_phase_valid),
    
    .signal_tdata(stick_2_signal_data),
    .signal_tvalid(stick_2_signal_valid),
    .signal_tready(stick_2_signal_ready)
);

pmodda3 stick_dac_out (
    .clk(clk),
    .rstn(rstn),
    
    .data(stick_1_out_data),
    .ready(stick_1_signal_ready),
    .valid(stick_1_signal_valid),
    
    .cs(dac_cs),
    .din(dac_data),
    .ldac(dac_ldac),
    .sclk(dac_clk)
);

pmodda3 stick_dac2_out (
    .clk(clk),
    .rstn(rstn),
    
    .data(stick_2_out_data),
    .ready(stick_2_signal_ready),
    .valid(stick_2_signal_valid),
    
    .cs(dac2_cs),
    .din(dac2_data),
    .ldac(dac2_ldac),
    .sclk(dac2_clk)
);

always @* begin
    if (stick_1_signal_data[16:0] == 17'h8000) begin
        stick_1_out_data = 16'hFFFF;
    end else begin
        stick_1_out_data = {~stick_1_signal_data[15], stick_1_signal_data[14:0]};
    end
    
    if (stick_2_signal_data[16:0] == 17'h8000) begin
        stick_2_out_data = 16'hFFFF;
    end else begin
        stick_2_out_data = {~stick_2_signal_data[15], stick_2_signal_data[14:0]};
    end
end


//==============================================================================
// Corner Signal DSP
//==============================================================================

wire corner_ab_ready;
wire corner_cd_ready;

wire [15:0] corner_a_data;
wire [15:0] corner_b_data;
wire [15:0] corner_c_data;
wire [15:0] corner_d_data;

wire [15:0] magnitude_1_a_data;
wire [15:0] magnitude_1_b_data;
wire [15:0] magnitude_1_c_data;
wire [15:0] magnitude_1_d_data;

wire magnitude_1_a_valid;
wire magnitude_1_b_valid;
wire magnitude_1_c_valid;
wire magnitude_1_d_valid;

wire [15:0] magnitude_2_a_data;
wire [15:0] magnitude_2_b_data;
wire [15:0] magnitude_2_c_data;
wire [15:0] magnitude_2_d_data;

wire magnitude_2_a_valid;
wire magnitude_2_b_valid;
wire magnitude_2_c_valid;
wire magnitude_2_d_valid;

pmodad1 corner_ab_adc_in ( 
    .fpga_clk_i(clk),
    .adc_clk_i(pmod_clk),
    .reset_n_i(rstn),
    
    .en_0_i(1'b1),
    .en_1_i(1'b1),        
    .data_rdy_o(corner_ab_ready),
    .data_0_o(corner_a_data),
    .data_1_o(corner_b_data),  
    
    .data_0_i(adc_data0),
    .data_1_i(adc_data1),
    .sclk_o(adc_clk),
    .cs_o(adc_cs)
);

pmodad1 corner_cd_adc_in ( 
    .fpga_clk_i(clk),
    .adc_clk_i(pmod_clk),
    .reset_n_i(rstn),
    
    .en_0_i(1'b1),
    .en_1_i(1'b1),        
    .data_rdy_o(corner_cd_ready),
    .data_0_o(corner_c_data),
    .data_1_o(corner_d_data),  
    
    .data_0_i(adc2_data0),
    .data_1_i(adc2_data1),
    .sclk_o(adc2_clk),
    .cs_o(adc2_cs)
);

channel corner_dsp_1_a (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_a_data[11]}}, corner_a_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_ab_ready),
    
    .magnitude_tdata(magnitude_1_a_data),
    .magnitude_tvalid(magnitude_1_a_valid)
);


channel corner_dsp_1_b (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_b_data[11]}}, corner_b_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_ab_ready),
    
    .magnitude_tdata(magnitude_1_b_data),
    .magnitude_tvalid(magnitude_1_b_valid)
);


channel corner_dsp_1_c (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_c_data[11]}}, corner_c_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_cd_ready),
    
    .magnitude_tdata(magnitude_1_c_data),
    .magnitude_tvalid(magnitude_1_c_valid)
);


channel corner_dsp_1_d (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_d_data[11]}}, corner_d_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_cd_ready),
    
    .magnitude_tdata(magnitude_1_d_data),
    .magnitude_tvalid(magnitude_1_d_valid)
);


channel corner_dsp_2_a (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_a_data[11]}}, corner_a_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_ab_ready),
    
    .magnitude_tdata(magnitude_2_a_data),
    .magnitude_tvalid(magnitude_2_a_valid)
);


channel corner_dsp_2_b (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_b_data[11]}}, corner_b_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_ab_ready),
    
    .magnitude_tdata(magnitude_2_b_data),
    .magnitude_tvalid(magnitude_2_b_valid)
);


channel corner_dsp_2_c (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_c_data[11]}}, corner_c_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_cd_ready),
    
    .magnitude_tdata(magnitude_2_c_data),
    .magnitude_tvalid(magnitude_2_c_valid)
);


channel corner_dsp_2_d (
    .aclk(clk),
    .aresetn(rstn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_d_data[11]}}, corner_d_data[10:0], 4'b0}),
    .samples_tready(),
    .samples_tvalid(corner_cd_ready),
    
    .magnitude_tdata(magnitude_2_d_data),
    .magnitude_tvalid(magnitude_2_d_valid)
);



//==============================================================================
// Ethernet
//==============================================================================


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


framer ethernet_framer (
    .aclk(clk),
    .aresetn(rstn),
    
    .s_axis_tdata({magnitude_1_a_data, magnitude_1_b_data, magnitude_1_c_data, magnitude_1_d_data}),
    .s_axis_tvalid(magnitude_1_a_valid),
    .s_axis_tready(),
    
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


endmodule
