////////////////////////////////////////////////////////////////////////////////
// 
//  Copyright (c) 2018, Darryl Ring.
// 
//  This program is free software: you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation, either version 3 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along with
//  this program; if not, see <https://www.gnu.org/licenses/>.
//
//  Additional permission under GNU GPL version 3 section 7:
//  If you modify this program, or any covered work, by linking or combining it
//  with independent modules provided by the FPGA vendor only (this permission
//  does not extend to any 3rd party modules, "soft cores" or macros) under
//  different license terms solely for the purpose of generating binary
//  "bitstream" files and/or simulating the code, the copyright holders of this
//  program give you the right to distribute the covered work without those
//  independent modules as long as the source code for them is available from
//  the FPGA vendor free of charge, and there is no dependence on any encrypted
//  modules for simulating of the combined code. This permission applies to you
//  if the distributed code contains all the components and scripts required to
//  completely simulate it with at least one of the Free Software programs.
//
////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module framer (
    // Clock and Reset
    input  wire        aclk,
    input  wire        aresetn,
    
    // Input data stream
    input  wire [255:0] s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,

    // Frame output
    output wire [31:0] m_axi_awaddr,
    output wire        m_axi_awvalid,
    input  wire        m_axi_awready,

    output wire [31:0] m_axi_wdata,
    output wire [3:0]  m_axi_wstrb,
    output wire        m_axi_wvalid,
    input  wire        m_axi_wready,

    input  wire [1:0]  m_axi_bresp,
    input  wire        m_axi_bvalid,
    output wire        m_axi_bready,

    output wire [31:0] m_axi_araddr,
    output wire        m_axi_arvalid,
    input  wire        m_axi_arready,

    input  wire [31:0] m_axi_rdata,
    input  wire [1:0]  m_axi_rresp,
    input  wire        m_axi_rvalid,
    output wire        m_axi_rready
);

localparam [2:0]
    STATE_INIT        = 3'd0,
    STATE_IDLE        = 3'd1,
    STATE_WRITE_FRAME = 3'd2,
    STATE_TX_FRAME    = 3'd3,
    STATE_WAIT_DONE   = 3'd4;

reg [255:0] data;
reg [255:0] data_next;

reg  [2:0] state;
reg  [2:0] state_next;

reg         tready_reg;
reg  [31:0] awaddr_reg;
reg         awvalid_reg;
reg  [31:0] wdata_reg;
reg         wvalid_reg;
reg  [31:0] araddr_reg;
reg         arvalid_reg;
reg         rready_reg;

reg         tready_next;
reg  [31:0] awaddr_next; 
reg         awvalid_next;
reg  [31:0] wdata_next;
reg         wvalid_next;
reg  [31:0] araddr_next;
reg         arvalid_next;
reg         rready_next;


