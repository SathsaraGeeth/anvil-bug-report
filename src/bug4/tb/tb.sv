`timescale 1ps/1ps
`default_nettype none

module tb;

logic       clk;
logic       rst_n;
logic       msg_valid;
logic       aes_ack;
logic       msg_ready;
logic       aes_req;
logic [3:0] accepted;

handshake_delay dut (
    .i_clk      (clk),
    .i_rst_n    (rst_n),
    .i_msg_valid(msg_valid),
    .i_aes_ack  (aes_ack),
    .o_msg_ready(msg_ready),
    .o_aes_req  (aes_req),
    .o_accepted (accepted)
);

always #5 clk = ~clk;

initial begin
    clk       = 1'b0;
    rst_n     = 1'b0;
    msg_valid = 1'b0;
    aes_ack   = 1'b0;

    repeat (2) @(posedge clk);
    @(negedge clk);
    rst_n     = 1'b1;
    msg_valid = 1'b1;

    repeat (3) @(posedge clk);
    #1;
    assert (accepted == 2 && !msg_ready)
        else $fatal(1, "accepted input while waiting for acknowledgement");

    @(negedge clk);
    msg_valid = 1'b0;
    repeat (2) @(posedge clk);
    @(negedge clk);
    aes_ack   = 1'b1;
    msg_valid = 1'b1;
    repeat (5) @(posedge clk);
    #1;
    assert (accepted == 2 && !msg_ready)
        else $fatal(1, "started the next message before acknowledgement returned low");

    @(negedge clk);
    aes_ack   = 1'b0;
    msg_valid = 1'b0;
    repeat (2) @(posedge clk);
    @(negedge clk);
    msg_valid = 1'b1;
    repeat (3) @(posedge clk);
    #1;
    assert (accepted == 4 && !msg_ready)
        else $fatal(1, "did not request a halt for the second message");

    $finish;
end

endmodule: tb

`default_nettype wire
