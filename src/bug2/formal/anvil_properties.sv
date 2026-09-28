module stale_fifo_anvil_properties;

    (* gclk *) logic f_clk;
    (* anyseq *) logic f_rst_n;
    (* anyseq *) logic f_cmd_valid;
    (* anyseq *) logic [8:0] f_cmd;
    (* anyseq *) logic f_obs_ack;
    logic f_cmd_ack;
    logic f_obs_valid;
    logic [8:0] f_obs;
    logic f_past_valid = 1'b0;

    stale_fifo dut(.clk_i(f_clk),
                   .rst_ni(f_rst_n),
                   ._port_cmd_ack(f_cmd_ack),
                   ._port_cmd_valid(f_cmd_valid),
                   ._port_cmd_0(f_cmd),
                   ._port_obs_ack(f_obs_ack),
                   ._port_obs_valid(f_obs_valid),
                   ._port_obs_0(f_obs));

    always @(posedge f_clk) begin
        f_past_valid <= 1'b1;

        if (f_past_valid)
            assume (f_rst_n);

        if (f_rst_n && f_past_valid && f_obs_valid)
            assert (!f_obs[8] || f_obs[7:0] == '0);
    end

    initial
        assume (!f_rst_n);
endmodule
