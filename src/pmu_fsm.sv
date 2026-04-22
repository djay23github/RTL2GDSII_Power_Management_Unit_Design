// =============================================================================
// pmu_fsm.v  —  Power Management Unit FSM
// Technology : Sky130nm (OpenLane / OpenROAD compatible)
// Encoding   : One-hot (better for glitch immunity; easier CDC debug)
// Author     : Dhananjay Joshi
// =============================================================================


module pmu_fsm (
    input  wire        clk,
    input  wire        reset_n,

    // PMU requests (async, will be synchronised internally)
    input  wire        req_idle,
    input  wire        req_sleep,
    input  wire        req_off,
    input  wire        wake_up,

    // Feedback from power / clock management (async, will be synchronised)
    input  wire        pwr_stable,
    input  wire        clk_stable,
    input  wire        retention_ready,

    // Control outputs (all registered)
    output reg         clk_gate_en,
    output reg         pwr_gate_en,
    output reg         retention_en,
    output reg         retention_save,
    output reg         retention_restore,
    output reg  [1:0]  dvfs_ctrl,
    output reg         reset_ctrl,
    output reg  [1:0]  pwr_state,
    output reg         seq_busy,
    output reg         error
);

// ---------------------------------------------------------------------------
// State encoding — one-hot, 7 states
// ---------------------------------------------------------------------------
localparam integer N_STATES = 7;
localparam [N_STATES-1:0]
    ACTIVE    = 7'b000_0001,
    IDLE      = 7'b000_0010,
    SLEEP     = 7'b000_0100,
    OFF       = 7'b000_1000,
    SLEEP_ENT = 7'b001_0000,
    OFF_ENT   = 7'b010_0000,
    WAKE_UP   = 7'b100_0000;

reg [N_STATES-1:0] curr_state, next_state;

// ---------------------------------------------------------------------------
// 2-stage synchronisers for all async inputs
// ---------------------------------------------------------------------------
reg [3:0] req_sync1, req_sync2;  // {req_idle, req_sleep, req_off, wake_up}
reg [2:0] sts_sync1, sts_sync2;  // {pwr_stable, clk_stable, retention_ready}

wire req_idle_s     = req_sync2[3];
wire req_sleep_s    = req_sync2[2];
wire req_off_s      = req_sync2[1];
wire wake_up_s      = req_sync2[0];
wire pwr_stable_s   = sts_sync2[2];
wire clk_stable_s   = sts_sync2[1];
wire ret_ready_s    = sts_sync2[0];

always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        req_sync1 <= 4'b0;
        req_sync2 <= 4'b0;
        sts_sync1 <= 3'b0;
        sts_sync2 <= 3'b0;
    end else begin
        req_sync1 <= {req_idle, req_sleep, req_off, wake_up};
        req_sync2 <= req_sync1;
        sts_sync1 <= {pwr_stable, clk_stable, retention_ready};
        sts_sync2 <= sts_sync1;
    end
end

// ---------------------------------------------------------------------------
// Sequence timer — resets on every state entry
// ---------------------------------------------------------------------------
reg [7:0] seq_timer;

always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        seq_timer <= 8'h00;
    end else if (curr_state != next_state) begin
        seq_timer <= 8'h00;
    end else begin
        seq_timer <= seq_timer + 8'h01;
    end
end

// ---------------------------------------------------------------------------
// Next-state combinational logic
// ---------------------------------------------------------------------------
// Combinational shadow signals for seq_busy / error (registered on clock edge)
// next_seq_busy is derived from NEXT_STATE (not curr_state) so that seq_busy
// is aligned with all other registered outputs — it clears on the same cycle
// the state register captures the stable destination state.
reg next_error;
wire next_seq_busy = next_state[4] | next_state[5] | next_state[6];

