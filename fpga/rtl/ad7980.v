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

module ad7980
(
    input  wire        clk,
    input  wire        rstn,
    
    output wire [15:0] data,
    output wire        valid,
    input  wire        ready,

    input  wire        sdo,
    output wire        cnv,
    output wire        sclk
);


localparam [1:0]
    STATE_IDLE    = 3'd0,
    STATE_CONVERT = 3'd1,
    STATE_READ    = 3'd2,
    STATE_WAIT    = 3'd3;

reg [1:0] state_reg, state_next;

reg [6:0] count_reg, count_next;

reg [15:0] data_reg, data_next;

reg valid_reg, valid_next;

reg cnv_reg, cnv_next;
reg sclk_reg, sclk_next;

assign valid = valid_reg;
assign data = data_reg;

assign cnv = cnv_reg;
assign sclk = sclk_reg;


always @* begin
    state_next = STATE_IDLE;
    
    cnv_next   = cnv_reg;
    sclk_next = sclk_reg;
    
    count_next = count_reg;
    data_next = data_reg;
    valid_next = valid_reg;
    
    case (state_reg)
        STATE_IDLE: begin
            
            if (ready) begin
                cnv_next = 1'b1;

                state_next = STATE_CONVERT;
            end
        end
        STATE_CONVERT: begin
            state_next = STATE_CONVERT;

            count_next = count_reg + 1;


            if (count_reg == 7'h46) begin
                cnv_next = 1'b0;

                sclk_next = 1'b1;
                count_next = 7'b1;
                state_next = STATE_READ;
            end

        end
        STATE_READ: begin
            state_next = STATE_READ;

            count_next = count_reg + 1;

            sclk_next = count_reg[0];

            if (sclk_reg == 1'b0) begin
                data_next = {data_reg[14:0], sdo};
            end

            if (count_reg == 7'h21) begin
                count_next = 7'b0;
                valid_next = 1'b1;
                state_next = STATE_IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (~rstn) begin
        state_reg <= STATE_IDLE;
        
        data_reg <= 16'b0;
        valid_reg <= 1'b0;
        
        count_reg <= 7'b0;
        
        cnv_reg  <= 1'b0;
        sclk_reg <= 1'b1;
        
    end else begin
        state_reg <= state_next;
        
        data_reg <= data_next;
        valid_reg <= valid_next;

        count_reg <= count_next;
    
        cnv_reg  <= cnv_next;
        sclk_reg <= sclk_next;
    end
end


endmodule
