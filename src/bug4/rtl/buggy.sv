`timescale 1ps/1ps

module handshake_delay (
    input  logic       i_clk,
    input  logic       i_rst_n,
    input  logic       i_msg_valid,
    input  logic       i_aes_ack,
    output logic       o_msg_ready,
    output logic       o_aes_req,
    output logic [3:0] o_accepted
);

typedef enum logic {COLLECT, WAIT_ACK} state_t;
state_t r_state;

assign o_aes_req   = r_state == WAIT_ACK;
assign o_msg_ready = 1'b1;

always_ff @(posedge i_clk) begin
    if (!i_rst_n) begin
        r_state     <= COLLECT;
        o_accepted  <= '0;
    end else begin
        if (i_msg_valid && o_msg_ready)
            o_accepted <= o_accepted + 1'b1;
        if (r_state == COLLECT && i_msg_valid && o_accepted == 1)
            r_state <= WAIT_ACK;
        else if (r_state == WAIT_ACK && i_aes_ack)
            r_state <= COLLECT;
    end
end

endmodule: handshake_delay
