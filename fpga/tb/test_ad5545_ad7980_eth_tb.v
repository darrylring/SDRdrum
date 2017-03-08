`timescale 1ns / 1ps

module test_ad5545_ad7980_eth_tb;

reg clk = 1'b0;
reg reset = 1'b0;

wire adc_clk;
wire adc_cnv;

test_ad5545_ad7980_eth_top dut (
    .clk_in(clk),
    .rstn_in(reset),
    
    .adc_clk(adc_clk),
    .adc_cnv(adc_cnv),
    .adc1_data(1'b1)
);

initial begin
    repeat (3) @(posedge clk);
    reset = 1'b1;
end

always begin
    #5 clk <= ~clk;
end

endmodule
