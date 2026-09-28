/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module handshake_delay_semantic_bug (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _port_event_ack,
  input logic[0:0] _port_event_valid,
  input logic[0:0] _port_event_0,
  input logic[0:0] _port_obs_ack,
  output logic[0:0] _port_obs_valid,
  output logic[4:0] _port_obs_0
);
  logic[3:0] accepted_q;
  logic[4:0] result_q;
  logic[0:0] waiting_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[4:0] thread_0_wire$10;
  logic[0:0] thread_0_wire$9;
  logic[3:0] thread_0_wire$8;
  logic[3:0] thread_0_wire$5;
  logic[3:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = _port_event_0;
  localparam logic[0:0] thread_0_wire$1 = 1'd0;
  assign thread_0_wire$2 = thread_0_wire$0 == thread_0_wire$1;
  assign thread_0_wire$3 = accepted_q;
  localparam logic[3:0] thread_0_wire$4 = 4'b0001;
  assign thread_0_wire$5 = thread_0_wire$3 + thread_0_wire$4;
  localparam logic[0:0] thread_0_wire$6 = 1'b1;
  localparam logic[0:0] thread_0_wire$7 = 1'b0;
  assign thread_0_wire$8 = accepted_q;
  assign thread_0_wire$9 = waiting_q;
  assign thread_0_wire$10 = result_q;
  for (genvar i = 0; i < 8; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_7_1_q, _thread_0_event_counter_7_1_n;
  logic _thread_0_event_syncstate_6_q, _thread_0_event_syncstate_6_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_1_q;
  assign _thread_0_event_counter_7_1_n = EVENTS0[6].event_current;
  assign EVENTS0[6].event_current = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && _port_obs_ack;
    assign _thread_0_event_syncstate_6_n = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && !_port_obs_ack;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[1].event_current;
  assign EVENTS0[3].event_current = EVENTS0[1].event_current && thread_0_wire$2;
  assign EVENTS0[2].event_current = EVENTS0[1].event_current && !thread_0_wire$2;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _port_event_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_port_event_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[7].event_current;
  assign _port_event_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _port_obs_valid = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q);
  assign _port_obs_0 = thread_0_wire$10;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      accepted_q <= '0;
      result_q <= '0;
      waiting_q <= '0;
      _thread_0_event_counter_7_1_q <= '0;
      _thread_0_event_syncstate_6_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[4].event_current) begin
        result_q[0 +: 1] <= thread_0_wire$9;
        result_q[1 +: 4] <= thread_0_wire$8;
      end
      if (EVENTS0[3].event_current) begin
        waiting_q[0 +: 1] <= thread_0_wire$6;
        accepted_q[0 +: 4] <= thread_0_wire$5;
      end
      if (EVENTS0[2].event_current) begin
        waiting_q[0 +: 1] <= thread_0_wire$7;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_7_1_q <= _thread_0_event_counter_7_1_n;
      _thread_0_event_syncstate_6_q <= _thread_0_event_syncstate_6_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
