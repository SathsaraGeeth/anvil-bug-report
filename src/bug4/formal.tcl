set FORMAL_SRC_FILES [list rtl/$::env(VARIANT).sv formal/properties.sv]
set TOP_MODULE properties
set PROPERTIES [list \
    p_request_applies_backpressure \
    p_ack_pending_blocks_input \
    p_handshake_eventually_returns_idle]
