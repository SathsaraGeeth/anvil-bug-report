create_clock -name wr_clk -period 10 [get_ports i_wr_clk]
create_clock -name rd_clk -period 14 [get_ports i_rd_clk]

set_input_delay -clock wr_clk [get_ports i_write]
set_input_delay -clock wr_clk [get_ports i_wdata]

set_clock_groups -asynchronous \
    -group {wr_clk} \
    -group {rd_clk}
