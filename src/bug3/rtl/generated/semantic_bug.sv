/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module invalid_cdc_payload_semantic_bug (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _port_write_ack,
  input logic[0:0] _port_write_valid,
  input logic[7:0] _port_write_0,
  input logic[0:0] _port_read_ack,
  output logic[0:0] _port_read_valid,
  output logic[8:0] _port_read_0
);
  logic[8:0] result_q;
  logic[0:0] seen_q;
  logic[7:0] storage_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[8:0] thread_0_wire$6;
  logic[7:0] thread_0_wire$5;
  logic[0:0] thread_0_wire$4;
  logic[7:0] thread_0_wire$1;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = _port_write_valid;
  assign thread_0_wire$1 = _port_write_0;
  localparam logic[0:0] thread_0_wire$2 = 1'b1;
  localparam logic[0:0] thread_0_wire$3 = 1'b0;
  assign thread_0_wire$4 = seen_q;
  assign thread_0_wire$5 = storage_q;
  assign thread_0_wire$6 = result_q;
  for (genvar i = 0; i < 9; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_8_1_q, _thread_0_event_counter_8_1_n;
  logic _thread_0_event_syncstate_7_q, _thread_0_event_syncstate_7_n;
  logic _thread_0_event_counter_6_1_q, _thread_0_event_counter_6_1_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  assign EVENTS0[8].event_current = _thread_0_event_counter_8_1_q;
  assign _thread_0_event_counter_8_1_n = EVENTS0[7].event_current;
  assign EVENTS0[7].event_current = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && _port_read_ack;
    assign _thread_0_event_syncstate_7_n = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && !_port_read_ack;
  assign EVENTS0[6].event_current = _thread_0_event_counter_6_1_q;
  assign _thread_0_event_counter_6_1_n = EVENTS0[5].event_current;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = EVENTS0[3].event_current || EVENTS0[1].event_current;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _port_write_valid;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_port_write_valid;
  assign EVENTS0[2].event_current = EVENTS0[0].event_current && thread_0_wire$0;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && !thread_0_wire$0;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[8].event_current;
  assign _port_write_ack = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _port_read_valid = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q);
  assign _port_read_0 = thread_0_wire$6;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      result_q <= '0;
      seen_q <= '0;
      storage_q <= '0;
      _thread_0_event_counter_8_1_q <= '0;
      _thread_0_event_syncstate_7_q <= '0;
      _thread_0_event_counter_6_1_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
    end else begin
      if (EVENTS0[5].event_current) begin
        result_q[0 +: 8] <= thread_0_wire$5;
        result_q[8 +: 1] <= thread_0_wire$4;
      end
      if (EVENTS0[3].event_current) begin
        seen_q[0 +: 1] <= thread_0_wire$2;
        storage_q[0 +: 8] <= thread_0_wire$1;
      end
      if (EVENTS0[1].event_current) begin
        seen_q[0 +: 1] <= thread_0_wire$3;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_8_1_q <= _thread_0_event_counter_8_1_n;
      _thread_0_event_syncstate_7_q <= _thread_0_event_syncstate_7_n;
      _thread_0_event_counter_6_1_q <= _thread_0_event_counter_6_1_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
    end
  end
endmodule
