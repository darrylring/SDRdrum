`timescale 1ns / 1ps

module ad5545
(
    input  wire        clk,
    input  wire        rstn,
    
    input  wire [31:0] data,
    input  wire        valid,
    output wire        ready,

    output wire        cs,
    output wire        din,
    output wire        ldac,
    output wire        sclk
);


localparam [2:0]
    STATE_IDLE       = 3'd0,
    STATE_WRITE_DAC1 = 3'd1,
    STATE_WRITE_DAC2 = 3'd2,
    STATE_LOAD       = 3'd3,
    STATE_WAIT       = 3'd4;

reg [2:0] state_reg, state_next;

reg [6:0] count_reg, count_next;

reg [35:0] data_reg, data_next;

reg ready_reg, ready_next;

reg cs_reg, cs_next;
reg din_reg, din_next;
reg ldac_reg, ldac_next;
reg sclk_reg, sclk_next;

reg sclk_enable;

assign ready = ready_reg;

assign cs = cs_reg;
assign din = din_reg;
assign ldac = ldac_reg;
assign sclk = sclk_reg;


always @* begin
    state_next = STATE_IDLE;
    
    cs_next   = cs_reg;
    din_next  = din_reg;
    ldac_next = ldac_reg;
    sclk_next = sclk_reg;
    
    count_next = count_reg;
    data_next = data_reg;
    
    ready_next = 1'b0;
    
    case (state_reg)
        STATE_IDLE: begin
            
            if (ready & valid) begin
                data_next = {2'b01, data[31:16], 2'b10, data[15:0]};
                ready_next = 1'b0;

                state_next = STATE_WRITE_DAC1;
            end else begin
                ready_next = 1'b1;
            end
        end
        STATE_WRITE_DAC1: begin
            state_next = STATE_WRITE_DAC1;

            count_next = count_reg + 1;

            sclk_next = count_reg[0];

            if (count_reg == 7'h02) begin
                cs_next = 1'b0;
            end

            if (count_reg >= 7'h02 && count_reg[0] == 1'b0) begin
                {din_next, data_next} = {data_reg, 1'b0};
            end

            if (count_reg == 7'h26) begin
                cs_next = 1'b1;

                count_next = 7'b0;
                state_next = STATE_WRITE_DAC2;
            end

        end
        STATE_WRITE_DAC2: begin
            state_next = STATE_WRITE_DAC2;

            count_next = count_reg + 1;

            sclk_next = count_reg[0];

            if (count_reg == 7'h02) begin
                cs_next = 1'b0;
            end

            if (count_reg >= 7'h04 && count_reg[0] == 1'b0) begin
                {din_next, data_next} = {data_reg, 1'b0};
            end

            if (count_reg == 7'h26) begin
                cs_next = 1'b1;

                count_next = 7'b0;
                state_next = STATE_LOAD;
            end
        end
        STATE_LOAD: begin
            state_next = STATE_LOAD;
            count_next = count_reg + 1;

            if (count_reg[0] == 1'b1) begin
                ldac_next = ~ldac_reg;  
            end

            if (count_reg[2] == 1'b1) begin
                state_next = STATE_WAIT;
                count_next = 7'b0;
            end

        end
        STATE_WAIT: begin
            state_next = STATE_WAIT;
            count_next = count_reg + 1;

            if (count_reg == 7'h0e) begin
                state_next = STATE_IDLE;
                count_next = 7'b0;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (~rstn) begin
        state_reg <= STATE_IDLE;
        
        data_reg <= 16'b0;
        ready_reg <= 1'b0;
        
        count_reg <= 7'b0;
        
        cs_reg   <= 1'b1;
        din_reg  <= 1'b0;
        ldac_reg <= 1'b1;
        sclk_reg <= 1'b0;
        
    end else begin
        state_reg <= state_next;
        
        data_reg <= data_next;
        count_reg <= count_next;
        
        ready_reg <= ready_next;
        
        cs_reg <= cs_next;
        din_reg <= din_next;
        ldac_reg <= ldac_next;
        sclk_reg <= sclk_next;
    end
end


endmodule
