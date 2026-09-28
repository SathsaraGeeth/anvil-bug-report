`timescale 1ns/1ps
`default_nettype none

module tb;

logic clk = 1'b0;
logic rst_n = 1'b0;
logic push = 1'b0;
logic pop = 1'b0;
logic [7:0] wdata = '0;
logic empty;
logic [7:0] rdata;

stale_fifo dut (
    .i_clk   (clk),
    .i_rst_n (rst_n),
    .i_push  (push),
    .i_pop   (pop),
    .i_wdata (wdata),
    .o_empty (empty),
    .o_rdata (rdata)
);

always #5 clk = ~clk;

initial begin
    repeat (2) @(posedge clk);
    rst_n = 1'b1;

    @(negedge clk);
    wdata = 8'hA5;
    push  = 1'b1;

    @(negedge clk);
    push = 1'b0;
    pop  = 1'b1;

    @(negedge clk);
    pop = 1'b0;

    @(posedge clk);
    assert (empty && rdata == '0)
        else $fatal(1, "empty FIFO exposed %h", rdata);
    $finish;
end

endmodule: tb

`default_nettype wire
