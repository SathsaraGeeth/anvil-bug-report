`timescale 1ps / 1ps

module properties;

    localparam logic [2:0] CSR = 3'd1;

    logic f_clk;
    logic f_valid0;
    logic [2:0] f_fu0;
    logic f_valid1;
    logic [2:0] f_fu1;
    logic f_issue0;
    logic f_issue1;

    csr_issue dut(.i_valid0(f_valid0),
                  .i_fu0(f_fu0),
                  .i_valid1(f_valid1),
                  .i_fu1(f_fu1),
                  .o_issue0(f_issue0),
                  .o_issue1(f_issue1));

    property p_csr_is_serialized;
        @(posedge f_clk) f_issue0 && f_fu0 == CSR |-> !f_issue1;
    endproperty : p_csr_is_serialized

    property p_csr_uses_port_zero;
        @(posedge f_clk) !(f_issue1 && f_fu1 == CSR);
    endproperty : p_csr_uses_port_zero

a_csr_is_serialized:
    assert property (p_csr_is_serialized);
a_csr_uses_port_zero:
    assert property (p_csr_uses_port_zero);

endmodule : properties
