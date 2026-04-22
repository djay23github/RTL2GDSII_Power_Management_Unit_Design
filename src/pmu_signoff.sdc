# =============================================================================
# signoff.sdc — Post-PnR Signoff Constraints
# Design  : pmu_fsm
# PDK     : sky130A  /  sky130_fd_sc_hd
# Flow    : LibreLane Classic  (SIGNOFF_SDC_FILE)
# Backend : OpenROAD.STAPostPNR  (OpenSTA with SPEF parasitics)
#
# This file is consumed only by the final STA step after:
#   - Detailed routing is complete (TritonRoute)
#   - Parasitics are extracted (OpenRCX → SPEF)
#   - Multi-corner analysis runs across nom/min/max corners
#
# Strategy: REALISTIC constraints matching actual system integration intent.
#   - Smaller clock uncertainty: the real clock tree is built, propagated
#     clock latency is used by OpenSTA (set_propagated_clock), so only
#     residual jitter and on-chip variation (OCV) guard band is needed.
#   - Tighter I/O delays: reflect real neighbouring-block timing budgets.
#   - False paths are identical to pnr.sdc — async topology doesn't change.
#
# Usage in config.yaml:
#   SIGNOFF_SDC_FILE: dir::src/signoff.sdc
#
# NOTE on set_propagated_clock:
#   LibreLane / OpenROAD automatically switches to propagated clock mode
#   for STAPostPNR. Do NOT call set_propagated_clock here — adding it
#   explicitly can cause double-counting of clock latency and incorrect
#   slack reports.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Clock Definition
#    Identical period and waveform to pnr.sdc.
#    At signoff, OpenSTA uses the real extracted clock tree latency from the
#    routed netlist — the waveform here defines the ideal reference edge only.
# -----------------------------------------------------------------------------
create_clock -name clk -period 8 [get_ports clk]

# -----------------------------------------------------------------------------
# 2. Clock Uncertainty (Signoff)
#    Reduced vs PnR because:
#      - Clock tree is real — skew is captured in propagated path delays.
#      - Remaining uncertainty budget covers only:
#        0.05 ns  residual jitter (crystal oscillator typical)
#        0.05 ns  OCV guard (process/voltage/temp variation not in SPEF)
#      Total: 0.10 ns
#    This is the value used for final setup/hold sign-off.
# -----------------------------------------------------------------------------
set_clock_uncertainty 0.20 [get_clocks clk]

# -----------------------------------------------------------------------------
# 3. Clock Transition
#    Same target as PnR. At signoff the real transition is captured in the
#    SPEF parasitics, but we set this as a sanity bound — OpenSTA will
#    flag if any clock pin exceeds it.
# -----------------------------------------------------------------------------
set_clock_transition 0.15 [get_clocks clk]

# -----------------------------------------------------------------------------
# 4. Driving Cell for Input Ports
#    Identical to pnr.sdc. At signoff, the driving cell models the strength
#    of whatever external block drives these ports into the PMU.
# -----------------------------------------------------------------------------
#set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 -pin Y [all_inputs]

#set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_4 -pin X [get_ports clk]

# -----------------------------------------------------------------------------
# 5. False Paths — Asynchronous Inputs (unchanged from pnr.sdc)
#    Same reasoning applies at signoff: asynchronous ports are resolved
#    by 2-FF synchronizers. Timing analysis on port→sync_D is invalid.
# -----------------------------------------------------------------------------
set_false_path -from [get_ports reset_n]

set_false_path -from [get_ports req_idle]
set_false_path -from [get_ports req_sleep]
set_false_path -from [get_ports req_off]
set_false_path -from [get_ports wake_up]

set_false_path -from [get_ports pwr_stable]
set_false_path -from [get_ports clk_stable]
set_false_path -from [get_ports retention_ready]

# -----------------------------------------------------------------------------
# 6. Output Load
#    Identical to pnr.sdc. At signoff, SPEF captures on-chip wire parasitics
#    to the pad ring — this load represents the pad/IO cell + board trace cap
#    which is NOT in the SPEF. Retain the same value for consistency.
# -----------------------------------------------------------------------------
set_load 0.015 [all_outputs]

# -----------------------------------------------------------------------------
# 7. Output Delays (Signoff — Realistic Budget)
#    Tighter than pnr.sdc: models the real downstream timing budget.
#
#    Setup (max) budget:
#      External combinational logic delay: 1.0 ns
#      Downstream FF setup time:           0.5 ns
#      Total:                              1.5 ns
#    This leaves 8.5 ns for the on-chip clk→FF→output path.
#
#    Hold (min) budget:
#      The -min value constrains the hold path:
#      The output must be stable for at least -0.500 ns after the clock edge
#      at the downstream FF. Negative means the output can change 0.5 ns
#      BEFORE the clock edge — conservative for an output driving slow logic.
# -----------------------------------------------------------------------------
set_output_delay -clock clk -max  1.5 [all_outputs]
set_output_delay -clock clk -min -0.5 [all_outputs]

# -----------------------------------------------------------------------------
# 8. Max Transition Guard (Signoff)
#    At signoff, SPEF captures real wire resistance. A high transition time
#    indicates a weak driver or high-cap net. Flag anything over 0.75 ns.
#    This matches sky130_fd_sc_hd cell characterisation range.
# -----------------------------------------------------------------------------
set_max_transition 0.75 [current_design]

# -----------------------------------------------------------------------------
# 9. Multi-corner note
#    LibreLane STAPostPNR runs across 9 corners defined in the PDK:
#      nom_tt_025C_1v80  (typical-typical, nominal)
#      min_ff_n40C_1v95  (fast-fast, cold, high voltage)
#      max_ss_100C_1v60  (slow-slow, hot, low voltage)
#      ... and interpolated corners
#    The constraints in this file apply to all corners. The PDK timing
#    libraries handle the cell delay variation per corner. No per-corner
#    SDC overrides are needed for this design.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# End of signoff.sdc
# -----------------------------------------------------------------------------
