module sby_properties;

localparam int QUEUE_COUNT = 256;

logic [QUEUE_COUNT*32-1:0] f_queue_ram;

queue_init dut (
    .o_queue_ram(f_queue_ram)
);

for (genvar q = 0; q < QUEUE_COUNT; q++) begin : check_entry
    always @* begin
        assert (f_queue_ram[q*32 +: 32] == '0);
    end
end

endmodule: sby_properties
