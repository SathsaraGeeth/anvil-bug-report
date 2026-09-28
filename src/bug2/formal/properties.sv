`timescale 1ns / 1ps

module properties;

    logic f_clk;
    logic f_rst_n;
    logic f_push;
    logic f_pop;
    logic [7:0] f_wdata;
    logic f_empty;
    logic [7:0] f_rdata;
    logic f_past_valid;

    always_ff @(posedge f_clk) begin
        if (!f_rst_n)
            f_past_valid <= 1'b0;
        else
            f_past_valid <= 1'b1;
    end

    stale_fifo dut(.i_clk(f_clk),
                   .i_rst_n(f_rst_n),
                   .i_push(f_push),
                   .i_pop(f_pop),
                   .i_wdata(f_wdata),
                   .o_empty(f_empty),
                   .o_rdata(f_rdata));

    property p_reset_before_past_valid;
        @(posedge f_clk) !f_past_valid |-> !f_rst_n;
    endproperty : p_reset_before_past_valid

    property p_empty_data_is_zero;
        @(posedge f_clk) disable iff(!f_rst_n) f_past_valid && f_empty |->
            (f_rdata == '0);
    endproperty : p_empty_data_is_zero

    assume property (p_reset_before_past_valid);

a_empty_data_is_zero:
    assert property (p_empty_data_is_zero);

endmodule : properties
