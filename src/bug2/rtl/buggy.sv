`timescale 1ps/1ps

module stale_fifo #(
    parameter int WIDTH = 8
) (
    input  logic             i_clk,
    input  logic             i_rst_n,
    input  logic             i_push,
    input  logic             i_pop,
    input  logic [WIDTH-1:0] i_wdata,
    output logic             o_empty,
    output logic [WIDTH-1:0] o_rdata
);

logic r_full;
logic [WIDTH-1:0] r_storage;

assign o_empty = !r_full;
assign o_rdata = r_storage;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_full    <= 1'b0;
        r_storage <= '0;
    end else begin
        if (i_push) begin
            r_full    <= 1'b1;
            r_storage <= i_wdata;
        end
        if (i_pop)
            r_full <= 1'b0;
    end
end

endmodule: stale_fifo
