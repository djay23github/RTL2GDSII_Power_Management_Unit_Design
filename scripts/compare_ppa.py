"""
Compare the Power, Performance and Area across different
Librelane run tags. Print a summary table and saves to csv

"""

import sys
import csv
from pathlib import Path
from run_loader import (
    load_runs, get_metric, get_cfg, 
    TIMING_KEYS, AREA_KEYS, POWER_KEYS, DRV_KEYS, CLOCK_KEYS, ROUTING_KEYS, IR_DROP_KEYS, DRC_LVS_KEYS, PROJECT_NAME, DEFAULT_RUN_DIR
)


# Formatting helper functions
def _fmt(val, fmt_str, missing="-"):
    if val is None:
        return missing
    return fmt_str.format(val)

def _slack_color(ws):
    if ws is None:
        return "\033[90m"  # gray for missing
    elif ws < 0:
        return "\033[91m"  # red for negative slack
    elif ws < 0.5:
        return "\033[93m"  # yellow for low positive slack
    else:
        return "\033[92m"  # green for good slack
    
def _drc_color(count):
    if count is None:
        return "\033[90m"  # gray for missing
    elif count > 0:
        return "\033[91m"  # red for any DRC errors
    else:
        return "\033[92m"  # green for no DRC errors   

def _ir_drop_color(drop):
    if drop is None:
        return "\033[90m"  # gray for missing
    elif drop > 500:  # example threshold for high IR drop ( 100 uV = 0.1 mV )
        return "\033[91m"  # red for high IR drop
    else:
        return "\033[92m"  # green for acceptable IR drop     

RESET = "\033[0m"
BOLD  = "\033[1m"
CYAN  = "\033[96m"
GREY  = "\033[90m"

