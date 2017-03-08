`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2016 11:15:36 AM
// Design Name: 
// Module Name: test_dsp_tb
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


module test_dsp_tb;

reg clk = 1'b1;
reg reset = 1'b0;

reg         stick_1_phase_ready = 1'b0;
wire [23:0] stick_1_phase_data;
wire        stick_1_phase_valid;

wire        stick_1_signal_ready;
wire [16:0] stick_1_signal_data;
wire        stick_1_signal_valid;

reg         stick_2_phase_ready = 1'b0;
wire [23:0] stick_2_phase_data;
wire        stick_2_phase_valid;

wire        stick_2_signal_ready;
wire [16:0] stick_2_signal_data;
wire        stick_2_signal_valid;

axis_phase_generator #(
    .AXIS_TDATA_WIDTH(24),
    .PHASE_WIDTH(15)
) stick_1_phase (
    .aclk(clk),
    .aresetn(reset),
    
    .cfg_data(13'h0EB8),
    
    .m_axis_tready(stick_1_phase_ready),
    .m_axis_tdata(stick_1_phase_data),
    .m_axis_tvalid(stick_1_phase_valid)
);

/*
axis_phase_generator #(
    .AXIS_TDATA_WIDTH(24),
    .PHASE_WIDTH(15)
) stick_2_phase (
    .aclk(clk),
    .aresetn(reset),
    
    .cfg_data(13'h1138),
    
    .m_axis_tready(stick_2_phase_ready),
    .m_axis_tdata(stick_2_phase_data),
    .m_axis_tvalid(stick_2_phase_valid)
);
*/

generator stick_1_gen (
    .aclk(clk),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_ready),
    
    .signal_tdata(stick_1_signal_data),
    .signal_tvalid(stick_1_signal_valid),
    .signal_tready(stick_1_signal_ready)
);

/*
generator stick_2_gen (
    .aclk(clk),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_ready),
    
    .signal_tdata(stick_2_signal_data),
    .signal_tvalid(stick_2_signal_valid),
    .signal_tready(stick_2_signal_ready)
);
*/

wire [23:0] magnitude_1_a_data;
wire magnitude_1_a_valid;

wire [23:0] magnitude_2_a_data;
wire magnitude_2_a_valid;

channel corner_dsp_1_a (
    .aclk(clk),
    .aresetn(reset),
    
    .phase_tdata(stick_1_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_1_phase_valid),
    
    .samples_tdata(stick_1_signal_data),
    .samples_tready(stick_1_signal_ready),
    .samples_tvalid(stick_1_signal_valid),
    
    .magnitude_tdata(magnitude_1_a_data),
    .magnitude_tvalid(magnitude_1_a_valid)
);
/*
channel corner_dsp_2_a (
    .aclk(clk),
    .aresetn(reset),
    
    .phase_tdata(stick_2_phase_data),
    .phase_tready(),
    .phase_tvalid(stick_2_phase_valid),
    
    .samples_tdata((stick_1_signal_data[15:1] + stick_2_signal_data[15:1] >> 1)),
    .samples_tready(stick_2_signal_ready),
    .samples_tvalid(stick_2_signal_valid),
    
    .magnitude_tdata(magnitude_2_a_data),
    .magnitude_tvalid(magnitude_2_a_valid)
);
*/

initial begin
    #5 clk <= ~clk;
    #5 clk <= ~clk;
    #5 clk <= ~clk;
    #5 clk <= ~clk; reset = 1'b1;
    #5 clk <= ~clk;
    #5 clk <= ~clk;
end

always begin
    #5 clk <= ~clk;
end

always begin
    #990 stick_1_phase_ready <= 1'b1; stick_2_phase_ready <= 1'b1;
    #10 stick_1_phase_ready <= 1'b0; stick_2_phase_ready <= 1'b0;
end


endmodule
