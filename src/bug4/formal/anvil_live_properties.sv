module handshake_anvil_live_properties;

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
    logic f_past_valid = 1'b0;

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

    initial
        assume (!f_rst_n);

    always_ff @(posedge f_clk) begin
        f_past_valid <= 1'b1;

        if (f_past_valid)
            assume (f_rst_n);

        assume property (s_eventually(!f_req_valid || f_req_ack));
        assume property (s_eventually(!f_ack_ack || f_ack_valid));
        assume property (s_eventually !f_ack_valid);
    end

    always_ff @(posedge f_clk)
        assert property (s_eventually(!f_req_valid && !f_ack_ack));
endmodule
