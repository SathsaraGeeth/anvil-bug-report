`timescale 1ns/1ps
`default_nettype none

module tb;

logic wr_clk = 1'b0;
logic rd_clk = 1'b0;
logic rst_n = 1'b0;
logic write = 1'b0;
logic [7:0] wdata = '0;
logic rvalid;
logic [7:0] rdata;

cdc_payload dut (
    .i_wr_clk (wr_clk),
    .i_rd_clk (rd_clk),
    .i_rst_n  (rst_n),
    .i_write  (write),
    .i_wdata  (wdata),
    .o_rvalid (rvalid),
    .o_rdata  (rdata)
);

always #3 wr_clk = ~wr_clk;
always #5 rd_clk = ~rd_clk;

initial begin
    repeat (2) @(posedge rd_clk);
    rst_n = 1'b1;

    @(negedge wr_clk);
    wdata = 8'hC3;
    write = 1'b1;

    @(negedge wr_clk);
    write = 1'b0;

    @(posedge rd_clk);
    assert (rvalid || rdata == '0)
        else $fatal(1, "payload changed before valid");
    repeat (3) @(posedge rd_clk);
    $finish;
end

endmodule: tb

`default_nettype wire
