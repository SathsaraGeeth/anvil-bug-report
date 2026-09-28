`timescale 1ns / 1ps

module properties;

    logic f_wr_clk;
    logic f_rd_clk;
    logic f_rst_n;
    logic f_write;
    logic [7:0] f_wdata;
    logic f_rvalid;
    logic [7:0] f_rdata;
    logic f_past_valid;

    always_ff @(posedge f_rd_clk) begin
        if (!f_rst_n)
            f_past_valid <= 1'b0;
        else
            f_past_valid <= 1'b1;
    end

    cdc_payload dut(.i_wr_clk(f_wr_clk),
                    .i_rd_clk(f_rd_clk),
                    .i_rst_n(f_rst_n),
                    .i_write(f_write),
                    .i_wdata(f_wdata),
                    .o_rvalid(f_rvalid),
                    .o_rdata(f_rdata));

    property p_reset_before_past_valid;
        @(posedge f_rd_clk) !f_past_valid |-> !f_rst_n;
    endproperty : p_reset_before_past_valid

    property p_invalid_payload_is_zero;
        @(posedge f_rd_clk) disable iff(!f_rst_n) 
            f_past_valid && !f_rvalid |-> (f_rdata == '0);
    endproperty : p_invalid_payload_is_zero

    assume property (p_reset_before_past_valid);

a_invalid_payload_is_zero:
    assert property (p_invalid_payload_is_zero);

endmodule : properties
