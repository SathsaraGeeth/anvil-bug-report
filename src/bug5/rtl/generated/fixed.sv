/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module csr_dual_issue (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _port_pair_ack,
  input logic[0:0] _port_pair_valid,
  input logic[7:0] _port_pair_0,
  input logic[0:0] _port_result_ack,
  output logic[0:0] _port_result_valid,
  output logic[1:0] _port_result_0
);
  logic[1:0] output_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[1:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$10;
  logic[0:0] thread_0_wire$8;
  logic[0:0] thread_0_wire$7;
  logic[2:0] thread_0_wire$5;
  logic[0:0] thread_0_wire$4;
  logic[2:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$1;
  logic[7:0] thread_0_wire$0;
  assign thread_0_wire$0 = _port_pair_0;
  assign thread_0_wire$1 = thread_0_wire$0[7 +: 1];
  assign thread_0_wire$2 = thread_0_wire$0[4 +: 3];
  localparam logic[2:0] thread_0_wire$3 = 3'd1;
  assign thread_0_wire$4 = thread_0_wire$2 == thread_0_wire$3;
  assign thread_0_wire$5 = thread_0_wire$0[0 +: 3];
  localparam logic[2:0] thread_0_wire$6 = 3'd1;
  assign thread_0_wire$7 = thread_0_wire$5 == thread_0_wire$6;
  assign thread_0_wire$8 = thread_0_wire$4 || thread_0_wire$7;
  localparam logic[0:0] thread_0_wire$9 = 1'b0;
  assign thread_0_wire$10 = thread_0_wire$0[3 +: 1];
  assign thread_0_wire$11 = output_q;
  for (genvar i = 0; i < 7; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[6].event_current = EVENTS0[1].event_current && thread_0_wire$8;
  assign EVENTS0[5].event_current = EVENTS0[1].event_current && !thread_0_wire$8;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[3].event_current;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _port_result_ack;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_port_result_ack;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[1].event_current;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _port_pair_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_port_pair_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[4].event_current;
  assign _port_pair_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _port_result_valid = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _port_result_0 = thread_0_wire$11;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      output_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[6].event_current) begin
        output_q[0 +: 1] <= thread_0_wire$9;
      end
      if (EVENTS0[5].event_current) begin
        output_q[0 +: 1] <= thread_0_wire$10;
      end
      if (EVENTS0[1].event_current) begin
        output_q[1 +: 1] <= thread_0_wire$1;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
