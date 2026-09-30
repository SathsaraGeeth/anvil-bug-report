`timescale 1ns/1ps
`default_nettype none

module anvil_tb;

logic clk;
logic rst_n;

`ifdef SEMANTIC
logic event_ack;
logic event_valid;
logic event_data;
logic obs_ack;
logic obs_valid;
logic [4:0] obs;

handshake_delay_semantic_bug dut (
    .clk_i             (clk),
    .rst_ni            (rst_n),
    ._port_event_ack   (event_ack),
    ._port_event_valid (event_valid),
    ._port_event_0     (event_data),
    ._port_obs_ack     (obs_ack),
    ._port_obs_valid   (obs_valid),
    ._port_obs_0       (obs)
);
`else
logic word_ack;
logic word_valid;
logic [7:0] word;
logic req_ack;
logic req_valid;
logic [7:0] req;
logic ack_ack;
logic ack_valid;
logic ack;

handshake_delay dut (
    .clk_i             (clk),
    .rst_ni            (rst_n),
    ._input_word_ack   (word_ack),
    ._input_word_valid (word_valid),
    ._input_word_0     (word),
    ._aes_req_ack      (req_ack),
    ._aes_req_valid    (req_valid),
    ._aes_req_0        (req),
    ._aes_ack_ack      (ack_ack),
    ._aes_ack_valid    (ack_valid),
    ._aes_ack_0        (ack)
);
`endif

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
`ifdef SEMANTIC
    event_valid = 1'b0;
    event_data = 1'b0;
    obs_ack = 1'b1;
`else
    word_valid = 1'b0;
    word = 8'hA5;
    req_ack = 1'b0;
    ack_valid = 1'b0;
    ack = 1'b1;
`endif

    #1 rst_n = 1'b0;
    repeat (2) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
`ifdef SEMANTIC
    @(negedge clk);
    event_valid = 1'b1;
    wait (event_ack);
    @(posedge clk);
    @(negedge clk);
    event_valid = 1'b0;
    wait (obs_valid);
    @(negedge clk);
    event_valid = 1'b1;
    wait (event_ack);
    $fatal(1, "accepted a second message while waiting");
`else
    word_valid = 1'b1;
    wait (word_ack);
    @(posedge clk);
    @(negedge clk);
    word_valid = 1'b0;
    wait (req_valid);
    assert (req == 8'hA5);

    @(negedge clk);
    req_ack = 1'b1;
    @(posedge clk);
    @(negedge clk);
    req_ack = 1'b0;

    word = 8'h5A;
    word_valid = 1'b1;
    repeat (2) @(posedge clk);
    #1;
    assert (!word_ack)
        else $fatal(1, "started the next message before acknowledgement returned low");
    @(negedge clk);
    word_valid = 1'b0;

    wait (ack_ack);
    ack_valid = 1'b1;
    @(posedge clk);
    @(negedge clk);
    ack_valid = 1'b0;

    wait (word_ack);
    word_valid = 1'b1;
    @(posedge clk);
    @(negedge clk);
    word_valid = 1'b0;
    wait (req_valid);
    assert (req == 8'h5A);
    $finish;
`endif
end

initial #1000 $fatal(1, "timeout");

endmodule: anvil_tb

`default_nettype wire
