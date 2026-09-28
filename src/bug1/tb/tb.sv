`timescale 1ns / 1ps
`default_nettype none

module tb;

    localparam int QUEUE_COUNT = 256;
    logic [QUEUE_COUNT * 32 - 1:0] queue_ram;

    queue_init dut(.o_queue_ram(queue_ram));

    initial begin
        #1;
        for (int q = 0; q < QUEUE_COUNT; q++) begin
            assert (!$isunknown(queue_ram[q * 32 +: 32]) &&
                    queue_ram[q * 32 +: 32] == '0)
            else
                $fatal(1, "queue_ram[%0d] was not initialized", q);
        end
        $finish;
    end

endmodule : tb

`default_nettype wire
