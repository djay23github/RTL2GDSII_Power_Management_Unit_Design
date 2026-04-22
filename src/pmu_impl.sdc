# =============================================================================
# pmu_impl.sdc — PnR Implementation Constraints
# Design  : pmu_fsm
# PDK     : sky130A  /  sky130_fd_sc_hd
# Flow    : LibreLane Classic  (PNR_SDC_FILE)
# Backend : OpenSTA inside OpenROAD
#
# This file is consumed by every pre/mid-PnR step:
#   Synthesis STA, Floorplan STA, post-placement STA, CTS, post-CTS repair,
#   global routing, post-route repair (OpenROAD.RepairDesign / .ResizerTimingPostCTS)
#
# Strategy: OVER-CONSTRAIN relative to signoff.sdc
#   - Tighter clock uncertainty absorbs pre-CTS skew pessimism and drives
#     the router/CTS engine to build a better clock tree.
#   - Slightly larger I/O delays leave margin for the tool to work with.
#   - All async inputs are false-pathed — the design uses 2-FF synchronizers
#     internally for every async input (req_*, wake_up, pwr_stable, clk_stable,
#     retention_ready). STA on the raw port-to-sync-FF path is meaningless
#     and would produce false violations.
#
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Clock Definition
#    100 MHz, 50% duty cycle, waveform: rise at 0, fall at 5 ns
#    Driving the clk port directly (no PLL in this design).
# -----------------------------------------------------------------------------
create_clock -name clk -period 8 [get_ports clk]

# -----------------------------------------------------------------------------
# 2. Clock Uncertainty
#    PnR value (0.25 ns) is intentionally pessimistic:
#      - 0.10 ns  estimated post-CTS skew (sky130_fd_sc_hd CTS target)
#      - 0.10 ns  jitter budget (oscillator + PLL-less path)
#      - 0.05 ns  margin for ECO buffer insertion
#    This forces the placer and CTS engine to build tighter timing paths.
#    The signoff.sdc relaxes this to 0.10 ns once the real clock tree is built.
# -----------------------------------------------------------------------------
set_clock_uncertainty 0.25 [get_clocks clk]

# -----------------------------------------------------------------------------
# 3. Clock Transition
#    Target max transition on clock pins: 0.15 ns.
#    sky130_fd_sc_hd clkbuf_4 drives this comfortably at 100 MHz.
#    OpenROAD CTS will honour this when selecting buffer sizes.
# -----------------------------------------------------------------------------
set_clock_transition 0.15 [get_clocks clk]

# -----------------------------------------------------------------------------
# 4. Driving Cell for Input Ports
#    Models the output driver of whatever upstream flop drives each input.
#    sky130_fd_sc_hd__buf_2: moderate driver (X2 strength), realistic for
#    on-chip neighbouring logic driving a PMU request line.
#    The clock port gets a dedicated clock buffer model.
# -----------------------------------------------------------------------------
#set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 -pin Y [all_inputs]

# Override the clock port with a stronger clock buffer model
#set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_4  -pin X [get_ports clk]

# -----------------------------------------------------------------------------
# 5. False Paths — Asynchronous Inputs
#    The following inputs are asynchronous to clk and are resolved by
#    2-stage synchroniser chains inside pmu_fsm.
#    Running STA on port → sync_FF_D is not meaningful — the MTBF calculation
#    is handled by the synchroniser topology, not by hold/setup timing.
#    False-pathing suppresses spurious violations and prevents the router
#    from wasting effort on these paths.
#
#    reset_n:             Asynchronous active-low reset — always a false path.
#    req_idle/sleep/off:  PMU request lines from SW/HW, fully asynchronous.
#    wake_up:             Wake event from analog/power domain, asynchronous.
#    pwr_stable:          Power ramp feedback from LDO/bandgap, asynchronous.
#    clk_stable:          PLL lock indicator, asynchronous.
#    retention_ready:     Retention cell status, asynchronous.
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
#    Models the capacitive load on each output port:
#    sky130_fd_sc_hd typical pin cap ≈ 4 fF, wire + 2 fanout cells ≈ 0.013 pF.
#    This matches the OpenLane reference value for sky130_fd_sc_hd.
# -----------------------------------------------------------------------------
set_load 0.020 [all_outputs]

# -----------------------------------------------------------------------------
# 7. Output Delays (setup)
#    All outputs of pmu_fsm are registered (Moore machine with registered
#    outputs). The output_delay models the setup time of downstream logic
#    capturing these outputs in the system — assumed to be a neighbouring
#    always-on domain clocked by the same clk.
#
#    Budget (PnR, pessimistic):
#      External combinational logic delay: 1.5 ns
#      Downstream FF setup time:           0.5 ns
#      Total:                              2.0 ns
#    This leaves 8.0 ns for the on-chip path (clk → FF → output port).
#    Over-constraining here allows the router to optimize output paths.
# -----------------------------------------------------------------------------
set_output_delay -clock clk -max  2.0 [all_outputs]
set_output_delay -clock clk -min  -0.50 [all_outputs]

# -----------------------------------------------------------------------------
# 8. Max Fanout / Transition Guard
#    Prevent the synthesizer from producing degenerate high-fanout nets.
#    OpenROAD's repair step will buffer these, but bounding here speeds
#    convergence.
# -----------------------------------------------------------------------------
set_max_fanout 6 [current_design]
set_max_transition 0.75 [current_design]

# -----------------------------------------------------------------------------
# End of pmu_impl.sdc
# -----------------------------------------------------------------------------
