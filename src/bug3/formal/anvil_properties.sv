module cdc_anvil_fixed_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_write_valid;
    (* anyseq *) logic [7:0] f_write_data;
    (* anyseq *) logic f_read_ack;
    logic f_write_ack;
    logic f_read_valid;
    logic [7:0] f_read_data;
    logic f_past_valid;
    logic [7:0] f_past_data;
    logic f_formal_valid = 1'b0;

    initial
        assume (!f_rst_n);

    invalid_cdc_payload dut(.clk_i(f_clk),
                            .rst_ni(f_rst_n),
                            ._port_write_ack(f_write_ack),
                            ._port_write_valid(f_write_valid),
                            ._port_write_0(f_write_data),
                            ._port_read_ack(f_read_ack),
                            ._port_read_valid(f_read_valid),
                            ._port_read_0(f_read_data));

    always @(posedge f_clk) begin
        f_formal_valid <= 1'b1;

        if (f_formal_valid)
            assume (f_rst_n);

        if (!f_rst_n) begin
            f_past_valid <= 1'b0;
            f_past_data <= '0;
        end else begin
            if (f_past_valid && !f_read_ack) begin
                assert (f_read_valid);
                assert (f_read_data == f_past_data);
            end
            f_past_valid <= f_read_valid && !f_read_ack;
            f_past_data <= f_read_data;
        end
    end
endmodule

module cdc_anvil_semantic_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_write_valid;
    (* anyseq *) logic [7:0] f_write_data;
    (* anyseq *) logic f_read_ack;
    logic f_write_ack;
    logic f_read_valid;
    logic [8:0] f_read_data;
    logic f_past_valid = 1'b0;

    initial
        assume (!f_rst_n);

    invalid_cdc_payload_semantic_bug dut(.clk_i(f_clk),
                                         .rst_ni(f_rst_n),
                                         ._port_write_ack(f_write_ack),
                                         ._port_write_valid(f_write_valid),
                                         ._port_write_0(f_write_data),
                                         ._port_read_ack(f_read_ack),
                                         ._port_read_valid(f_read_valid),
                                         ._port_read_0(f_read_data));

    always @(posedge f_clk) begin
        f_past_valid <= 1'b1;

        if (f_past_valid)
            assume (f_rst_n);

        if (f_rst_n && f_past_valid && f_read_valid)
            assert (f_read_data[8] || f_read_data[7:0] == '0);
    end
endmodule
