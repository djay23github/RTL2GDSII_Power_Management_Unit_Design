"""
Parses OpenSTA timing reports from LibreLane run directories.
Covers:
  1. Setup/Hold WS evolution through flow stages (pre-PnR → post-route → signoff)
  2. Per-corner signoff slack summary (all 9 sky130 corners)
  3. Critical path parsing from .rpt files (start/end point, path delay)
  4. Clock skew summary
"""

import sys
import re
import json
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any
from run_loader import load_runs, TIMING_KEYS, CLOCK_KEYS, RESET, BOLD, CYAN, GREY, DEFAULT_RUN_DIR


# sky130 multi-corner library as defined in the PDK (nom/min/max × PVT corners)
SKY130_CORNERS = [
    "max_ff_n40C_1v95",
    "max_tt_025C_1v80",
    "max_ss_100C_1v60",
    "min_ff_n40C_1v95",
    "min_tt_025C_1v80",
    "min_ss_100C_1v60",
    "nom_tt_025C_1v80",
    "nom_ff_n40C_1v95",
    "nom_ss_100C_1v60",
]

# Corner type annotation (setup-critical vs hold-critical)
CORNER_TYPE = {
    "nom_tt_025C_1v80": "nominal",
    "nom_ff_n40C_1v95": "setup-critical (fast)",
    "nom_ss_100C_1v60": "hold-critical (slow)",
    "min_ff_n40C_1v95": "min-setup",
    "min_tt_025C_1v80": "min-nominal",
    "min_ss_100C_1v60": "min-hold",
    "max_ff_n40C_1v95": "max-setup",
    "max_tt_025C_1v80": "max-nominal",
    "max_ss_100C_1v60": "max-hold (worst case)",
}

ANSI_RED    = "\033[91m"
ANSI_GREEN  = "\033[92m"
ANSI_YELLOW = "\033[93m"


def find_sta_dirs(run_dir: Path) -> Dict[str, Path]:
    """
    Returns dict of known STA step names to their directories.
    """
    sta_dirs = {}
    step_pattern = re.compile(r"^\d+-(.+)$")

    for d in sorted(run_dir.iterdir()):
        if not d.is_dir():
            continue
        m = step_pattern.match(d.name)
        if not m:
            continue
        step_id = m.group(1).lower()
        if "staprepnr" in step_id:
            sta_dirs["pre_pnr"] = d
        if "31-openroad-stamidpnr" in step_id:
            sta_dirs["mid_pnr"] = d
        if "-stamidpnr-1" in step_id:
            sta_dirs["post_cts"] = d
        if "-stamidpnr-3" in step_id:
            sta_dirs["post_global_route"] = d
        if "stapostpnr" in step_id:
            sta_dirs["signoff"] = d

    return sta_dirs



def parse_step_timing(step_dir: Path) -> Dict[str, Optional[float]]:
    """Extract timing metrics from a step's state_out.json."""
    sout = step_dir / "state_out.json"
    if not sout.exists():
        return {}
    with open(sout) as f:
        data = json.load(f)
    m = data.get("metrics", {})
    return {
        "setup_ws":  m.get(TIMING_KEYS["setup_ws"]),
        "hold_ws":   m.get(TIMING_KEYS["hold_ws"]),
        "setup_tns": m.get(TIMING_KEYS["setup_tns"]),
        "hold_tns":  m.get(TIMING_KEYS["hold_tns"]),
        "setup_skew": m.get(CLOCK_KEYS["skew_setup"]),
        "hold_skew":  m.get(CLOCK_KEYS["skew_hold"]),
    }


def parse_sta_report(rpt_path: Path) -> Optional[Dict]:
    """
    Parse a checks.rpt or timing.rpt file from OpenSTA.
    Extracts the worst path: start point, end point, slack, data arrival time.

    OpenSTA report format example:
    Startpoint: req_sync2[0] (rising edge-triggered flip-flop)
    Endpoint:   curr_state_reg[0] (rising edge-triggered flip-flop)
    ...
    slack (MET)     3.141
    """
    if not rpt_path.exists():
        return None

    text = rpt_path.read_text(errors="replace")
    result = {
        "path":       str(rpt_path),
        "start":      None,
        "end":        None,
        "slack":      None,
        "slack_type": None,
        "data_path":  None,  # total data path delay
        "clock_path": None,  # clock network delay
    }

    # Startpoint
    m = re.search(r"Startpoint:\s+(\S+)", text)
    if m:
        result["start"] = m.group(1)

    # Endpoint
    m = re.search(r"Endpoint:\s+(\S+)", text)
    if m:
        result["end"] = m.group(1)

    # Slack and type (MET / VIOLATED)
    m = re.search(r"([-\d.]+)\s+slack\s+\((MET|VIOLATED)\)", text)
    if m:
        result["slack_type"] = m.group(2)
        result["slack"]      = float(m.group(1))

    # Data arrival time (last line before slack in a typical OpenSTA report)
    m = re.search(r"([-\d.]+)\s+data arrival time", text)
    if m:
        result["data_path"] = float(m.group(1))

    # Clock path delay
    m = re.search(r"([-\d.]+)\s+data required time", text)
    if m:
        result["clock_path"] = float(m.group(1))

    return result


