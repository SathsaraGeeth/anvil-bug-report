`timescale 1ps/1ps
`default_nettype none

module tb;

localparam logic [2:0] ALU  = 3'd0;
localparam logic [2:0] CSR  = 3'd1;
localparam logic [2:0] LOAD = 3'd2;

logic       valid0;
logic [2:0] fu0;
logic       valid1;
logic [2:0] fu1;
logic       issue0;
logic       issue1;

csr_issue dut (
    .i_valid0(valid0),
    .i_fu0   (fu0),
    .i_valid1(valid1),
    .i_fu1   (fu1),
    .o_issue0(issue0),
    .o_issue1(issue1)
);

initial begin
    valid0 = 1'b1;
    fu0    = CSR;
    valid1 = 1'b1;
    fu1    = LOAD;
    #1;
    assert (!issue1)
        else $fatal(1, "load issued beside CSR");

    fu0 = ALU;
    fu1 = CSR;
    #1;
    assert (!issue1)
        else $fatal(1, "CSR issued on port 1");

    $finish;
end

endmodule: tb

`default_nettype wire
