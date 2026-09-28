module handshake_anvil_fixed_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_word_valid;
    (* anyseq *) logic [7:0] f_word;
    (* anyseq *) logic f_req_ack;
    (* anyseq *) logic f_ack_valid;
    (* anyseq *) logic f_ack;
    logic f_word_ack;
    logic f_req_valid;
    logic [7:0] f_req;
    logic f_ack_ack;
    logic f_past_req_valid;
    logic [7:0] f_past_req;
    logic f_formal_valid = 1'b0;

    initial
        assume (!f_rst_n);

    handshake_delay dut(.clk_i(f_clk),
                        .rst_ni(f_rst_n),
                        ._input_word_ack(f_word_ack),
                        ._input_word_valid(f_word_valid),
                        ._input_word_0(f_word),
                        ._aes_req_ack(f_req_ack),
                        ._aes_req_valid(f_req_valid),
                        ._aes_req_0(f_req),
                        ._aes_ack_ack(f_ack_ack),
                        ._aes_ack_valid(f_ack_valid),
                        ._aes_ack_0(f_ack));

    always @(posedge f_clk) begin
        f_formal_valid <= 1'b1;

        if (f_formal_valid)
            assume (f_rst_n);

        if (!f_rst_n) begin
            f_past_req_valid <= 1'b0;
            f_past_req <= '0;
        end else begin
            if (f_past_req_valid && !f_req_ack) begin
                assert (f_req_valid);
                assert (f_req == f_past_req);
            end
            f_past_req_valid <= f_req_valid && !f_req_ack;
            f_past_req <= f_req;
        end
    end
endmodule : handshake_anvil_fixed_properties

module handshake_anvil_semantic_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_event_valid;
    (* anyseq *) logic f_event_data;
    (* anyseq *) logic f_obs_ack;
    logic f_event_ack;
    logic f_obs_valid;
    logic [4:0] f_obs;
    logic f_waiting;
    logic f_formal_valid = 1'b0;

    initial
        assume (!f_rst_n);

    handshake_delay_semantic_bug dut(.clk_i(f_clk),
                                     .rst_ni(f_rst_n),
                                     ._port_event_ack(f_event_ack),
                                     ._port_event_valid(f_event_valid),
                                     ._port_event_0(f_event_data),
                                     ._port_obs_ack(f_obs_ack),
                                     ._port_obs_valid(f_obs_valid),
                                     ._port_obs_0(f_obs));

    always @(posedge f_clk) begin
        f_formal_valid <= 1'b1;

        if (f_formal_valid)
            assume (f_rst_n);

        if (!f_rst_n) begin
            f_waiting <= 1'b0;
        end else if (f_event_valid && f_event_ack) begin
            if (!f_event_data) begin
                assert (!f_waiting);
                f_waiting <= 1'b1;
            end else begin
                f_waiting <= 1'b0;
            end
        end
    end
endmodule : handshake_anvil_semantic_properties
