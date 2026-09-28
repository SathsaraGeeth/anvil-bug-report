/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module handshake_delay (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _input_word_ack,
  input logic[0:0] _input_word_valid,
  input logic[7:0] _input_word_0,
  input logic[0:0] _aes_req_ack,
  output logic[0:0] _aes_req_valid,
  output logic[7:0] _aes_req_0,
  output logic[0:0] _aes_ack_ack,
  input logic[0:0] _aes_ack_valid,
  input logic[0:0] _aes_ack_0
);
  logic[7:0] block_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$2;
  logic[7:0] thread_0_wire$1;
  logic[7:0] thread_0_wire$0;
  assign thread_0_wire$0 = _input_word_0;
  assign thread_0_wire$1 = block_q;
  assign thread_0_wire$2 = _aes_ack_0;
  for (genvar i = 0; i < 6; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_syncstate_4_q, _thread_0_event_syncstate_4_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && _aes_ack_valid;
    assign _thread_0_event_syncstate_4_n = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && !_aes_ack_valid;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _aes_req_ack;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_aes_req_ack;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[1].event_current;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _input_word_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_input_word_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[5].event_current;
  assign _aes_ack_ack = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q);
  assign _input_word_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _aes_req_valid = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _aes_req_0 = thread_0_wire$1;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      block_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_syncstate_4_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[1].event_current) begin
        block_q[0 +: 8] <= thread_0_wire$0;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_syncstate_4_q <= _thread_0_event_syncstate_4_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