def get_corner_slacks(signoff_dir: Path) -> Dict[str, Dict]:
    """
    Walk signoff_dir/<corner>/... and extract setup/hold WS per corner.
    Also parses the worst path for each corner.
    """
    corner_data = {}
    
    for corner in SKY130_CORNERS:
        cdir = signoff_dir / corner
        if not cdir.exists():
            continue

        setup_ws = None
        hold_ws  = None
        worst_setup_path = None
        worst_hold_path  = None

        for fname in ["max.rpt"]:
            rpt = cdir / fname
            if rpt.exists():
                parsed = parse_sta_report(rpt)
                if parsed and parsed['slack'] is not None:
                    setup_ws = parsed["slack"]
                    worst_setup_path = parsed
                    break

        for fname in ["min.rpt"]:
            rpt = cdir / fname
            if rpt.exists():
                parsed = parse_sta_report(rpt)
                if parsed and parsed["slack"] is not None:
                    hold_ws = parsed["slack"]
                    worst_hold_path = parsed
                    break

        corner_data[corner] = {
            "setup_ws":         setup_ws,
            "hold_ws":          hold_ws,
            "worst_setup_path": worst_setup_path,
            "worst_hold_path":  worst_hold_path,
        }

    return corner_data


def print_timing_evolution(tag: str, run: dict):
    print(f"\n{BOLD}{CYAN}─────────────────Timing Evolution: {tag} ─────────────────────────{RESET}")

    sta_dirs = find_sta_dirs(run["path"])

    stage_order = ["pre_pnr", "mid_pnr", "post_cts", "post_global_route", "signoff"]
    stage_labels = {
        "pre_pnr":    "Pre-PnR  (ideal clk)",
        "mid_pnr":    "Mid-PnR  (ideal clk)",
        "post_cts":   "Post-CTS (prop. clk)",
        "post_global_route": "Post-Route",
        "signoff":    "Signoff  (SPEF)",
    }

    header = f"  {'Stage':<26} {'Setup WS':>12} {'Hold WS':>12} {'Setup TNS':>12} {'Hold TNS':>12} {'Setup Skew':>10} {'Hold Skew':>10}"
    print(header)
    print(f"  {'─'*26} {'─'*12} {'─'*12} {'─'*12} {'─'*12} {'─'*10} {'─'*10}")

    for stage in stage_order:
        sdir = sta_dirs.get(stage)
        if sdir is None:
            continue
        t = parse_step_timing(sdir)
        # if not t:
        #     # Fall back to run-level step_metrics
        #     t = run["step_metrics"].get(sdir.name, {}) if sdir else {}

        ws  = t.get("setup_ws")
        hws = t.get("hold_ws")
        tns = t.get("setup_tns")
        htns = t.get("hold_tns")
        skw = t.get("skew_setup")
        hskw = t.get("skew_hold")

        def fmt_slack(v):
            if v is None:
                return f"{GREY}{'—':>12}{RESET}"
            color = ANSI_GREEN if v >= 0 else ANSI_RED
            if 0 <= v < 0.3:
                color = ANSI_YELLOW
            return f"{color}{v:>+12.3f}{RESET}"

        label = stage_labels[stage]
        tns_str = f"{tns:>12.3f}" if tns is not None else f"{GREY}{'—':>12}{RESET}"
        htns_str = f"{htns:>12.3f}" if htns is not None else f"{GREY}{'—':>12}{RESET}"
        skw_str = f"{skw:>10.3f}" if skw is not None else f"{GREY}{'—':>10}{RESET}"
        hskw_str = f"{hskw:>10.3f}" if hskw is not None else f"{GREY}{'—':>10}{RESET}"
        print(f"  {label:<26}{fmt_slack(ws)}{fmt_slack(hws)}{tns_str}{htns_str}{skw_str}{hskw_str}")


