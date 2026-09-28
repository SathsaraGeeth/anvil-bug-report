`timescale 1ns/1ps
`default_nettype none

module anvil_tb;

logic clk;
logic rst_n;
logic entries_ack;
logic entries_valid;
logic [8191:0] entries;

queue_init dut (
    .clk_i               (clk),
    .rst_ni              (rst_n),
    ._port_entries_ack   (entries_ack),
    ._port_entries_valid (entries_valid),
    ._port_entries_0     (entries)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    entries_ack = 1'b1;

    #1 rst_n = 1'b0;
    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1'b1;
    wait (entries_valid);
    assert (entries == '0)
        else $fatal(1, "memory was not initialized");
    $finish;
end

initial #1000 $fatal(1, "timeout");

endmodule: anvil_tb

`default_nettype wire
