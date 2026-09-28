`timescale 1ps/1ps

module cdc_check_top (
    input  logic       i_wr_clk,
    input  logic       i_rd_clk,
    input  logic       i_rst_n,
    input  logic       i_write,
    input  logic [7:0] i_wdata,
    output logic       o_rvalid,
    output logic [7:0] o_observed
);

logic       w_rvalid;
logic [7:0] w_rdata;
logic [7:0] r_observed;

assign o_rvalid   = w_rvalid;
assign o_observed = r_observed;

cdc_payload dut (
    .i_wr_clk (i_wr_clk),
    .i_rd_clk (i_rd_clk),
    .i_rst_n  (i_rst_n),
    .i_write  (i_write),
    .i_wdata  (i_wdata),
    .o_rvalid (w_rvalid),
    .o_rdata  (w_rdata)
);

always_ff @(posedge i_rd_clk or negedge i_rst_n) begin
    if (!i_rst_n)
        r_observed <= '0;
    else
        r_observed <= w_rdata;
end

endmodule: cdc_check_top
