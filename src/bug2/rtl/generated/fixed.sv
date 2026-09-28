/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module stale_fifo (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _port_cmd_ack,
  input logic[0:0] _port_cmd_valid,
  input logic[8:0] _port_cmd_0,
  input logic[0:0] _port_obs_ack,
  output logic[0:0] _port_obs_valid,
  output logic[8:0] _port_obs_0
);
  logic[0:0] full_q;
  logic[8:0] result_q;
  logic[7:0] storage_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[8:0] thread_0_wire$15;
  logic[7:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$10;
  logic[0:0] thread_0_wire$9;
  logic[0:0] thread_0_wire$7;
  logic[7:0] thread_0_wire$4;
  logic[0:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$1;
  logic[8:0] thread_0_wire$0;
  assign thread_0_wire$0 = _port_cmd_0;
  assign thread_0_wire$1 = thread_0_wire$0[8 +: 1];
  localparam logic[0:0] thread_0_wire$2 = 1'd0;
  assign thread_0_wire$3 = thread_0_wire$1 == thread_0_wire$2;
  assign thread_0_wire$4 = thread_0_wire$0[0 +: 8];
  localparam logic[0:0] thread_0_wire$5 = 1'b1;
  localparam logic[0:0] thread_0_wire$6 = 1'b0;
  assign thread_0_wire$7 = full_q;
  localparam logic[0:0] thread_0_wire$8 = 1'b0;
  assign thread_0_wire$9 = thread_0_wire$7 == thread_0_wire$8;
  assign thread_0_wire$10 = full_q;
  localparam logic[0:0] thread_0_wire$11 = 1'b0;
  assign thread_0_wire$12 = thread_0_wire$10 == thread_0_wire$11;
  localparam logic[7:0] thread_0_wire$13 = 8'b0;
  assign thread_0_wire$14 = storage_q;
  assign thread_0_wire$15 = result_q;
  for (genvar i = 0; i < 10; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_syncstate_4_q, _thread_0_event_syncstate_4_n;
  logic _thread_0_event_counter_3_1_q, _thread_0_event_counter_3_1_n;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[9].event_current = EVENTS0[1].event_current && !thread_0_wire$3;
  assign EVENTS0[8].event_current = EVENTS0[1].event_current && thread_0_wire$3;
  assign EVENTS0[7].event_current = EVENTS0[2].event_current && !thread_0_wire$12;
  assign EVENTS0[6].event_current = EVENTS0[2].event_current && thread_0_wire$12;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && _port_obs_ack;
    assign _thread_0_event_syncstate_4_n = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && !_port_obs_ack;
  assign EVENTS0[3].event_current = _thread_0_event_counter_3_1_q;
  assign _thread_0_event_counter_3_1_n = EVENTS0[2].event_current;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[1].event_current;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _port_cmd_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_port_cmd_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[5].event_current;
  assign _port_cmd_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _port_obs_valid = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q);
  assign _port_obs_0 = thread_0_wire$15;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      full_q <= '0;
      result_q <= '0;
      storage_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_syncstate_4_q <= '0;
      _thread_0_event_counter_3_1_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[9].event_current) begin
        full_q[0 +: 1] <= thread_0_wire$6;
      end
      if (EVENTS0[8].event_current) begin
        full_q[0 +: 1] <= thread_0_wire$5;
        storage_q[0 +: 8] <= thread_0_wire$4;
      end
      if (EVENTS0[7].event_current) begin
        result_q[0 +: 8] <= thread_0_wire$14;
      end
      if (EVENTS0[6].event_current) begin
        result_q[0 +: 8] <= thread_0_wire$13;
      end
      if (EVENTS0[2].event_current) begin
        result_q[8 +: 1] <= thread_0_wire$9;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_syncstate_4_q <= _thread_0_event_syncstate_4_n;
      _thread_0_event_counter_3_1_q <= _thread_0_event_counter_3_1_n;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