always @* begin
    state_next = STATE_IDLE;
    
    data_next = data;

    tready_next = tready_reg;
    
    awaddr_next = awaddr_reg;
    awvalid_next = awvalid_reg;
    
    wdata_next = wdata_reg;
    wvalid_next = wvalid_reg;
    
    araddr_next = araddr_reg;
    arvalid_next = arvalid_reg;
    
    rready_next = rready_reg;
    
    case (state)
        STATE_INIT: begin
            awaddr_next = 32'h40E0_07f4;
            wdata_next = 32'h0062;
            
            if (m_axi_awready) begin
                if (m_axi_awvalid) begin
                    awvalid_next = 1'b0;
                    wvalid_next = 1'b1;
                end
            end else begin
                if (!m_axi_wvalid) awvalid_next = 1'b1;
            end
            
            if (m_axi_wready) begin
                if (m_axi_wvalid) begin
                    awaddr_next = 32'h40E0_0000;
                    awvalid_next = 1'b0;
                    wvalid_next = 1'b0;
                    wdata_next = 32'b0;
                    state_next = STATE_IDLE;
                end else begin
                    state_next = STATE_INIT;
                end
            end else begin
                state_next = STATE_INIT;
            end
        end
        STATE_IDLE: begin
            if (s_axis_tready & s_axis_tvalid) begin
                data_next = s_axis_tdata;
                tready_next = 1'b0;
                awaddr_next = 32'h40E0_0000;
                awvalid_next = 1'b1;
                rready_next = 1'b0;
                state_next = STATE_WRITE_FRAME;
            end else begin
                tready_next = 1'b1;
                rready_next = 1'b1;

                state_next = STATE_IDLE;
            end
        end
        STATE_WRITE_FRAME: begin
            state_next = STATE_WRITE_FRAME;

            case (m_axi_awaddr[12:0])
                13'h00: wdata_next = 32'hFFFFFFFF;
                13'h04: wdata_next = 32'h1800FFFF;
                13'h08: wdata_next = 32'h6b4d023e;
                13'h0c: wdata_next = 32'h00450008;
                13'h10: wdata_next = 32'h00005400;
                13'h14: wdata_next = 32'h11ff0000;
                13'h18: wdata_next = 32'h0000eff0;
                13'h1c: wdata_next = 32'ha8c00000;
                13'h20: wdata_next = 32'hc507010a;
                13'h24: wdata_next = 32'h4000c507;
                13'h28: wdata_next = 32'h722f0000;
                13'h2c: wdata_next = 32'h6f696461;
                13'h30: wdata_next = 32'h6d757264;
                13'h34: wdata_next = 32'h692c0000;
                13'h38: wdata_next = 32'h69696969;
                13'h3c: wdata_next = 32'h00696969;
                
                13'h40: wdata_next = {data[23:16], data[31:24], 16'h0000};
                13'h44: wdata_next = {data[55:48], data[63:56], data[7:0], data[15:8]};
                13'h48: wdata_next = {data[87:80], data[95:88], data[39:32], data[47:40]};
                13'h4c: wdata_next = {data[119:112], data[127:120], data[71:64], data[79:72]};
                13'h50: wdata_next = {data[151:144], data[159:152], data[103:96], data[111:104]};
                
                13'h54: wdata_next = {data[183:176], data[191:184], data[135:128], data[143:136]};
                13'h58: wdata_next = {data[215:208], data[223:216], data[167:160], data[175:168]};
                13'h5c: wdata_next = {data[247:240], data[255:248], data[199:192], data[207:200]};
                13'h60: wdata_next = {16'h0000, data[231:224], data[239:232]};
            endcase

            if (m_axi_awready) begin
                if (m_axi_awvalid) begin
                    awvalid_next = 1'b0;
                    wvalid_next = 1'b1;
                end
            end
        
            if (m_axi_wready) begin
                if (m_axi_awaddr <= 32'h40E0_0060) begin
                    awaddr_next = awaddr_reg + 32'h4;
                    awvalid_next = 1'b1;
                    wvalid_next = 1'b0;
                end else begin
                    awaddr_next = 32'h40E0_07fc;
                    awvalid_next = 1'b1;
                    wvalid_next = 1'b0;
                    state_next = STATE_TX_FRAME;
                end
            end else begin
                wvalid_next = 1'b1;
            end
        end
        STATE_TX_FRAME: begin
            wdata_next = 32'h0009;
            
            if (m_axi_awready) begin
                if (m_axi_awvalid) begin
                    awvalid_next = 1'b0;
                    wvalid_next = 1'b1;
                end
            end else begin
                if (!m_axi_wvalid) awvalid_next = 1'b1;
            end
            
            if (m_axi_wready) begin
                if (m_axi_wvalid) begin
                    awaddr_next = 32'h40E0_0000;
                    awvalid_next = 1'b0;
                    wvalid_next = 1'b0;
                    wdata_next = 32'b0;
                    state_next = STATE_WAIT_DONE;
                end else begin
                    state_next = STATE_TX_FRAME;
                end
            end else begin
                state_next = STATE_TX_FRAME;
            end
        end
        STATE_WAIT_DONE: begin
            if (m_axi_rvalid) begin
                if (m_axi_rdata == 32'h08) begin
                    arvalid_next = 1'b0;
                    state_next = STATE_IDLE;
                end else begin
                    state_next = STATE_WAIT_DONE;
                end
            end else begin
                araddr_next = 32'h40E0_07fc;
                arvalid_next = 1'b1;
                rready_next = 1'b1;
                
                state_next = STATE_WAIT_DONE;
            end
        end
    endcase
end


always @(posedge aclk) begin
    if (~aresetn) begin
        state <= STATE_INIT;
        
        data <= 64'b0;
        
        tready_reg <= 1'b0;

        awaddr_reg <= 32'b0;
        awvalid_reg <= 1'b0;

        wdata_reg <= 32'b0;
        wvalid_reg <= 1'b0;

        araddr_reg <= 32'b0;
        arvalid_reg <= 1'b0;
        
        rready_reg <= 1'b0;
        
    end else begin
        state <= state_next;
        
        data <= data_next;

        tready_reg <= tready_next;
        
        awaddr_reg <= awaddr_next;
        awvalid_reg <= awvalid_next;

        wdata_reg <= wdata_next;
        wvalid_reg <= wvalid_next;

        araddr_reg <= araddr_next;
        arvalid_reg <= arvalid_next;

        rready_reg <= rready_next;
    end
end

assign s_axis_tready = tready_reg;

assign m_axi_awaddr = awaddr_reg;
assign m_axi_awvalid = awvalid_reg;
assign m_axi_wdata = wdata_reg;
assign m_axi_wvalid = wvalid_reg;
assign m_axi_wstrb = 4'hF;
assign m_axi_bready = 1'b1;
assign m_axi_araddr = araddr_reg; 
assign m_axi_arvalid = arvalid_reg;
assign m_axi_rready = rready_reg;

endmodule
