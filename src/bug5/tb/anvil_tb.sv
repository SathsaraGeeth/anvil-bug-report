`timescale 1ns/1ps
`default_nettype none

module anvil_tb;

logic clk;
logic rst_n;
logic pair_ack;
logic pair_valid;
logic [7:0] pair;
logic result_ack;
logic result_valid;
logic [1:0] result;

csr_dual_issue dut (
    .clk_i              (clk),
    .rst_ni             (rst_n),
    ._port_pair_ack     (pair_ack),
    ._port_pair_valid   (pair_valid),
    ._port_pair_0       (pair),
    ._port_result_ack   (result_ack),
    ._port_result_valid (result_valid),
    ._port_result_0     (result)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    pair_valid = 1'b0;
    pair = '0;
    result_ack = 1'b0;

    #1 rst_n = 1'b0;
    repeat (2) @(posedge clk);

    @(negedge clk);
    rst_n = 1'b1;
    pair = {1'b1, 3'd1, 1'b1, 3'd2};
    pair_valid = 1'b1;

    wait (pair_ack);
    @(posedge clk);
    @(negedge clk) pair_valid = 1'b0;

    wait (result_valid);
    assert (!result[0])
        else $fatal(1, "CSR dual-issued");

    $finish;
end

initial #1000 $fatal(1, "timeout");

endmodule: anvil_tb

`default_nettype wire
