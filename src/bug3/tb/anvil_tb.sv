`timescale 1ns/1ps
`default_nettype none

module anvil_tb;

logic clk;
logic rst_n;
logic write_ack;
logic write_valid;
logic [7:0] write_data;
logic read_ack;
logic read_valid;

`ifdef SEMANTIC
logic [8:0] read_data;
invalid_cdc_payload_semantic_bug dut (
`else
logic [7:0] read_data;
invalid_cdc_payload dut (
`endif
    .clk_i             (clk),
    .rst_ni            (rst_n),
    ._port_write_ack   (write_ack),
    ._port_write_valid (write_valid),
    ._port_write_0     (write_data),
    ._port_read_ack    (read_ack),
    ._port_read_valid  (read_valid),
    ._port_read_0      (read_data)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    write_valid = 1'b0;
    write_data = '0;
`ifdef SEMANTIC
    read_ack = 1'b1;
`else
    read_ack = 1'b0;
`endif

    #1 rst_n = 1'b0;
    repeat (2) @(posedge clk);
    @(negedge clk);
    rst_n = 1'b1;
    @(negedge clk);
    write_data = 8'hA5;
    write_valid = 1'b1;
    wait (write_ack);
    @(posedge clk);
    @(negedge clk);
    write_valid = 1'b0;
`ifdef SEMANTIC
    repeat (20) begin
        @(negedge clk);
        if (read_valid)
            assert (read_data[8] || read_data[7:0] == '0)
            else
                $fatal(1, "invalid payload exposed retained data");
        read_ack = read_valid;
    end
    $fatal(1, "semantic bug was not observed");
`else
    wait (read_valid);
`endif
    $finish;
end

initial #1000 $fatal(1, "timeout");

endmodule: anvil_tb

`default_nettype wire
