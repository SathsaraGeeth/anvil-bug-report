/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module queue_init (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  input logic[0:0] _port_entries_ack,
  output logic[0:0] _port_entries_valid,
  output logic[8191:0] _port_entries_0
);
  logic[0:0] initialized_q;
  logic[8191:0] queue_ram_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[8191:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$20;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = initialized_q;
  localparam logic[0:0] thread_0_wire$1 = 1'b0;
  assign thread_0_wire$2 = thread_0_wire$0 == thread_0_wire$1;
  localparam logic[31:0] thread_0_wire$3 = 32'b0;
  localparam logic[31:0] thread_0_wire$4 = 32'b0;
  localparam logic[31:0] thread_0_wire$5 = 32'b0;
  localparam logic[31:0] thread_0_wire$6 = 32'b0;
  localparam logic[31:0] thread_0_wire$7 = 32'b0;
  localparam logic[31:0] thread_0_wire$8 = 32'b0;
  localparam logic[31:0] thread_0_wire$9 = 32'b0;
  localparam logic[31:0] thread_0_wire$10 = 32'b0;
  localparam logic[31:0] thread_0_wire$11 = 32'b0;
  localparam logic[31:0] thread_0_wire$12 = 32'b0;
  localparam logic[31:0] thread_0_wire$13 = 32'b0;
  localparam logic[31:0] thread_0_wire$14 = 32'b0;
  localparam logic[31:0] thread_0_wire$15 = 32'b0;
  localparam logic[31:0] thread_0_wire$16 = 32'b0;
  localparam logic[31:0] thread_0_wire$17 = 32'b0;
  localparam logic[31:0] thread_0_wire$18 = 32'b0;
  localparam logic[0:0] thread_0_wire$19 = 1'b1;
  assign thread_0_wire$20 = initialized_q;
  assign thread_0_wire$21 = queue_ram_q;
  for (genvar i = 0; i < 6; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_3_1_q, _thread_0_event_counter_3_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_counter_1_1_q, _thread_0_event_counter_1_1_n;
  assign EVENTS0[5].event_current = EVENTS0[0].event_current && !thread_0_wire$2;
  assign EVENTS0[4].event_current = EVENTS0[0].event_current && thread_0_wire$2;
  assign EVENTS0[3].event_current = _thread_0_event_counter_3_1_q;
  assign _thread_0_event_counter_3_1_n = EVENTS0[2].event_current;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _port_entries_ack;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_port_entries_ack;
  assign EVENTS0[1].event_current = _thread_0_event_counter_1_1_q;
  assign _thread_0_event_counter_1_1_n = EVENTS0[0].event_current;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[3].event_current;
  assign _port_entries_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _port_entries_0 = thread_0_wire$21;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      initialized_q <= '0;
      queue_ram_q <= '0;
      _thread_0_event_counter_3_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_counter_1_1_q <= '0;
    end else begin
      if (EVENTS0[5].event_current) begin
        initialized_q[0 +: 1] <= thread_0_wire$20;
      end
      if (EVENTS0[4].event_current) begin
        initialized_q[0 +: 1] <= thread_0_wire$19;
        queue_ram_q[0 +: 32] <= thread_0_wire$18;
        queue_ram_q[32 +: 32] <= thread_0_wire$17;
        queue_ram_q[64 +: 32] <= thread_0_wire$16;
        queue_ram_q[96 +: 32] <= thread_0_wire$15;
        queue_ram_q[128 +: 32] <= thread_0_wire$14;
        queue_ram_q[160 +: 32] <= thread_0_wire$13;
        queue_ram_q[192 +: 32] <= thread_0_wire$12;
        queue_ram_q[224 +: 32] <= thread_0_wire$11;
        queue_ram_q[256 +: 32] <= thread_0_wire$10;
        queue_ram_q[288 +: 32] <= thread_0_wire$9;
        queue_ram_q[320 +: 32] <= thread_0_wire$8;
        queue_ram_q[352 +: 32] <= thread_0_wire$7;
        queue_ram_q[384 +: 32] <= thread_0_wire$6;
        queue_ram_q[416 +: 32] <= thread_0_wire$5;
        queue_ram_q[448 +: 32] <= thread_0_wire$4;
        queue_ram_q[480 +: 32] <= thread_0_wire$3;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_3_1_q <= _thread_0_event_counter_3_1_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
      _thread_0_event_counter_1_1_q <= _thread_0_event_counter_1_1_n;
    end
  end
endmodule