always_comb begin
    next_state = curr_state;   // default: stay
    next_error = 1'b0;

    case (1'b1)  // one-hot case

        curr_state[0]: begin // ACTIVE
            if      (req_off_s  ) next_state = OFF_ENT;
            else if (req_sleep_s) next_state = SLEEP_ENT;
            else if (req_idle_s ) next_state = IDLE;
            // wake_up_s in ACTIVE is a no-op (already running)
        end

        curr_state[1]: begin // IDLE
            if      (wake_up_s  ) next_state = ACTIVE;
            else if (req_off_s  ) next_state = OFF_ENT;
            else if (req_sleep_s) next_state = SLEEP_ENT;
        end

        curr_state[2]: begin // SLEEP
            if      (wake_up_s) next_state = WAKE_UP;
            else if (req_off_s) next_state = OFF_ENT;
        end

        curr_state[3]: begin // OFF
            if (wake_up_s) next_state = WAKE_UP;
        end

        curr_state[4]: begin // SLEEP_ENT
            if (seq_timer >= 8'h03) begin
                if (ret_ready_s) begin
                    next_state = SLEEP;
                end else if (seq_timer >= 8'h0F) begin
                    next_state = ACTIVE;
                    next_error = 1'b1;
                end
            end
        end

        curr_state[5]: begin // OFF_ENT
            if (seq_timer >= 8'h05) begin
                next_state = OFF;
            end
        end

        curr_state[6]: begin // WAKE_UP
            if (pwr_stable_s && clk_stable_s) begin
                if (seq_timer >= 8'h03) begin
                    if (ret_ready_s) begin
                        next_state = ACTIVE;
                    end else if (seq_timer >= 8'h0F) begin
                        next_state = ACTIVE;
                        next_error = 1'b1;
                    end
                end
            end else if (seq_timer >= 8'h1F) begin
                next_state = ACTIVE;
                next_error = 1'b1;
            end
        end

        default: begin
            // Illegal one-hot — recover to ACTIVE
            next_state = ACTIVE;
            next_error = 1'b1;
        end
    endcase
end

// ---------------------------------------------------------------------------
// State register
// ---------------------------------------------------------------------------
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        curr_state <= ACTIVE;
    else
        curr_state <= next_state;
end

// ---------------------------------------------------------------------------
// Registered output logic  (Moore outputs only — based on curr_state)
// All outputs default to ACTIVE values; only overridden per state.
// ---------------------------------------------------------------------------
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        clk_gate_en      <= 1'b0;
        pwr_gate_en      <= 1'b0;
        retention_en     <= 1'b0;
        retention_save   <= 1'b0;
        retention_restore<= 1'b0;
        dvfs_ctrl        <= 2'b11;   // max performance
        reset_ctrl       <= 1'b0;
        pwr_state        <= 2'b00;
        seq_busy         <= 1'b0;
        error            <= 1'b0;
    end else begin
        // Register the combinational shadows
        seq_busy <= next_seq_busy;
        error    <= next_error;

        // Default: ACTIVE state outputs
        clk_gate_en      <= 1'b0;
        pwr_gate_en      <= 1'b0;
        retention_en     <= 1'b0;
        retention_save   <= 1'b0;
        retention_restore<= 1'b0;
        dvfs_ctrl        <= 2'b11;
        reset_ctrl       <= 1'b0;
        pwr_state        <= 2'b00;

        case (1'b1)

            next_state[0]: begin // ACTIVE (next)
                pwr_state <= 2'b00;
            end

            next_state[1]: begin // IDLE (next)
                pwr_state   <= 2'b01;
                clk_gate_en <= 1'b1;
            end

            next_state[2]: begin // SLEEP (next)
                pwr_state    <= 2'b10;
                clk_gate_en  <= 1'b1;
                pwr_gate_en  <= 1'b1;
                retention_en <= 1'b1;
                dvfs_ctrl    <= 2'b01;
            end

            next_state[3]: begin // OFF (next)
                pwr_state   <= 2'b11;
                clk_gate_en <= 1'b1;
                pwr_gate_en <= 1'b1;
                reset_ctrl  <= 1'b1;
            end

            next_state[4]: begin // SLEEP_ENT (next)
                pwr_state      <= 2'b10;
                retention_en   <= 1'b1;
                // Save retention during early phase of entry
                retention_save <= (seq_timer < 8'h02);
            end

            next_state[5]: begin // OFF_ENT (next)
                pwr_state      <= 2'b11;
                // Drain / save for first 2 cycles
                retention_save <= (seq_timer < 8'h02);
            end

            next_state[6]: begin // WAKE_UP (next)
                pwr_state         <= 2'b00;  // restoring
                // Assert reset while power ramps
                reset_ctrl        <= (seq_timer < 8'h01);
                // Restore retention in the middle window
                retention_restore <= (seq_timer >= 8'h01 && seq_timer < 8'h03);
                retention_en      <= (seq_timer >= 8'h01 && seq_timer < 8'h03);
            end

            default: begin
                pwr_state <= 2'b00;
            end
        endcase
    end
end

// ---------------------------------------------------------------------------
// Formal / lint helpers — expose internal state for black-box assertions
// ---------------------------------------------------------------------------
`ifdef FORMAL
    // Cover that all states are reachable
    always @(posedge clk) begin
        cover(curr_state == ACTIVE);
        cover(curr_state == IDLE);
        cover(curr_state == SLEEP);
        cover(curr_state == OFF);
        cover(curr_state == SLEEP_ENT);
        cover(curr_state == OFF_ENT);
        cover(curr_state == WAKE_UP);
    end
    // Stability: no output asserted in ACTIVE
    always @(posedge clk) begin
        if (curr_state == ACTIVE && !$past(!reset_n))
            assert(!clk_gate_en && !pwr_gate_en && !retention_en);
    end
    // seq_busy must be de-asserted in stable states
    always @(posedge clk) begin
        if ((curr_state == ACTIVE || curr_state == IDLE ||
             curr_state == SLEEP  || curr_state == OFF) && !$past(!reset_n))
            assert(!seq_busy);
    end
`endif

endmodule
