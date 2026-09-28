`timescale 1ns/1ps

module sby_properties;

    localparam logic [2:0] CSR = 3'd1;

    (* anyseq *) logic f_valid0;
    (* anyseq *) logic [2:0] f_fu0;
    (* anyseq *) logic f_valid1;
    (* anyseq *) logic [2:0] f_fu1;

    logic f_issue0;
    logic f_issue1;

    csr_issue dut(.i_valid0(f_valid0),
                  .i_fu0(f_fu0),
                  .i_valid1(f_valid1),
                  .i_fu1(f_fu1),
                  .o_issue0(f_issue0),
                  .o_issue1(f_issue1));

    always @* begin
        assert (!(f_issue0 && f_fu0 == CSR && f_issue1));
        assert (!(f_issue1 && f_fu1 == CSR));
    end

endmodule : sby_properties
