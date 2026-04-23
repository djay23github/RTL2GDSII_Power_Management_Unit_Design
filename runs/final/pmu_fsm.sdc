###############################################################################
# Created by write_sdc
###############################################################################
current_design pmu_fsm
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 8.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {clk_gate_en}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {clk_gate_en}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dvfs_ctrl[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dvfs_ctrl[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dvfs_ctrl[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dvfs_ctrl[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {error}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {error}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {pwr_gate_en}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {pwr_gate_en}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {pwr_state[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {pwr_state[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {pwr_state[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {pwr_state[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {reset_ctrl}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {reset_ctrl}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {retention_en}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {retention_en}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {retention_restore}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {retention_restore}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {retention_save}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {retention_save}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {seq_busy}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {seq_busy}]
set_false_path\
    -from [list [get_ports {clk_stable}]\
           [get_ports {pwr_stable}]\
           [get_ports {req_idle}]\
           [get_ports {req_off}]\
           [get_ports {req_sleep}]\
           [get_ports {reset_n}]\
           [get_ports {retention_ready}]\
           [get_ports {wake_up}]]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0200 [get_ports {clk_gate_en}]
set_load -pin_load 0.0200 [get_ports {error}]
set_load -pin_load 0.0200 [get_ports {pwr_gate_en}]
set_load -pin_load 0.0200 [get_ports {reset_ctrl}]
set_load -pin_load 0.0200 [get_ports {retention_en}]
set_load -pin_load 0.0200 [get_ports {retention_restore}]
set_load -pin_load 0.0200 [get_ports {retention_save}]
set_load -pin_load 0.0200 [get_ports {seq_busy}]
set_load -pin_load 0.0200 [get_ports {dvfs_ctrl[1]}]
set_load -pin_load 0.0200 [get_ports {dvfs_ctrl[0]}]
set_load -pin_load 0.0200 [get_ports {pwr_state[1]}]
set_load -pin_load 0.0200 [get_ports {pwr_state[0]}]
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 6.0000 [current_design]
