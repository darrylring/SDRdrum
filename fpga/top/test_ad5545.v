module test_ad5545 (

    // Clock and Reset
    input  wire       clk_in,
    input  wire       rstn_in,
    
    // DACs
    output wire       dac_clk,
    output wire       dac_data,
    output wire       dac_ldac,
    output wire       dac_cs
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

wire        stick_signal_ready;
reg  [31:0] stick_out_data;

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
    
    .cfg_data(13'h0D71),
    
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
    .signal_tready(stick_signal_ready)
);

generator stick_2_gen (
    .aclk(clk),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(stick_2_phase_ready),
    .phase_tvalid(stick_2_phase_valid),
    
    .signal_tdata(stick_2_signal_data),
    .signal_tvalid(stick_2_signal_valid),
    .signal_tready(stick_signal_ready)
);

ad5545 stick_dac_out (
    .clk(clk),
    .rstn(rstn),
    
    .data(stick_out_data),
    .ready(stick_signal_ready),
    .valid(stick_1_signal_valid & stick_2_signal_valid),
    
    .cs(dac_cs),
    .din(dac_data),
    .ldac(dac_ldac),
    .sclk(dac_clk)
);


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

endmodule
