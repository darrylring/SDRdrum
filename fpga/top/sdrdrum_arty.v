`timescale 1ns / 1ps

module sdrdrum_arty (

    // Clock and Reset
    input  wire        clk_in,
    input  wire        rstn_in,
    
    // DACs
    output wire        dac_clk,
    output wire        dac_data,
    output wire        dac_ldac,
    output wire        dac_cs,
    
    // ADCs
    output wire        adc_ab_clk,
    output wire        adc_ab_cnv,
    output wire        adc_cd_clk,
    output wire        adc_cd_cnv,
    input  wire        adc_a_data,
    input  wire        adc_b_data,
    input  wire        adc_c_data,
    input  wire        adc_d_data,
    
    // Ethernet
    input  wire [3:0]  eth_phy_rxd,
    input  wire        eth_phy_rx_clk,
    input  wire        eth_phy_rx_dv,
    input  wire        eth_phy_rx_er,
    
    output wire [3:0]  eth_phy_txd,
    input  wire        eth_phy_tx_clk,
    output wire        eth_phy_tx_en,
    
    output wire        eth_phy_clk,
    output wire        eth_phy_rstn,
    
    input  wire        eth_phy_crs,
    input  wire        eth_phy_col,
    
    // UART
    input  wire        usb_uart_rxd,
    output wire        usb_uart_txd,
    
    // IO
    input  wire  [3:0] switches,
    input  wire  [3:0] buttons,
    output wire [11:0] rgb_leds,
    output wire  [3:0] leds
);


//==============================================================================
// Control and Status Signals
//==============================================================================
wire [15:0] control;
wire [23:0] status;

wire [12:0] freq_1;
wire [12:0] freq_2;


//==============================================================================
// Clock Generator
//==============================================================================

wire resetn;
wire clk;
wire dcm_locked;

xlnx_clk_gen_pmod_eth clocks (
    .clk_in1(clk_in),
    .resetn(rstn_in),
    
    .axi_clk(clk),
    .eth_clk(eth_phy_clk),
    
    .locked(dcm_locked)
);

//==============================================================================
// Stick Signal Generation
//==============================================================================

wire        stick_1_phase_ready;
wire [23:0] stick_1_phase_data;
wire        stick_1_phase_valid;

wire        stick_signal_ready;

wire        stick_1_signal_valid;
wire [16:0] stick_1_signal_data;

wire        stick_2_phase_ready;
wire [23:0] stick_2_phase_data;
wire        stick_2_phase_valid;

wire        stick_2_signal_valid;
wire [16:0] stick_2_signal_data;

axis_phase_generator #(
    .AXIS_TDATA_WIDTH(24),
    .PHASE_WIDTH(15)
) stick_1_phase (
    .aclk(clk),
    .aresetn(resetn),
    
    .cfg_data(freq_1),
    
    .m_axis_tready(stick_1_phase_ready),
    .m_axis_tdata(stick_1_phase_data),
    .m_axis_tvalid(stick_1_phase_valid)
);

axis_phase_generator #(
    .AXIS_TDATA_WIDTH(24),
    .PHASE_WIDTH(15)
) stick_2_phase (
    .aclk(clk),
    .aresetn(resetn),
    
    .cfg_data(freq_2),
    
    .m_axis_tready(stick_2_phase_ready),
    .m_axis_tdata(stick_2_phase_data),
    .m_axis_tvalid(stick_2_phase_valid)
);

generator stick_1_gen (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(stick_1_phase_ready),
    .phase_tvalid(stick_1_phase_valid),
    
    .signal_tdata(stick_1_signal_data),
    .signal_tvalid(stick_1_signal_valid),
    .signal_tready(stick_signal_ready)
);

generator stick_2_gen (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(stick_2_phase_ready),
    .phase_tvalid(stick_2_phase_valid),
    
    .signal_tdata(stick_2_signal_data),
    .signal_tvalid(stick_2_signal_valid),
    .signal_tready(stick_signal_ready)
);

reg  [31:0] stick_out_data;

always @* begin
    if (stick_1_signal_data[16:0] == 17'h8000) begin
        stick_out_data[31:16] = 16'hFFFF;
    end else begin
        stick_out_data[31:16] = {~stick_1_signal_data[15], stick_1_signal_data[14:0]};
    end
    
    if (stick_2_signal_data[16:0] == 17'h8000) begin
        stick_out_data[15:0] = 16'hFFFF;
    end else begin
        stick_out_data[15:0] = {~stick_2_signal_data[15], stick_2_signal_data[14:0]};
    end
end

ad5545 stick_dac_out (
    .clk(clk),
    .rstn(resetn),
    
    .data(stick_out_data),
    .ready(stick_signal_ready),
    .valid(stick_1_signal_valid & stick_2_signal_valid),
    
    .cs(dac_cs),
    .din(dac_data),
    .ldac(dac_ldac),
    .sclk(dac_clk)
);


//==============================================================================
// Corner Signal DSP
//==============================================================================

wire [15:0] corner_a_data;
wire [15:0] corner_b_data;
wire [15:0] corner_c_data;
wire [15:0] corner_d_data;

wire corner_a_valid;
wire corner_b_valid;
wire corner_c_valid;
wire corner_d_valid;

wire dsp_a_ready;
wire dsp_b_ready;
wire dsp_c_ready;
wire dsp_d_ready;

wire [31:0] magnitude_1_a_data;
wire [31:0] magnitude_1_b_data;
wire [31:0] magnitude_1_c_data;
wire [31:0] magnitude_1_d_data;
wire [31:0] magnitude_2_a_data;
wire [31:0] magnitude_2_b_data;
wire [31:0] magnitude_2_c_data;
wire [31:0] magnitude_2_d_data;

wire magnitude_1_a_valid;
wire magnitude_1_b_valid;
wire magnitude_1_c_valid;
wire magnitude_1_d_valid;
wire magnitude_2_a_valid;
wire magnitude_2_b_valid;
wire magnitude_2_c_valid;
wire magnitude_2_d_valid;

ad7980 corner_a_adc_in (
    .clk(clk),
    .rstn(resetn),
    
    .data(corner_a_data),
    .ready(dsp_a_ready),
    .valid(corner_a_valid),
    
    .sdo(adc_a_data),
    .cnv(adc_ab_cnv),
    .sclk(adc_ab_clk)
);

ad7980 corner_b_adc_in (
    .clk(clk),
    .rstn(resetn),
    
    .data(corner_b_data),
    .ready(dsp_b_ready),
    .valid(corner_b_valid),
    
    .sdo(adc_b_data),
    .cnv(),
    .sclk()
);

ad7980 corner_c_adc_in (
    .clk(clk),
    .rstn(resetn),
    
    .data(corner_c_data),
    .ready(dsp_c_ready),
    .valid(corner_c_valid),
    
    .sdo(adc_c_data),
    .cnv(adc_cd_cnv),
    .sclk(adc_cd_clk)
);

ad7980 corner_d_adc_in (
    .clk(clk),
    .rstn(resetn),
    
    .data(corner_d_data),
    .ready(dsp_d_ready),
    .valid(corner_d_valid),
    
    .sdo(adc_d_data),
    .cnv(),
    .sclk()
);

channel corner_dsp_1_a (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_a_data[15]}}, corner_a_data[14:0]}),
    .samples_tready(dsp_a_ready),
    .samples_tvalid(corner_a_valid),
    
    .magnitude_tdata(magnitude_1_a_data),
    .magnitude_tvalid(magnitude_1_a_valid)
);

channel corner_dsp_1_b (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_b_data[15]}}, corner_b_data[14:0]}),
    .samples_tready(dsp_b_ready),
    .samples_tvalid(corner_b_valid),
    
    .magnitude_tdata(magnitude_1_b_data),
    .magnitude_tvalid(magnitude_1_b_valid)
);

channel corner_dsp_1_c (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_c_data[15]}}, corner_c_data[14:0]}),
    .samples_tready(dsp_c_ready),
    .samples_tvalid(corner_c_valid),
    
    .magnitude_tdata(magnitude_1_c_data),
    .magnitude_tvalid(magnitude_1_c_valid)
);

channel corner_dsp_1_d (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_d_data[15]}}, corner_d_data[14:0]}),
    .samples_tready(dsp_d_ready),
    .samples_tvalid(corner_d_valid),
    
    .magnitude_tdata(magnitude_1_d_data),
    .magnitude_tvalid(magnitude_1_d_valid)
);

channel corner_dsp_2_a (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_a_data[15]}}, corner_a_data[14:0]}),
    .samples_tready(),
    .samples_tvalid(corner_a_valid),
    
    .magnitude_tdata(magnitude_2_a_data),
    .magnitude_tvalid(magnitude_2_a_valid)
);

channel corner_dsp_2_b (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_b_data[15]}}, corner_b_data[14:0]}),
    .samples_tready(),
    .samples_tvalid(corner_b_valid),
    
    .magnitude_tdata(magnitude_2_b_data),
    .magnitude_tvalid(magnitude_2_b_valid)
);

channel corner_dsp_2_c (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_c_data[15]}}, corner_c_data[14:0]}),
    .samples_tready(),
    .samples_tvalid(corner_c_valid),
    
    .magnitude_tdata(magnitude_2_c_data),
    .magnitude_tvalid(magnitude_2_c_valid)
);

channel corner_dsp_2_d (
    .aclk(clk),
    .aresetn(resetn),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata({{7{1'b0}}, {2{~corner_d_data[15]}}, corner_d_data[14:0]}),
    .samples_tready(),
    .samples_tvalid(corner_d_valid),
    
    .magnitude_tdata(magnitude_2_d_data),
    .magnitude_tvalid(magnitude_2_d_valid)
);

//==============================================================================
// Ethernet Framer
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
    .aresetn(resetn),
    
    .s_axis_tdata({magnitude_2_d_data, magnitude_2_c_data, magnitude_2_b_data, magnitude_2_a_data, magnitude_1_d_data, magnitude_1_c_data, magnitude_1_b_data, magnitude_1_a_data}),
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


//==============================================================================
// MicroBlaze
//==============================================================================

controller controller (
    .clk(clk),
    .dcm_locked(dcm_locked),
    .ext_reset(rstn_in),
    .resetn(resetn),
    
    .eth_mac_axi_awaddr({19'b0, eth_mac_axi_awaddr}),
    .eth_mac_axi_awvalid(eth_mac_axi_awvalid),
    .eth_mac_axi_awready(eth_mac_axi_awready),
    .eth_mac_axi_awprot(3'b0),
    
    .eth_mac_axi_wdata(eth_mac_axi_wdata),
    .eth_mac_axi_wstrb(eth_mac_axi_wstrb),
    .eth_mac_axi_wvalid(eth_mac_axi_wvalid),
    .eth_mac_axi_wready(eth_mac_axi_wready),
    
    .eth_mac_axi_bresp(eth_mac_axi_bresp),
    .eth_mac_axi_bvalid(eth_mac_axi_bvalid),
    .eth_mac_axi_bready(eth_mac_axi_bready),
    
    .eth_mac_axi_araddr({19'b0, eth_mac_axi_araddr}),
    .eth_mac_axi_arvalid(eth_mac_axi_arvalid),
    .eth_mac_axi_arready(eth_mac_axi_arready),
    .eth_mac_axi_arprot(3'b0),
    
    .eth_mac_axi_rdata(eth_mac_axi_rdata),
    .eth_mac_axi_rresp(eth_mac_axi_rresp),
    .eth_mac_axi_rvalid(eth_mac_axi_rvalid),
    .eth_mac_axi_rready(eth_mac_axi_rready),

    .eth_mii_col(eth_phy_col),
    .eth_mii_crs(eth_phy_crs),
    .eth_mii_rst_n(eth_phy_rstn),
    .eth_mii_rx_clk(eth_phy_rx_clk),
    .eth_mii_rx_dv(eth_phy_rx_dv),
    .eth_mii_rx_er(eth_phy_rx_er),
    .eth_mii_rxd(eth_phy_rxd),
    .eth_mii_tx_clk(eth_phy_tx_clk),
    .eth_mii_tx_en(eth_phy_tx_en),
    .eth_mii_txd(eth_phy_txd),
    
    .usb_uart_rxd(usb_uart_rxd),
    .usb_uart_txd(usb_uart_txd),
    
    .switches(switches),
    .buttons(buttons),
    
    .leds(leds),
    .rgb_leds(rgb_leds),
    
    .control(control),
    .status(status),
    
    .freq_1_tri_o(freq_1),
    .freq_2_tri_o(freq_2)
);

endmodule
