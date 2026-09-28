`timescale 1ns / 1ps

module properties;

    localparam int QUEUE_COUNT = 256;
    logic f_clk;
    logic [QUEUE_COUNT * 32 - 1:0] f_queue_ram;

    queue_init dut(.o_queue_ram(f_queue_ram));

    property p_entry_is_initialized
        (logic [31:0] entry);
        @(posedge f_clk) !$isunknown(entry) && entry == '0;
    endproperty : p_entry_is_initialized

    for (genvar q = 0; q < QUEUE_COUNT; q++) begin : check_entry
    a_entry_is_initialized:
        assert property (p_entry_is_initialized(f_queue_ram[q * 32 +: 32]));
    end

endmodule : properties
