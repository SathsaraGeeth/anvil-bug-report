module sby_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_write;
    (* anyseq *) logic [7:0] f_wdata;

    logic f_rvalid;
    logic [7:0] f_rdata;
    logic f_past_valid = 1'b0;

    cdc_payload dut(.i_wr_clk(f_clk),
                    .i_rd_clk(f_clk),
                    .i_rst_n(f_rst_n),
                    .i_write(f_write),
                    .i_wdata(f_wdata),
                    .o_rvalid(f_rvalid),
                    .o_rdata(f_rdata));

    always_ff @(posedge f_clk) begin
        if (!f_rst_n)
            f_past_valid <= 1'b0;
        else
            f_past_valid <= 1'b1;
    end

    initial
        assume (!f_rst_n);

    always_ff @(posedge f_clk) begin
        if (f_rst_n && f_past_valid && !f_rvalid)
            assert (f_rdata == '0);
    end

endmodule : sby_properties
