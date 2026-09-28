`timescale 1ns/1ps

module queue_init_anvil_properties;

localparam int QUEUE_COUNT = 256;

(* gclk *) logic f_clk;
(* anyseq *) logic f_rst_n;
(* anyseq *) logic f_entries_ack;
logic f_entries_valid;
logic [QUEUE_COUNT*32-1:0] f_queue_ram;
logic f_past_valid = 1'b0;

queue_init dut (
    .clk_i               (f_clk),
    .rst_ni              (f_rst_n),
    ._port_entries_ack   (f_entries_ack),
    ._port_entries_valid (f_entries_valid),
    ._port_entries_0     (f_queue_ram)
);

always_ff @(posedge f_clk) begin
    if (!f_past_valid)
        assume (!f_rst_n);
    else
        assume (f_rst_n);

    f_past_valid <= 1'b1;
end

for (genvar q = 0; q < QUEUE_COUNT; q++) begin : check_entry
    always_ff @(posedge f_clk) begin
        if (f_rst_n && f_past_valid && f_entries_valid)
            assert (f_queue_ram[q*32 +: 32] == '0);
    end
end

endmodule: queue_init_anvil_properties
