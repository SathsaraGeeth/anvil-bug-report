`timescale 1ns/1ps

module sby_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_msg_valid;
    (* anyseq *) logic f_aes_ack;

    logic f_msg_ready;
    logic f_aes_req;
    logic [3:0] f_accepted;
    logic f_past_valid = 1'b0;

    handshake_delay dut(.i_clk(f_clk),
                        .i_rst_n(f_rst_n),
                        .i_msg_valid(f_msg_valid),
                        .i_aes_ack(f_aes_ack),
                        .o_msg_ready(f_msg_ready),
                        .o_aes_req(f_aes_req),
                        .o_accepted(f_accepted));

    always_ff @(posedge f_clk) begin
        if (!f_rst_n)
            f_past_valid <= 1'b0;
        else
            f_past_valid <= 1'b1;
    end

    initial
        assume (!f_rst_n);

    always_ff @(posedge f_clk) begin
        if (f_past_valid)
            assume (f_rst_n);

        assume property (s_eventually(!f_aes_req || f_aes_ack));
        assume property (s_eventually !f_aes_ack);
    end

    always_ff @(posedge f_clk) begin
        if (f_rst_n && f_past_valid && f_aes_req)
            assert (!f_msg_ready);

        assert property (s_eventually(!f_aes_req && !f_aes_ack));
    end

endmodule : sby_properties
