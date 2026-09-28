module sby_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_push;
    (* anyseq *) logic f_pop;
    (* anyseq *) logic [7:0] f_wdata;

    logic f_empty;
    logic [7:0] f_rdata;
    logic f_past_valid = 1'b0;

    stale_fifo dut(.i_clk(f_clk),
                   .i_rst_n(f_rst_n),
                   .i_push(f_push),
                   .i_pop(f_pop),
                   .i_wdata(f_wdata),
                   .o_empty(f_empty),
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
        if (f_rst_n && f_past_valid && f_empty)
            assert (f_rdata == '0);
    end

endmodule : sby_properties
