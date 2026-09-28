`timescale 1ps / 1ps

module properties;

    logic f_clk;
    logic f_rst_n;
    logic f_msg_valid;
    logic f_aes_ack;
    logic f_msg_ready;
    logic f_aes_req;
    logic [3:0] f_accepted;
    logic f_past_valid;

    always_ff @(posedge f_clk) begin
        if (!f_rst_n)
            f_past_valid <= 1'b0;
        else
            f_past_valid <= 1'b1;
    end

    handshake_delay dut(.i_clk(f_clk),
                        .i_rst_n(f_rst_n),
                        .i_msg_valid(f_msg_valid),
                        .i_aes_ack(f_aes_ack),
                        .o_msg_ready(f_msg_ready),
                        .o_aes_req(f_aes_req),
                        .o_accepted(f_accepted));

    property p_reset_before_past_valid;
        @(posedge f_clk) !f_past_valid |-> !f_rst_n;
    endproperty : p_reset_before_past_valid

    property p_reset_remains_deasserted;
        @(posedge f_clk) f_past_valid |-> f_rst_n;
    endproperty : p_reset_remains_deasserted

    property p_request_applies_backpressure;
        @(posedge f_clk) disable iff(!f_rst_n) f_past_valid && f_aes_req |->
            !f_msg_ready;
    endproperty : p_request_applies_backpressure

    property p_ack_eventually_asserts;
        @(posedge f_clk) disable iff(!f_rst_n) f_past_valid && f_aes_req |->
            s_eventually f_aes_ack;
    endproperty : p_ack_eventually_asserts

    property p_ack_eventually_deasserts;
        @(posedge f_clk) disable iff(!f_rst_n) f_past_valid && f_aes_ack |->
            s_eventually !f_aes_ack;
    endproperty : p_ack_eventually_deasserts

    property p_handshake_eventually_returns_idle;
        @(posedge f_clk) disable iff(!f_rst_n) f_past_valid && f_aes_req |->
            s_eventually(!f_aes_req && !f_aes_ack);
    endproperty : p_handshake_eventually_returns_idle

    assume property (p_reset_before_past_valid);
    assume property (p_reset_remains_deasserted);
    assume property (p_ack_eventually_asserts);
    assume property (p_ack_eventually_deasserts);

a_request_applies_backpressure:
    assert property (p_request_applies_backpressure);

a_handshake_eventually_returns_idle:
    assert property (p_handshake_eventually_returns_idle);

endmodule : properties
