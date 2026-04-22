// =============================================================================
// tb_pmu_fsm.sv  —  PMU FSM Testbench (SystemVerilog)
// Compatible with: Icarus Verilog 11+, Verilator, VCS, Xcelium
// =============================================================================

`timescale 1ns/1ps
/* verilator lint_off UNUSED */
module tb_pmu;

    // Minimum cycles to hold a request signal so it propagates through:
    //   cycle 1: sync_stage1 captures
    //   cycle 2: sync_stage2 captures (req_*_s visible)
    //   cycle 3: next_state computed
    //   cycle 4: curr_state register updates
    //   +1 margin
    localparam int SYNC_HOLD = 5;

    // -------------------------------------------------------------------------
    // DUT ports
    // -------------------------------------------------------------------------
    logic        clk;
    logic        reset_n;
    logic        req_idle, req_sleep, req_off, wake_up;
    logic        pwr_stable, clk_stable, retention_ready;

    wire         clk_gate_en, pwr_gate_en, reset_ctrl, retention_en;
    wire         retention_save, retention_restore;
    wire  [1:0]  dvfs_ctrl, pwr_state;
    wire         seq_busy, error;

    pmu_fsm dut (
        .clk              (clk),
        .reset_n          (reset_n),
        .req_idle         (req_idle),
        .req_sleep        (req_sleep),
        .req_off          (req_off),
        .wake_up          (wake_up),
        .pwr_stable       (pwr_stable),
        .clk_stable       (clk_stable),
        .retention_ready  (retention_ready),
        .clk_gate_en      (clk_gate_en),
        .pwr_gate_en      (pwr_gate_en),
        .retention_en     (retention_en),
        .retention_save   (retention_save),
        .retention_restore(retention_restore),
        .dvfs_ctrl        (dvfs_ctrl),
        .reset_ctrl       (reset_ctrl),
        .pwr_state        (pwr_state),
        .seq_busy         (seq_busy),
        .error            (error)
    );

    wire [6:0] curr_state_raw = dut.curr_state;

    // -------------------------------------------------------------------------
    // Clock 100 MHz
    // -------------------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever begin
            #5 clk = ~clk;
        end
    end
    integer test_count  = 0;
    integer error_count = 0;

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------
    function automatic string state_name(input logic [6:0] s);
        case (s)
            7'b000_0001: return "ACTIVE";
            7'b000_0010: return "IDLE";
            7'b000_0100: return "SLEEP";
            7'b000_1000: return "OFF";
            7'b001_0000: return "SLEEP_ENT";
            7'b010_0000: return "OFF_ENT";
            7'b100_0000: return "WAKE_UP";
            default:     return "ILLEGAL";
        endcase
    endfunction

    task automatic do_reset();
        reset_n         = 1'b0;
        req_idle        = 1'b0;
        req_sleep       = 1'b0;
        req_off         = 1'b0;
        wake_up         = 1'b0;
        pwr_stable      = 1'b1;
        clk_stable      = 1'b1;
        retention_ready = 1'b1;
        repeat (5) @(posedge clk);
        @(negedge clk);
        reset_n = 1'b1;
        repeat (4) @(posedge clk);
        $display("[RESET]  done — state: %s", state_name(curr_state_raw));
    endtask

    task automatic wait_for_state(input logic [6:0] target, input int timeout_cycles);
        int cnt = 0;
        while (curr_state_raw !== target && cnt < timeout_cycles) begin
            @(posedge clk);
            cnt++;
        end
        if (curr_state_raw !== target) begin
            $display("[TIMEOUT] Waiting for %s, stuck in %s after %0d cycles",
                     state_name(target), state_name(curr_state_raw), timeout_cycles);
            error_count++;
        end
    endtask

    task automatic check_state(input logic [6:0] expected, input string msg);
        test_count++;
        if (curr_state_raw !== expected) begin
            $display("[FAIL] %s  expected=%s  got=%s",
                     msg, state_name(expected), state_name(curr_state_raw));
            error_count++;
        end else
            $display("[PASS] %s  state=%s", msg, state_name(expected));
    endtask

    task automatic check_out(input string lbl, input logic actual, input logic expected);
        test_count++;
        if (actual !== expected) begin
            $display("[FAIL]   %s = %b  (expected %b)", lbl, actual, expected);
            error_count++;
        end else
            $display("[PASS]   %s = %b", lbl, actual);
    endtask

    task automatic check_out2(input string lbl, input logic [1:0] actual, input logic [1:0] expected);
        test_count++;
        if (actual !== expected) begin
            $display("[FAIL]   %s = %02b  (expected %02b)", lbl, actual, expected);
            error_count++;
        end else
            $display("[PASS]   %s = %02b", lbl, actual);
    endtask

    // Drive a single-bit signal for SYNC_HOLD cycles on negedge-aligned boundaries.
    // This guarantees propagation through both synchroniser FFs and state register.
    `define DRIVE(sig, val, hold) \
        @(negedge clk); sig = val; \
        repeat(hold) @(posedge clk); \
        @(negedge clk); sig = 1'b0;

    // =========================================================================
    // TEST 1: Reset
    // =========================================================================
    task automatic test_reset;
        $display("\n--- TEST 1: Reset asserts ACTIVE ---");
        do_reset();
        check_state(7'b000_0001, "Post-reset state");
        check_out("clk_gate_en",  clk_gate_en,  1'b0);
        check_out("pwr_gate_en",  pwr_gate_en,  1'b0);
        check_out("retention_en", retention_en, 1'b0);
        check_out("reset_ctrl",   reset_ctrl,   1'b0);
        check_out2("pwr_state",   pwr_state,    2'b00);
        check_out("seq_busy",     seq_busy,     1'b0);
        check_out("error",        error,        1'b0);
    endtask

    // =========================================================================
    // TEST 2: ACTIVE → IDLE
    // =========================================================================
    task automatic test_active_to_idle;
        $display("\n--- TEST 2: ACTIVE -> IDLE ---");
        do_reset();
        @(negedge clk); req_idle = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_idle = 1'b0;
        repeat(2) @(posedge clk);
        check_state(7'b000_0010, "ACTIVE -> IDLE");
        check_out("clk_gate_en in IDLE",  clk_gate_en,  1'b1);
        check_out("pwr_gate_en in IDLE",  pwr_gate_en,  1'b0);
        check_out2("pwr_state in IDLE",   pwr_state,    2'b01);
        check_out("seq_busy in IDLE",     seq_busy,     1'b0);
    endtask

    // =========================================================================
    // TEST 3: IDLE → ACTIVE via wake_up
    // =========================================================================
    task automatic test_idle_to_active;
        $display("\n--- TEST 3: IDLE -> ACTIVE via wake_up ---");
        do_reset();
        @(negedge clk); req_idle = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_idle = 1'b0;
        wait_for_state(7'b000_0010, 15);

        @(negedge clk); wake_up = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); wake_up = 1'b0;
        repeat(2) @(posedge clk);
        check_state(7'b000_0001, "IDLE -> ACTIVE");
        check_out("clk_gate_en cleared", clk_gate_en, 1'b0);
        check_out2("pwr_state back 00",  pwr_state,   2'b00);
    endtask

    // =========================================================================
    // TEST 4: ACTIVE → SLEEP_ENT → SLEEP (happy path)
    // =========================================================================
    task automatic test_sleep_happy;
        $display("\n--- TEST 4: ACTIVE -> SLEEP_ENT -> SLEEP ---");
        do_reset();
        retention_ready = 1'b1;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        // Should be in SLEEP_ENT now (timer already running)
        check_state(7'b001_0000, "ACTIVE -> SLEEP_ENT");
        check_out("seq_busy in SLEEP_ENT",    seq_busy,     1'b1);
        check_out("retention_en in SLEEP_ENT",retention_en, 1'b1);
        // Timer is already >= SYNC_HOLD > 3, ret_ready_s=1 -> should
        // have transitioned or will in 1-2 cycles
        wait_for_state(7'b000_0100, 10);
        check_state(7'b000_0100, "SLEEP_ENT -> SLEEP");
        check_out("clk_gate_en in SLEEP",  clk_gate_en,  1'b1);
        check_out("pwr_gate_en in SLEEP",  pwr_gate_en,  1'b1);
        check_out("retention_en in SLEEP", retention_en, 1'b1);
        check_out("seq_busy cleared",      seq_busy,     1'b0);
        check_out2("pwr_state in SLEEP",   pwr_state,    2'b10);
    endtask

    // =========================================================================
    // TEST 5: SLEEP_ENT timeout
    // =========================================================================
    task automatic test_sleep_ent_timeout;
        $display("\n--- TEST 5: SLEEP_ENT timeout -> ACTIVE + error ---");
        do_reset();
        retention_ready = 1'b0;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        check_state(7'b001_0000, "In SLEEP_ENT");
        // Timer starts from ~SYNC_HOLD on entry. Timeout fires at 8'h0F=15.
        // So wait at most 15 + SYNC_HOLD + margin = 25 cycles.
        wait_for_state(7'b000_0001, 25);
        check_state(7'b000_0001, "SLEEP_ENT timeout -> ACTIVE");
        check_out("error on timeout", error, 1'b1);
        repeat(3) @(posedge clk);
        check_out("error clears in ACTIVE", error, 1'b0);
        retention_ready = 1'b1;
    endtask

    // =========================================================================
    // TEST 6: ACTIVE → OFF_ENT → OFF
    // =========================================================================
    task automatic test_off_path;
        $display("\n--- TEST 6: ACTIVE -> OFF_ENT -> OFF ---");
        do_reset();
        @(negedge clk); req_off = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_off = 1'b0;
        check_state(7'b010_0000, "ACTIVE -> OFF_ENT");
        check_out("seq_busy in OFF_ENT", seq_busy, 1'b1);
        // OFF_ENT exits at timer >= 8'h05 = 5. Timer is already at ~SYNC_HOLD.
        wait_for_state(7'b000_1000, 15);
        check_state(7'b000_1000, "OFF_ENT -> OFF");
        check_out("clk_gate_en in OFF",  clk_gate_en, 1'b1);
        check_out("pwr_gate_en in OFF",  pwr_gate_en, 1'b1);
        check_out("reset_ctrl in OFF",   reset_ctrl,  1'b1);
        check_out2("pwr_state in OFF",   pwr_state,   2'b11);
        check_out("seq_busy cleared",    seq_busy,    1'b0);
    endtask

    // =========================================================================
    // TEST 7: OFF → WAKE_UP → ACTIVE
    // =========================================================================
    task automatic test_wake_from_off;
        $display("\n--- TEST 7: OFF -> WAKE_UP -> ACTIVE ---");
        do_reset();
        pwr_stable = 1'b1; clk_stable = 1'b1; retention_ready = 1'b1;
        @(negedge clk); req_off = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_off = 1'b0;
        wait_for_state(7'b000_1000, 20);

        @(negedge clk); wake_up = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); wake_up = 1'b0;
        check_state(7'b100_0000, "OFF -> WAKE_UP");
        check_out("seq_busy in WAKE_UP", seq_busy, 1'b1);
        // pwr_stable=1, clk_stable=1, ret_ready=1, timer already >= 3 -> quick exit
        wait_for_state(7'b000_0001, 20);
        check_state(7'b000_0001, "WAKE_UP -> ACTIVE");
        check_out("seq_busy cleared", seq_busy, 1'b0);
        check_out("error clear",      error,    1'b0);
    endtask

    // =========================================================================
    // TEST 8: SLEEP → OFF_ENT escalation
    // =========================================================================
    task automatic test_sleep_to_off;
        $display("\n--- TEST 8: SLEEP -> OFF_ENT escalation ---");
        do_reset();
        retention_ready = 1'b1;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        wait_for_state(7'b000_0100, 20);
        check_state(7'b000_0100, "Setup: in SLEEP");

        @(negedge clk); req_off = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_off = 1'b0;
        repeat(2) @(posedge clk);
        check_state(7'b010_0000, "SLEEP -> OFF_ENT");
    endtask

    // =========================================================================
    // TEST 9: Priority — simultaneous req_off + req_sleep → OFF_ENT
    // =========================================================================
    task automatic test_priority;
        $display("\n--- TEST 9: Priority: req_off + req_sleep -> OFF_ENT ---");
        do_reset();
        @(negedge clk);
        req_sleep = 1'b1;
        req_off   = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk);
        req_sleep = 1'b0;
        req_off   = 1'b0;
        repeat(2) @(posedge clk);
        check_state(7'b010_0000, "req_off wins over req_sleep");
    endtask

    // =========================================================================
    // TEST 10: Reset mid-sequence
    // =========================================================================
    task automatic test_reset_mid_seq;
        $display("\n--- TEST 10: Reset during SLEEP_ENT ---");
        do_reset();
        retention_ready = 1'b0;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        check_state(7'b001_0000, "Setup: in SLEEP_ENT");

        @(negedge clk); reset_n = 1'b0;
        repeat(4) @(posedge clk);
        @(negedge clk); reset_n = 1'b1;
        repeat(5) @(posedge clk);  // sync chains recover
        check_state(7'b000_0001, "Mid-seq reset -> ACTIVE");
        check_out("clk_gate_en cleared", clk_gate_en, 1'b0);
        check_out("seq_busy cleared",    seq_busy,    1'b0);
        check_out("error cleared",       error,       1'b0);
        retention_ready = 1'b1;
    endtask

    // =========================================================================
    // TEST 11: WAKE_UP hard timeout (pwr_stable=0)
    // =========================================================================
    task automatic test_wake_pwr_timeout;
        $display("\n--- TEST 11: WAKE_UP hard timeout (pwr_stable=0) ---");
        do_reset();
        retention_ready = 1'b1;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        wait_for_state(7'b000_0100, 25);

        @(negedge clk); pwr_stable = 1'b0; clk_stable = 1'b0;
        repeat(4) @(posedge clk);

        @(negedge clk); wake_up = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); wake_up = 1'b0;
        check_state(7'b100_0000, "In WAKE_UP, pwr_stable=0");

        // Hard timeout = 8'h1F = 31 cycles from WAKE_UP entry
        wait_for_state(7'b000_0001, 50);
        check_state(7'b000_0001, "WAKE_UP timeout -> ACTIVE");
        check_out("error on pwr timeout", error, 1'b1);

        @(negedge clk); pwr_stable = 1'b1; clk_stable = 1'b1;
        repeat(5) @(posedge clk);
        check_out("error clears after", error, 1'b0);
    endtask

    // =========================================================================
    // TEST 12: dvfs_ctrl encoding
    // =========================================================================
    task automatic test_dvfs_ctrl;
        $display("\n--- TEST 12: dvfs_ctrl encoding ---");
        do_reset();
        check_out2("dvfs_ctrl in ACTIVE", dvfs_ctrl, 2'b11);
        retention_ready = 1'b1;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        wait_for_state(7'b000_0100, 25);
        repeat(2) @(posedge clk);
        check_out2("dvfs_ctrl in SLEEP", dvfs_ctrl, 2'b01);
    endtask

    // =========================================================================
    // TEST 13: retention_save window in SLEEP_ENT
    // =========================================================================
    task automatic test_retention_save;
        $display("\n--- TEST 13: retention_save window in SLEEP_ENT ---");
        do_reset();
        retention_ready = 1'b1;
        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        check_state(7'b001_0000, "In SLEEP_ENT");
        // Timer entered SLEEP_ENT at cycle 3 of the SYNC_HOLD window.
        // At end of SYNC_HOLD (cycle 5): seq_timer=1, retention_save still 1.
        // Need 1 more posedge so seq_timer reaches 2 and retention_save captures 0.
        repeat(2) @(posedge clk);
        check_out("retention_save past window=0", retention_save, 1'b0);
        check_out("retention_en still active=1",  retention_en,   1'b1);
    endtask

    // =========================================================================
    // TEST 14: IDLE → SLEEP_ENT direct
    // =========================================================================
    task automatic test_idle_to_sleep;
        $display("\n--- TEST 14: IDLE -> SLEEP_ENT direct ---");
        do_reset();
        @(negedge clk); req_idle = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_idle = 1'b0;
        wait_for_state(7'b000_0010, 15);
        check_state(7'b000_0010, "Setup: in IDLE");

        @(negedge clk); req_sleep = 1'b1;
        repeat(SYNC_HOLD) @(posedge clk);
        @(negedge clk); req_sleep = 1'b0;
        repeat(2) @(posedge clk);
        check_state(7'b001_0000, "IDLE -> SLEEP_ENT");
    endtask

    // =========================================================================
    // Run all tests
    // =========================================================================
    initial begin
        $dumpfile("tb_pmu.vcd");
        $dumpvars(0, tb_pmu);
        $display("============== PMU FSM Testbench   ===============");
        $display("Timestamp: %0t ns\n", $time);

        test_reset();
        test_active_to_idle();
        test_idle_to_active();
        test_sleep_happy();
        test_sleep_ent_timeout();
        test_off_path();
        test_wake_from_off();
        test_sleep_to_off();
        test_priority();
        test_reset_mid_seq();
        test_wake_pwr_timeout();
        test_dvfs_ctrl();
        test_retention_save();
        test_idle_to_sleep();

        $display("\n========================================");
        $display("  Tests executed : %0d", test_count);
        $display("  Failures       : %0d", error_count);
        $display("========================================");
        if (error_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** %0d TEST(S) FAILED ***", error_count);
        $display("========================================\n");
        $finish;
    end

    initial begin
        #200_000;
        $display("[WATCHDOG] Exceeded 200 us.");
        $finish;
    end

`ifdef SV_ASSERTIONS
    property p_one_hot;
        @(posedge clk) disable iff (!reset_n)
        $onehot(curr_state_raw);
    endproperty
    assert property (p_one_hot)
        else $error("[SVA] State not one-hot: %07b at %0t", curr_state_raw, $time);

    property p_busy_stable;
        @(posedge clk) disable iff (!reset_n)
        (curr_state_raw inside {7'b000_0001, 7'b000_0010,
                                 7'b000_0100, 7'b000_1000})
        |-> !seq_busy;
    endproperty
    assert property (p_busy_stable)
        else $error("[SVA] seq_busy in stable state %s", state_name(curr_state_raw));

    property p_ret_before_pwr;
        @(posedge clk) disable iff (!reset_n)
        $fell(pwr_gate_en) |-> !retention_en;
    endproperty
    assert property (p_ret_before_pwr)
        else $error("[SVA] pwr_gate fell while retention_en=1 at %0t", $time);

    property p_error_clears;
        @(posedge clk) disable iff (!reset_n)
        (curr_state_raw == 7'b000_0001) |-> ##[0:3] !error;
    endproperty
    assert property (p_error_clears)
        else $error("[SVA] error stuck in ACTIVE at %0t", $time);
`endif

endmodule