def print_corner_table(tag: str, run: dict):
    print(f"\n{BOLD}{CYAN}────────────────── Per-Corner Signoff Slack: {tag} ──────────────────{RESET}")

    sta_dirs = find_sta_dirs(run["path"])
    signoff_dir = sta_dirs.get("signoff")

    if signoff_dir is None:
        # Try to get from final step metrics keyed by corner
        print(f"{GREY}No dedicated signoff STA step found — using metrics.json values{RESET}")
        m = run["metrics"]
        ws = m.get(TIMING_KEYS["setup_ws"])
        hw = m.get(TIMING_KEYS["hold_ws"])
        if ws is None or hw is None:
            print(f"{GREY}No timing metrics found in run-level metrics.json{RESET}")
            return
        print(f"  Aggregated worst: setup WS = {ws:.3f} ns, hold WS = {hw:.3f} ns")
        return

    corner_data = get_corner_slacks(signoff_dir)

    if not corner_data:
        print(f"{GREY}No per-corner reports found in {signoff_dir}{RESET}")
        return

    print(f"  {'Corner':<28} {'Type':<24} {'Setup WS':>10} {'Hold WS':>10}  {'Status'}")
    print(f"  {'─'*28} {'─'*24} {'─'*10} {'─'*10}  {'─'*10}")

    for corner in SKY130_CORNERS:
        cd = corner_data.get(corner)
        if cd is None:
            continue

        sws = cd["setup_ws"]
        hws = cd["hold_ws"]
        ctype = CORNER_TYPE.get(corner, "")

        def fmt_ws(v):
            if v is None:
                return f"{GREY}{'—':>10}{RESET}"
            color = ANSI_GREEN if v >= 0 else ANSI_RED
            if 0 <= v < 0.3:
                color = ANSI_YELLOW
            return f"{color}{v:>+10.3f}{RESET}"

        passing = (sws is None or sws >= 0) and (hws is None or hws >= 0)
        status  = f"{ANSI_GREEN}PASS{RESET}" if passing else f"{ANSI_RED}FAIL{RESET}"
        print(f"  {corner:<28} {ctype:<24}{fmt_ws(sws)}{fmt_ws(hws)}  {status}")


def print_critical_paths(tag: str, run: dict):
    print(f"\n{BOLD}{CYAN}────────────────── Critical Path Details: {tag} ─────────────────────{RESET}")

    sta_dirs = find_sta_dirs(run["path"])
    signoff_dir = sta_dirs.get("signoff") or sta_dirs.get("post_route")
    if not signoff_dir:
        print(f"{GREY}No STA step directory found{RESET}")
        return

    # Try nominal corner first, then any available
    target_corners = ["nom_tt_025C_1v80"] + SKY130_CORNERS
    for corner in target_corners:
        reports_dir = signoff_dir / corner
        if not reports_dir.exists():
            continue

        for fname in ["min.rpt"]:
            rpt = reports_dir / fname
            if rpt.exists():
                parsed = parse_sta_report(rpt)
                if parsed and parsed["start"]:
                    print(f"  Corner: {corner}")
                    print(f"  {'Startpoint':<18}: {parsed['start']}")
                    print(f"  {'Endpoint':<18}: {parsed['end']}")
                    slack = parsed['slack']
                    if slack is not None:
                        color = ANSI_GREEN if slack >= 0 else ANSI_RED
                        print(f"  {'Slack':<18}: {color}{slack:+.3f} ns{RESET} "
                              f"({parsed['slack_type']})")
                    if parsed["data_path"]:
                        print(f"  {'Data arrival':<18}: {parsed['data_path']:.3f} ns")
                    if parsed["clock_path"]:
                        print(f"  {'Data Required':<18}: {parsed['clock_path']:.3f} ns")
                    print()
                    return  # Just print the first one found
    print(f"  {GREY}No timing reports found{RESET}")

if __name__ == "__main__":
    args = sys.argv[1:]
    runs_dir = Path(args[0]) if args else Path(DEFAULT_RUN_DIR)
    tags = args[1:] if len(args) > 1 else None

    print(f"\n{'='*64}")
    print(f"  Timing Analysis")
    print(f"  Runs dir: {runs_dir.resolve()}")
    print(f"{'='*64}")

    runs = load_runs(runs_dir, run_tags=tags)
    if not runs:
        sys.exit(1)

    for tag, run in runs.items():
        print_timing_evolution(tag, run)
        print_corner_table(tag, run)
        print_critical_paths(tag, run)

    print()