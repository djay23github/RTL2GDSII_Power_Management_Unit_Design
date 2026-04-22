# Power Management Unit FSM - PMU FSM
This module implemements a simple Power Management Unit (PMU) Finite State Machine designed for ASIC flow (can be integrated with an SoC for educational learning purposes). It controls power states, clock gating, retention and wake-up sequencing in a robust and synthesis friendly manner. It is not a production ready module yet.

# Table of Contents:
* [Design Overview](#1-design-overview)
* [Power States](#2-power-states)
* [State Encoding](#3-state-encoding)
* [CDC Handling](#4-cdc-handling)
* [Sequencing Mechanism](#5-sequencing-mechanism)
* [State Transition Logic](#6-state-transition-logic)
* [Output Control Signals](#7-output-control-signals)
* [PD Flow](#8-pd-flow)

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

## 8. PD Flow

