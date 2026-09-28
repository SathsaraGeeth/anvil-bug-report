`timescale 1ns/1ps
`default_nettype none

module anvil_tb;

logic clk;
logic rst_n;
logic cmd_ack;
logic cmd_valid;
logic [8:0] cmd;
logic obs_ack;
logic obs_valid;
logic [8:0] obs;

stale_fifo dut (
    .clk_i           (clk),
    .rst_ni          (rst_n),
    ._port_cmd_ack   (cmd_ack),
    ._port_cmd_valid (cmd_valid),
    ._port_cmd_0     (cmd),
    ._port_obs_ack   (obs_ack),
    ._port_obs_valid (obs_valid),
    ._port_obs_0     (obs)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    cmd_valid = 1'b0;
    cmd = '0;
    obs_ack = 1'b0;

    #1 rst_n = 1'b0;
    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1'b1;

    @(negedge clk);
    cmd = {1'b0, 8'hA5};
    cmd_valid = 1'b1;
    wait (cmd_ack);
    @(posedge clk);
    @(negedge clk) cmd_valid = 1'b0;

    wait (obs_valid);
    @(negedge clk) obs_ack = 1'b1;
    @(negedge clk) obs_ack = 1'b0;

    @(negedge clk);
    cmd = {1'b1, 8'h00};
    cmd_valid = 1'b1;
    wait (cmd_ack);
    @(posedge clk);
    @(negedge clk) cmd_valid = 1'b0;

    wait (obs_valid);
    assert (!obs[8] || obs[7:0] == '0)
        else $fatal(1, "empty FIFO exposed stale data");
    $finish;
end

initial #1000 $fatal(1, "timeout");

endmodule: anvil_tb

`default_nettype wire
