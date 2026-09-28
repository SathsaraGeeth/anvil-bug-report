`timescale 1ps / 1ps

module queue_init
    #(parameter int QUEUE_INDEX_WIDTH = 8)
    (output logic [(2 ** QUEUE_INDEX_WIDTH) * 32 - 1:0] o_queue_ram);

    localparam int QUEUE_COUNT = 2 ** QUEUE_INDEX_WIDTH;
    localparam int BLOCK_SIZE = 2 ** (QUEUE_INDEX_WIDTH / 2);

    logic [31:0] queue_ram[0:QUEUE_COUNT - 1];
    integer i;
    integer j;

    for (genvar q = 0; q < QUEUE_COUNT; q++) begin : expose_entry
        assign o_queue_ram[q * 32 +: 32] = queue_ram[q];
    end

    initial begin
        for (i = 0; i < QUEUE_INDEX_WIDTH; i = i + BLOCK_SIZE)
            for (j = i; j < i + BLOCK_SIZE; j = j + 1)
                queue_ram[j] = '0;
    end

endmodule : queue_init
