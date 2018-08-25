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


`timescale 1 ns / 1 ps

module axis_phase_generator #
(
  parameter integer AXIS_TDATA_WIDTH = 32,
  parameter integer PHASE_WIDTH = 30
)
(
  // System signals
  input  wire                        aclk,
  input  wire                        aresetn,

  input  wire [PHASE_WIDTH-1:0]      cfg_data,

  // Master side
  input  wire                        m_axis_tready,
  output wire [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
  output wire                        m_axis_tvalid
);

  reg [PHASE_WIDTH-1:0] int_cntr_reg = 0, int_cntr_next;
  reg int_enbl_reg = 1'b0, int_enbl_next;

  always @(posedge aclk)
  begin
    if(~aresetn)
    begin
      int_cntr_reg <= {(PHASE_WIDTH){1'b0}};
      int_enbl_reg <= 1'b0;
    end
    else
    begin
      int_cntr_reg <= int_cntr_next;
      int_enbl_reg <= int_enbl_next;
    end
  end

  always @*
  begin
    int_cntr_next = int_cntr_reg;
    int_enbl_next = int_enbl_reg;

    if(~int_enbl_reg)
    begin
      int_enbl_next = 1'b1;
    end

    if(int_enbl_reg & m_axis_tready)
    begin
      int_cntr_next = int_cntr_reg + cfg_data;
    end
  end

  assign m_axis_tdata = {{(AXIS_TDATA_WIDTH-PHASE_WIDTH){int_cntr_reg[PHASE_WIDTH-1]}}, int_cntr_reg};
  assign m_axis_tvalid = int_enbl_reg;

endmodule