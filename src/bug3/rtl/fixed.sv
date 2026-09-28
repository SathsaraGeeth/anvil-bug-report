`timescale 1ps/1ps

module cdc_payload #(
    parameter int WIDTH = 8
) (
    input  logic             i_wr_clk,
    input  logic             i_rd_clk,
    input  logic             i_rst_n,
    input  logic             i_write,
    input  logic [WIDTH-1:0] i_wdata,
    output logic             o_rvalid,
    output logic [WIDTH-1:0] o_rdata
);

logic [WIDTH-1:0] r_storage;
logic r_write_seen;
logic r_valid_meta;
logic r_valid_sync;

always_ff @(posedge i_wr_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_storage    <= '0;
        r_write_seen <= 1'b0;
    end else if (i_write) begin
        r_storage    <= i_wdata;
        r_write_seen <= 1'b1;
    end
end

always_ff @(posedge i_rd_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_valid_meta <= 1'b0;
        r_valid_sync <= 1'b0;
    end else begin
        r_valid_meta <= r_write_seen;
        r_valid_sync <= r_valid_meta;
    end
end

assign o_rvalid = r_valid_sync;
assign o_rdata  = o_rvalid ? r_storage : '0;

endmodule: cdc_payload