# Build row data for a run
def build_row(tag:str , run:dict) -> dict:
    m = run["metrics"]
    cfg = run["configs"]

    def gm(key):
        return m.get(key, None)

    # Timing
    setup_ws = gm(TIMING_KEYS["setup_ws"])
    hold_ws = gm(TIMING_KEYS["hold_ws"])
    setup_tns = gm(TIMING_KEYS["setup_tns"])
    hold_tns = gm(TIMING_KEYS["hold_tns"])
    setup_wns = gm(TIMING_KEYS["setup_wns"])
    hold_wns = gm(TIMING_KEYS["hold_wns"])
    setup_viol = gm(TIMING_KEYS["setup_viol"])
    hold_viol = gm(TIMING_KEYS["hold_viol"])

    # Clock
    skew_setup = gm(CLOCK_KEYS["skew_setup"])
    skew_hold = gm(CLOCK_KEYS["skew_hold"])
    clk_period = cfg.get("CLOCK_PERIOD")
    clk_port = cfg.get("CLOCK_PORT")
    freq_mhz = 1000 / clk_period if clk_period else None

    # Area
    # Note: we report cell area and instance count separately to avoid confusion with macro-heavy designs
    die_area = gm(AREA_KEYS["die_area"])
    core_area = gm(AREA_KEYS["core_area"])
    cell_area = gm(AREA_KEYS["cell_area"])
    num_cells = gm(AREA_KEYS["instance_count"])
    stdcell_count = gm(AREA_KEYS["stdcell_count"])
    macro_count = gm(AREA_KEYS["macro_count"])
    utilization = gm(AREA_KEYS["utilization"])

    # Power
    def mW(key):
        val = gm(POWER_KEYS[key])
        return val * 1000 if val is not None else None
    
    pwr_total = mW("power_mW")
    pwr_internal = mW("internal_pwr_mW")
    pwr_switching = mW("switching_pwr_mW")
    pwr_leakage = mW("leakage_pwr_mW")

    # Routing
    wirelength_um = gm(ROUTING_KEYS["wirelength_um"])
    wirelength_est = gm(ROUTING_KEYS["wirelength_est"])
    via_count = gm(ROUTING_KEYS["via_count"])
    drc_errors = gm(ROUTING_KEYS["drc_errors"])
    antenna_viols = gm(ROUTING_KEYS["antenna_viols"])

    # DRC/LVS
    magic_drc_count = gm(DRC_LVS_KEYS["magic_drc_count"])
    klayout_drc_count = gm(DRC_LVS_KEYS["klayout_drc_count"])
    lvs_count = gm(DRC_LVS_KEYS["lvs_count"])
    xor_diff = gm(DRC_LVS_KEYS["xor_diff"])
    disconn_pins = gm(DRC_LVS_KEYS["disconn_pins"]) 

    # IR Drop
    def uV(key):
        val = gm(IR_DROP_KEYS[key])
        return val * 1e6 if val is not None else None

    worst_ir_drop = uV("worst_ir_drop_uV")
    ir_drop_avg = uV("avg_ir_drop_uV")  

    # DRV
    max_slew_viols = gm(DRV_KEYS["max_slew_viols"])
    max_fanout_viols = gm(DRV_KEYS["max_fanout_viols"])
    max_cap_viols = gm(DRV_KEYS["max_cap_viols"])

    return {
        "tag": tag, 
        "clk_port": clk_port,
        "clk_period_ns": clk_period,
        "freq_mhz": freq_mhz,
        "die_area": die_area,
        "core_area": core_area,
        "cell_area": cell_area,
        "num_cells": num_cells,
        "stdcell_count": stdcell_count,
        "macro_count": macro_count,
        "utilization": utilization,
        "setup_ws": setup_ws,
        "hold_ws": hold_ws,
        "setup_tns": setup_tns,
        "hold_tns": hold_tns,
        "setup_wns": setup_wns,
        "hold_wns": hold_wns,
        "setup_viol": setup_viol,
        "hold_viol": hold_viol,
        "skew_setup": skew_setup,
        "skew_hold": skew_hold,
        "pwr_total": pwr_total,
        "pwr_internal": pwr_internal,
        "pwr_switching": pwr_switching,         
        "pwr_leakage": pwr_leakage,
        "wirelength_um": wirelength_um,
        "wirelength_est": wirelength_est,
        "via_count": via_count,
        "drc_errors": drc_errors,
        "antenna_viols": antenna_viols,
        "magic_drc_count": magic_drc_count,
        "klayout_drc_count": klayout_drc_count,
        "lvs_count": lvs_count,
        "xor_diff": xor_diff,
        "disconn_pins": disconn_pins,
        "worst_ir_drop": worst_ir_drop,
        "ir_drop_avg": ir_drop_avg,
        "max_slew_viols": max_slew_viols,
        "max_fanout_viols": max_fanout_viols,
        "max_cap_viols": max_cap_viols,
    }

