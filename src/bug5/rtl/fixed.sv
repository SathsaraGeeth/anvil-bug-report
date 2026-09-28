`timescale 1ps/1ps

module csr_issue (
    input  logic       i_valid0,
    input  logic [2:0] i_fu0,
    input  logic       i_valid1,
    input  logic [2:0] i_fu1,
    output logic       o_issue0,
    output logic       o_issue1
);

localparam logic [2:0] CSR = 3'd1;

logic slot1_blocked;

assign slot1_blocked = i_fu0 == CSR || i_fu1 == CSR;
assign o_issue0      = i_valid0;
assign o_issue1      = i_valid1 && !slot1_blocked;

endmodule: csr_issue
