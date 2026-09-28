module csr_anvil_properties;

    localparam logic [2:0] CSR = 3'd1;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_pair_valid;
    (* anyseq *) logic [7:0] f_pair;
    (* anyseq *) logic f_result_ack;
    logic f_pair_ack;
    logic f_result_valid;
    logic [1:0] f_result;
    logic f_pending;
    logic [7:0] f_pending_pair;
    logic f_formal_valid = 1'b0;

    initial
        assume (!f_rst_n);

    csr_dual_issue dut(.clk_i(f_clk),
                       .rst_ni(f_rst_n),
                       ._port_pair_ack(f_pair_ack),
                       ._port_pair_valid(f_pair_valid),
                       ._port_pair_0(f_pair),
                       ._port_result_ack(f_result_ack),
                       ._port_result_valid(f_result_valid),
                       ._port_result_0(f_result));

    always @(posedge f_clk) begin
        f_formal_valid <= 1'b1;

        if (f_formal_valid)
            assume (f_rst_n);

        if (!f_rst_n) begin
            f_pending <= 1'b0;
            f_pending_pair <= '0;
        end else begin
            if (f_pair_valid && f_pair_ack) begin
                f_pending <= 1'b1;
                f_pending_pair <= f_pair;
            end
            if (f_pending && f_result_valid && f_result_ack) begin
                if (f_pending_pair[7] && f_pending_pair[6:4] == CSR)
                    assert (!f_result[0]);
                if (f_pending_pair[3] && f_pending_pair[2:0] == CSR)
                    assert (!f_result[0]);
                f_pending <= 1'b0;
            end
        end
    end
endmodule
