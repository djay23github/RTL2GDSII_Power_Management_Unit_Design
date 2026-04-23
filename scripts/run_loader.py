"""
Script to parse the run directories in LibreLane

Librelane Directory Structure:
- my_designs/
  - pmu_fsm/
    - config.yaml
    - src/
    - verify/
    - runs/
        - <RUN_TAG>/
            - resolved.json
            - final/
                - metrics.json
            - NN-<step-name>/
                - state_in.json
                - state_out.json
                - config.json
                - *.log

"""

import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Any

PROJECT_NAME = "pmu_fsm"
DEFAULT_RUN_DIR = Path(f"my_designs/{PROJECT_NAME}/runs")

def find_run_directories(base_dir: Path) -> List[Path]:
    """Find all run directories under the base directory."""

    if not base_dir.exists():
        print(f"[Error]: Base directory {base_dir} does not exist.", file=sys.stderr)
        sys.exit(1)
    
    return sorted([d for d in base_dir.iterdir() if d.is_dir() and not d.name.startswith('.')])


def load_metrics(run_dir: Path) -> Dict[str, Any]:
    """ Load final metrics from the run directory """
    metrics = {}
    metrics_path = run_dir / "final" / "metrics.json"
    if not metrics_path.exists():
        print(f"[Warning]: Metrics file {metrics_path} not found for run {run_dir.name}. Skipping.", file=sys.stderr)
        return {}
    
    with open(metrics_path, 'r') as f:
        return json.load(f)
    
    return metrics
    
def load_configs(run_dir: Path) -> Dict[str, Any]:
    """ Load config files from the run directory """
    configs = {}
    cfg_path = run_dir / "resolved.json"
    if cfg_path.exists():
        with open(cfg_path, 'r') as f:
            return json.load(f)
    
    return configs

def load_step_metrics(run_dir: Path) -> Dict[str, Dict[str, Any]]:
    """ Load metrics for each step in the run directory """
    step_metrics = {}
    step_dirs = sorted([d for d in run_dir.iterdir() if d.is_dir() and re.match(r"^\d+", d.name)], key=lambda d: int(re.match(r"^(\d+)", d.name).group(1)))

    for step_dir in step_dirs:
        state_out = step_dir / "state_out.json"
        if state_out.exists():
            with open(state_out, 'r') as f:
                data = json.load(f)
                m = data.get("metrics", {})
                if m:
                    step_metrics[step_dir.name] = m
    
    return step_metrics

def load_runs(base_dir: str | Path = DEFAULT_RUN_DIR, 
              run_tags: Optional[List[str]] = None) -> Dict[str, Any]:
    """ Load all runs and their metrics/configs from the base directory """

    base_dir = Path(base_dir)
    run_dirs = find_run_directories(base_dir)
    
    if not run_dirs:
        print(f"[Error]: No run directories found in {base_dir}.", file=sys.stderr)
        sys.exit(1)

    if run_tags:
        run_dirs = [d for d in run_dirs if d.name in run_tags]
        if not run_dirs:
            print(f"[Error]: No matching run directories found for tags: {run_tags}", file=sys.stderr)
            sys.exit(1)

    runs_data = {}
    for rd in run_dirs:
        print(f"Loading run: {rd.name}....")
        metrics = load_metrics(rd)
        configs = load_configs(rd)
        step_metrics = load_step_metrics(rd)

        runs_data[rd.name] = {
            "run_tag": rd.name,
            "path"  : rd,
            "metrics": metrics,
            "configs": configs,
            "step_metrics": step_metrics
        }

        print(f" Loaded {len(runs_data)} run(s)")
    
    return runs_data


RESET   = "\033[0m"
BOLD    = "\033[1m"
CYAN    = "\033[96m"
GREY    = "\033[90m"

def get_metric(run: Dict, key:str, default:None):
    return run["metrics"].get(key, default)

def get_cfg(run: Dict, key:str, default:None):
    return run["configs"].get(key, default)


AREA_KEYS = {
    "die_area":        "design__die__area",           # um^2
    "core_area":       "design__core__area",          # um^2
    "cell_area":       "design__instance__area",      # um^2
    "instance_count":  "design__instance__count",
    "stdcell_count":   "design__instance__count__stdcell",
    "macro_count":    "design__instance__count__macros",
    "utilization":     "design__instance__utilization",  # 0.0 - 1.0
}

DRV_KEYS = {
    "max_slew_viols" : "design__max_slew_violation__count",
    "max_fanout_viols": "design__max_fanout_violation__count",
    "max_cap_viols": "design__max_cap_violation__count",
}

TIMING_KEYS = {
    "setup_ws":        "timing__setup__ws",          # worst slack setup (ns)
    "hold_ws":         "timing__hold__ws",            # worst slack hold (ns)
    "setup_tns":       "timing__setup__tns",          # total neg slack setup
    "hold_tns":        "timing__hold__tns",
    "setup_wns":       "timing__setup__wns",
    "hold_wns":        "timing__hold__wns",
    "setup_viol":      "timing__setup_vio__count",
    "hold_viol":       "timing__hold_vio__count",
 
}

CLOCK_KEYS = {
    "skew_setup":      "clock__skew__worst_setup",
    "skew_hold":       "clock__skew__worst_hold",   
}

POWER_KEYS = {
    "internal_pwr_mW":    "power__internal__total",             # mW
    "switching_pwr_mW":   "power__switching__total",            # mW
    "leakage_pwr_mW":     "power__leakage__total",              # mW
    "power_mW":           "power__total",                      # mW

}

ROUTING_KEYS = {   
    "wirelength_um":   "route__wirelength",
    "wirelength_est":  "route__wirelength__estimated",
    "drc_errors":      "route__drc_errors",
    "antenna_viols":   "route__antenna_violation__count",
    "via_count":       "route__vias",

}

DRC_LVS_KEYS = {
    "magic_drc_count":       "magic__drc_error__count",
    "klayout_drc_count":     "klayout__drc_error__count",
    "xor_diff":        "design__xor_difference__count",
    "disconn_pins":    "design__disconnected_pin__count",
    "lvs_count":             "design__lvs_error__count",
}

IR_DROP_KEYS = {
    "avg_ir_drop_uV":   "ir__drop__avg",                     # mV
    "worst_ir_drop_uV": "ir__drop__worst",                   # mV
}

if __name__ == "__main__":
    runs_dir = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_RUN_DIR
    print(f"Loading runs from: {runs_dir}" )
    runs = load_runs(runs_dir)
    for tag, run in runs.items():
        print(f"\n      {tag}")
        print(f"        Metrics Keys: {len(run['metrics'])}")
        print(f"        Configs Keys: {len(run['configs'])}")
        print(f"        Step Metrics Keys: {len(run['step_metrics'])}")