def print_ppa_table(rows: list):
    tags = [r["tag"] for r in rows]
    col_w = max(len(t) for t in tags) + 2
 
    def header(title):
        print(f"\n{BOLD}{CYAN}{'─'*60} {title} {'─'*(90-len(title))}{RESET}")
 
    def row_line(label, values, fmt_str, unit="", color_fn=None):
        label_str = f"  {label:<28}"
        parts = []
        for v in values:
            formatted = _fmt(v, fmt_str)
            color = color_fn(v) if color_fn else ""
            parts.append(f"{color}{formatted:>{col_w}}{RESET}")
        print(f"{label_str}{''.join(parts)}  {GREY}{unit}{RESET}")
 
    # Tag header row
    print(f"\n{BOLD}{PROJECT_NAME} — PPA Comparison:")
    print(f"{'Metric':<28}" + "".join(f"{t:>{col_w}}" for t in tags))
    print(f"{'─'*28}" + ("─"*col_w)*len(rows))
 
    header("CONFIGURATION")
    row_line("Clock Period",      [r["clk_period_ns"] for r in rows], "{:.1f}", "ns")
    row_line("Clock Port",        [r["clk_port"]      for r in rows], "{}", "")
    row_line("Clock Frequency",         [r["freq_mhz"]      for r in rows], "{:.0f}", "MHz")
    row_line("Clock: Setup Skew",       [r["skew_setup"]    for r in rows], "{:.5f}", "ns", color_fn=_slack_color)
    row_line("Clock: Hold Skew",        [r["skew_hold"]     for r in rows], "{:.5f}", "ns", color_fn=_slack_color)

    header("DESIGN RULE VIOLATIONS")
    row_line("Max Slew Violations", [r["max_slew_viols"] for r in rows], "{:.0f}", "")
    row_line("Max Fanout Violations", [r["max_fanout_viols"] for r in rows], "{:.0f}", "")
    row_line("Max Capacitance Violations", [r["max_cap_viols"] for r in rows], "{:.0f}", "")

    header("TIMING (only 1 signoff corner: nom_tt_025C_1v80)")
    row_line("Setup WS",          [r["setup_ws"]   for r in rows], "{:.5f}", "ns", color_fn=_slack_color)
    row_line("Hold WS",           [r["hold_ws"]    for r in rows], "{:.5f}", "ns", color_fn=_slack_color)
    row_line("Setup TNS",         [r["setup_tns"]  for r in rows], "{:.5f}", "ns")
    row_line("Hold TNS",          [r["hold_tns"]   for r in rows], "{:.5f}", "ns")
    row_line("Setup Violations",  [r["setup_viol"]   for r in rows], "{:.0f}", "")
    row_line("Hold Violations",   [r["hold_viol"]    for r in rows], "{:.0f}", "")
 
    header("AREA")
    row_line("Die Area",          [r["die_area"]  for r in rows], "{:.4f}", "µm²")
    row_line("Cell Area",         [r["cell_area"] for r in rows], "{:.4f}", "µm²")
    row_line("Utilization",       [(r["utilization"] or 0)*100 if r["utilization"] else None for r in rows], "{:.3f}", "%")
    row_line("Cell Count",        [r["num_cells"]       for r in rows], "{:.0f}", "cells")
 
    header("POWER")
    row_line("Total Power",           [r["pwr_total"]  for r in rows], "{:.5f}", "mW")
    row_line("Internal Power",        [r["pwr_internal"]    for r in rows], "{:.5f}", "mW")
    row_line("Switching Power",       [r["pwr_switching"]     for r in rows], "{:.5f}", "mW")
    row_line("Leakage Power",         [r["pwr_leakage"]   for r in rows], "{:.5f}", "mW")
 
    header("ROUTING")
    row_line("Wirelength",        [r["wirelength_um"] for r in rows], "{:.2f}", "µm")
    row_line("Via Count",         [r["via_count"]     for r in rows], "{:.0f}", "")
    row_line("Antenna Violations",[r["antenna_viols"] for r in rows], "{:.0f}", "")
 
    header("DRC / SIGNOFF")
    row_line("Magic DRC Errors",  [r["magic_drc_count"]     for r in rows], "{:.0f}", "", color_fn=_drc_color)
    row_line("KLayout DRC Errors",[r["klayout_drc_count"]   for r in rows], "{:.0f}", "", color_fn=_drc_color)
    row_line("LVS Errors",       [r["lvs_count"]     for r in rows], "{:.0f}", "", color_fn=_drc_color)
    row_line("XOR Differences",   [r["xor_diff"]      for r in rows], "{:.0f}", "", color_fn=_drc_color)

    header("IR DROP")
    row_line("Worst IR Drop",     [r["worst_ir_drop"] for r in rows], "{:.4f}", "mV", color_fn=_ir_drop_color)
    row_line("Average IR Drop",   [r["ir_drop_avg"]   for r in rows], "{:.4f}", "mV", color_fn=_ir_drop_color)
    print()
 
 
def export_csv(rows: list, out_path: Path):
    if not rows:
        return
    fieldnames = list(rows[0].keys())
    with open(out_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    print(f"\nCSV file saved to {out_path}")

 
if __name__ == "__main__":
    args = sys.argv[1:]
    runs_dir = Path(args[0]) if args else Path(DEFAULT_RUN_DIR)
    tags = args[1:] if len(args) > 1 else None
 
    print(f"\n{'='*64}")
    print(f"  PPA Comparison between Runs")
    print(f"  Runs dir: {runs_dir.resolve()}")
    print(f"{'='*64}")
 
    runs = load_runs(runs_dir, run_tags=tags)
    if not runs:
        sys.exit(1)
 
    rows = [build_row(tag, run) for tag, run in runs.items()]
    print_ppa_table(rows)
    export_csv(rows, runs_dir / "ppa_comparison_table.csv")