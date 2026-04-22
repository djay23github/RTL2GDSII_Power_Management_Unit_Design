# Power Management Unit FSM - Design
This module implemements a simple Power Management Unit (PMU) Finite State Machine designed for ASIC flow (can be integrated with an SoC for educational learning purposes). It controls power states, clock gating, retention and wake-up sequencing in a robust and synthesis friendly manner. It is not a production ready module yet.

# Table of Contents:
1. [Design Overview](#1-design-overview)
2. [Power States](#2-power-states)
3. [State Encoding](#3-state-encoding)
4. [CDC Handling](#4-cdc-handling)
5. [Sequencing Mechanism](#5-sequencing-mechanism)
6. [State Transition Logic](#6-state-transition-logic)
7. [Output Control Signals](#7-output-control-signals)
8. [Testbench Overview](#1-testbench-overview)
9. [DUT Integration](#2-dut-integration)
10. [Clock and Reset](#3-clock-and-reset)
11. [CDC-Aware Stimulus](#4-cdc-aware-stimulus)
12. [Helper Tasks](#5-helper-tasks)
13. [Functional Test Coverage](#6-functional-test-coverage)
14. [How to Run](#7-how-to-run)



 ## 1. Design Overview
 The pmu_fsm coordinates transitions between multiple power modes based on system requests and hardware readiness signals. It is build with:
 * One-hot state encoding - minimizing decoding glitches and improving timing closure
 * Moore machine to avoid combinational hazards
 * all sync inputs are synchronized
 * Deterministic sequencing using timer to ensure safe power transitions

 ## 2. Power States
 The FSM currently supports 7 states: 
| State         | Description |
| --------      | -------- |
| `ACTIVE`      | Full Performance Mode   |
| `IDLE`        | Power On, clock-gated   |
| `SLEEP`       | Power gated with retention   |
| `OFF`         | Full shutdown   |
| `SLEEP_ENT`   | Entry sequence into sleep  |
| `OFF_ENT`     | Entry sequence into off   |
| `WAKE_UP`     | Power/clock restoration sequence   |


**Key idea :**

Entry and wake-up states are explicitly modeled to safely handle sequencing (not merged into main states).

## 3. State Encoding

* One-hot encoding (7-bit)
* Exactly one bit active at any time
* Provides:
    * Simpler combinational logic
    * Better glitch immunity
    * Easier debug and formal verification

## 4. CDC Handling

All async inputs are synchronized using a 2-stage FF syncrhonizer.

* Requests: 
    * `req_idle, req_sleep, req_off, wake_up`
* Status signals: 
    * `pwr_stable, clk_stable, retention_ready`

This prevents metastabilty propagation into the FSM

## 5. Sequencing Mechanism

A `seq_timer` is used to control multi-cycle transitions: 

* Resets on every state transition
* Increments every clock cycle otherwise
* Used to:
    * Delay transitions
    * Time retention save/restore
    * Detect timeout errors

Example:

* Sleep entry waits for retention readiness
* Wake-up waits for power + clock stability

## 6. State Transition Logic
Transitions are determined by: 
* External requests (idle/sleep/off/wake)
* Hardware readiness signals
* Timer thresholds

**Key behaviors :**
* **ACTIVE &rarr; IDLE / SLEEP / OFF**
  * Priority: OFF > SLEEP > IDLE
* **SLEEP_ENT**
  * Wait for `retention_ready`
  * Timeout &rarr; return to ACTIVE + error
* **OFF_ENT**
  * Fixed delay before entering OFF
* **WAKE_UP**
  * Wait for:
    * `pwr_stable`
    * `clk_stable`
  * Restore retention
  * Timeout &rarr; force ACTIVE + error
* **Illegal state recovery**
  * Any invalid encoding &rarr; reset to ACTIVE with error flag

## 7. Output Control Signals

All outputs are registered **(glitch-free)** and derived from the `next state` for alignment.

**Key outputs:**
* **Clock / Power Control**
  * `clk_gate_en`
  * `pwr_gate_en`
* Retention Control
  * `retention_en`
  * `retention_save`
  * `retention_restore`
* DVFS Control
  * `dvfs_ctrl`
  * `11` &rarr; high performance
  * `01` &rarr; low power (sleep)
* Reset Control
  * `reset_ctrl` asserted during **OFF** and early **WAKE_UP**
* State Encoding Output
  * `pwr_state` (2-bit external encoding)
* Status Flags
  * `seq_busy` &rarr; high during transitional states
  * `error` &rarr; timeout or illegal condition detected


# Verification

The testbench [tb_pmu.sv](verify/tb_pmu.sv) provides a comprehensive **functional verification environment** for the [pmu_fsm](src/pmu_fsm.sv) RTL. It is designed to be portable across simulators (Icarus Verilog, Verilator, VCS, Xcelium) and focuses on correctness, robustness, and corner-case validation.

## 1. Testbench Overview

Key Characteristics: 
* Self-checking testbench (no manual waveform inspection required)
* Covers all state transitions, including edge and failure cases
* Models realistic asynchronous behavior using synchronized stimulus
* Includes optional SystemVerilog Assertions (SVA) for formal-like checks
* Generates VCD waveforms for debugging

## 2. DUT Integration

The testbench instantiates the `pmu_fsm` as the DUT:

* All inputs are driven as `logic`
* Outputs are observed via `wire`
* Internal state (`curr_state`) is accessed for verification:

```sv 
wire [6:0] curr_state_raw = dut.curr_state;
```

This enables direct validation of FSM state transitions.

## 3. Clock and Reset
* Clock: 100 MHz (`10 ns period`)
* Reset:
  * Active-low (`reset_n`)
  * Synchronous release after stabilization cycles

```sv
forever #5 clk = ~clk;
```

Reset sequencing ensures:
* Synchronizer pipelines are flushed
* FSM starts deterministically in `ACTIVE`

## 4. CDC-Aware Stimulus

Because the DUT uses **2-stage synchronizers**, inputs must be held long enough to propagate:

```sv
localparam int SYNC_HOLD = 5;
```

This ensures:
* Stage 1 capture
* Stage 2 capture
* Next-state computation
* State register update

A macro simplifies safe stimulus driving:

```sv
`DRIVE(signal, value, hold_cycles)
```

## 5. Helper Tasks

* **Reset handling**
  * `do_reset()`
* **State checking**
  * `check_state(expected, message)`
* **Output checking**
  * `check_out() (1-bit)`
  * `check_out2() (multi-bit)`
* **Wait with timeout**
  * `wait_for_state(target, timeout_cycles)`

Scoreboarding
  * `test_count` &rarr; total checks executed
  * `error_count` &rarr; number of failures

Provides a final pass/fail summary.

## 6. Functional Test Coverage

The testbench includes **14** directed test scenarios:

* Basic Functionality
  * Reset behavior
    * Ensures FSM starts in `ACTIVE`
    * Verifies all outputs are in default state
  * `ACTIVE` &rarr; `IDLE`
  * `IDLE` &rarr; `ACTIVE (wake-up)`
  * Sleep Path
    * `ACTIVE` &rarr; `SLEEP_ENT` &rarr; `SLEEP (normal case)`
    * SLEEP_ENT timeout
      * Missing `retention_ready`
      * Forces recovery to `ACTIVE` + `$error`
  * Power-Off Path
    * `ACTIVE` &rarr; `OFF_ENT` &rarr; `OFF`
    * `OFF` &rarr; `WAKE_UP` &rarr; `ACTIVE` 
  * `SLEEP` &rarr; `OFF` escalation; `req_off` overrrides `req_sleep`
  * `WAKE_UP` timeout
  * DVFS control encoding
  * Retention Save Window
  * `IDLE` &rarr; `SLEEP` direct transition

* Waveform Dump - Can view using GTKWave or Verdi

```sv
$dumpfile("verify/tb_pmu.vcd");
$dumpvars(0, tb_pmu);
```

## 7. How to Run

**Icarus Verilog**
```bash
iverilog -g2012 src/pmu_fsm.v verify/tb_pmu.sv -o verify/sim.out
vvp verify/sim.out
gtkwave verify/tb_pmu.vcd
```

**Verilator**
```bash
verilator --binary -j 0 -Wall --trace --timing --timescale 1ns/1ps -o pmu_sim src/pmu_fsm.sv verify/tb_pmu.sv
./obj_dir/pmu_sim
gtkwave verify/tb_pmu.vcd
```