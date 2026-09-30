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

typedef enum logic [1:0] {
    COLLECT,
    WAIT_ACK_HIGH,
    WAIT_ACK_LOW,
    START_NEXT
} state_t;
state_t r_state;
logic r_word_count;
logic r_msg_mask;
logic w_msg_start;
logic w_msg_end;

assign o_aes_req   = r_state == WAIT_ACK_HIGH;
assign w_msg_start = r_state == START_NEXT;
assign w_msg_end   = o_aes_req;
assign o_msg_ready = r_msg_mask && !w_msg_end && !o_aes_req;

always_ff @(posedge i_clk) begin
    if (!i_rst_n) begin
        r_state      <= COLLECT;
        r_word_count <= 1'b0;
        r_msg_mask   <= 1'b1;
        o_accepted   <= '0;
    end else begin
        if (w_msg_start)
            r_msg_mask <= 1'b1;
        else if (w_msg_end)
            r_msg_mask <= 1'b0;

        if (i_msg_valid && o_msg_ready) begin
            o_accepted <= o_accepted + 1'b1;
            r_word_count <= r_word_count + 1'b1;
        end
        if (r_state == COLLECT && i_msg_valid && o_msg_ready && r_word_count == 1'b1)
            r_state <= WAIT_ACK_HIGH;
        else if (r_state == WAIT_ACK_HIGH && i_aes_ack)
            r_state <= WAIT_ACK_LOW;
        else if (r_state == WAIT_ACK_LOW && !i_aes_ack)
            r_state <= START_NEXT;
        else if (r_state == START_NEXT) begin
            r_state <= COLLECT;
            r_word_count <= 1'b0;
        end
    end
end

endmodule: handshake_delay
