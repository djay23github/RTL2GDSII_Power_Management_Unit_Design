module pmu_fsm (clk,
    clk_gate_en,
    clk_stable,
    error,
    pwr_gate_en,
    pwr_stable,
    req_idle,
    req_off,
    req_sleep,
    reset_ctrl,
    reset_n,
    retention_en,
    retention_ready,
    retention_restore,
    retention_save,
    seq_busy,
    wake_up,
    dvfs_ctrl,
    pwr_state);
 input clk;
 output clk_gate_en;
 input clk_stable;
 output error;
 output pwr_gate_en;
 input pwr_stable;
 input req_idle;
 input req_off;
 input req_sleep;
 output reset_ctrl;
 input reset_n;
 output retention_en;
 input retention_ready;
 output retention_restore;
 output retention_save;
 output seq_busy;
 input wake_up;
 output [1:0] dvfs_ctrl;
 output [1:0] pwr_state;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire _086_;
 wire _087_;
 wire _088_;
 wire _089_;
 wire _090_;
 wire _091_;
 wire _092_;
 wire _093_;
 wire _094_;
 wire _095_;
 wire _096_;
 wire _097_;
 wire _098_;
 wire _099_;
 wire _100_;
 wire _101_;
 wire _102_;
 wire _103_;
 wire _104_;
 wire _105_;
 wire _106_;
 wire _107_;
 wire _108_;
 wire _109_;
 wire _110_;
 wire _111_;
 wire _112_;
 wire _113_;
 wire _114_;
 wire _115_;
 wire _116_;
 wire _117_;
 wire _118_;
 wire _119_;
 wire _120_;
 wire _121_;
 wire _122_;
 wire _123_;
 wire _124_;
 wire _125_;
 wire _126_;
 wire _127_;
 wire _128_;
 wire _129_;
 wire _130_;
 wire _131_;
 wire _132_;
 wire _133_;
 wire _134_;
 wire _135_;
 wire _136_;
 wire _137_;
 wire _138_;
 wire _139_;
 wire _140_;
 wire _141_;
 wire _142_;
 wire _143_;
 wire _144_;
 wire net9;
 wire net1;
 wire clk_stable_s;
 wire \curr_state[0] ;
 wire \curr_state[1] ;
 wire \curr_state[2] ;
 wire \curr_state[3] ;
 wire \curr_state[4] ;
 wire \curr_state[5] ;
 wire \curr_state[6] ;
 wire clknet_0_clk;
 wire net10;
 wire net11;
 wire next_error;
 wire next_seq_busy;
 wire \next_state[0] ;
 wire \next_state[1] ;
 wire \next_state[2] ;
 wire \next_state[3] ;
 wire \next_state[4] ;
 wire \next_state[5] ;
 wire \next_state[6] ;
 wire net12;
 wire net2;
 wire pwr_stable_s;
 wire net13;
 wire net14;
 wire net3;
 wire req_idle_s;
 wire net4;
 wire req_off_s;
 wire net5;
 wire req_sleep_s;
 wire \req_sync1[0] ;
 wire \req_sync1[1] ;
 wire \req_sync1[2] ;
 wire \req_sync1[3] ;
 wire net15;
 wire net6;
 wire ret_ready_s;
 wire net16;
 wire net7;
 wire net17;
 wire net18;
 wire net19;
 wire \seq_timer[0] ;
 wire \seq_timer[1] ;
 wire \seq_timer[2] ;
 wire \seq_timer[3] ;
 wire \seq_timer[4] ;
 wire \seq_timer[5] ;
 wire \seq_timer[6] ;
 wire \seq_timer[7] ;
 wire \sts_sync1[0] ;
 wire \sts_sync1[1] ;
 wire \sts_sync1[2] ;
 wire net8;
 wire wake_up_s;
 wire net20;
 wire net21;
 wire net22;
 wire net23;
 wire net24;
 wire net25;
 wire net26;
 wire net27;
 wire net28;
 wire net29;
 wire net30;
 wire net31;
 wire net32;
 wire net33;
 wire net34;
 wire net35;
 wire net36;
 wire net37;
 wire net38;
 wire net39;
 wire net40;
 wire net41;
 wire net42;
 wire net43;
 wire net44;
 wire net45;
 wire net46;
 wire net47;
 wire net48;
 wire net49;
 wire net50;
 wire net51;
 wire net52;
 wire net53;
 wire net54;
 wire net55;
 wire net56;
 wire net57;
 wire net58;
 wire net;
 wire clknet_3_0__leaf_clk;
 wire clknet_3_1__leaf_clk;
 wire clknet_3_2__leaf_clk;
 wire clknet_3_3__leaf_clk;
 wire clknet_3_4__leaf_clk;
 wire clknet_3_5__leaf_clk;
 wire clknet_3_6__leaf_clk;
 wire clknet_3_7__leaf_clk;
 wire net59;
 wire net60;
 wire net61;
 wire net62;
 wire net63;
 wire net64;
 wire net65;
 wire net66;
 wire net67;
 wire net68;
 wire net69;
 wire net70;
 wire net71;
 wire net72;
 wire net73;
 wire net74;
 wire net75;
 wire net76;
 wire net77;
 wire net78;
 wire net79;
 wire net80;
 wire net81;
 wire net82;
 wire net83;

 sky130_fd_sc_hd__decap_3 FILLER_0_100 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_141 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_144 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_147 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_25 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_51 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_65 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_68 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_117 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_120 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_149 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_152 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_155 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_41 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_44 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_50 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_85 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_94 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_97 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_103 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_123 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_126 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_129 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_146 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_149 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_152 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_155 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_23 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_26 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_63 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_80 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_86 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_89 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_11 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_127 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_139 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_141 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_144 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_147 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_19 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_45 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_63 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_94 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_101 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_104 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_132 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_135 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_17 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_20 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_23 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_63 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_109 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_112 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_129 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_132 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_135 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_138 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_149 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_15 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_152 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_155 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_26 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_43 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_46 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_49 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_65 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_68 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_94 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_109 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_11 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_116 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_134 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_34 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_37 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_43 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_46 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_49 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_84 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_87 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_122 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_125 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_128 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_131 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_141 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_153 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_156 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_50 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_88 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_100 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_128 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_131 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_134 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_137 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_140 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_143 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_146 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_149 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_152 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_155 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_16 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_49 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_52 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_108 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_134 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_137 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_141 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_144 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_147 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_156 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_16 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_19 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_22 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_108 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_111 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_127 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_135 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_19 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_22 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_84 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_87 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_90 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_102 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_108 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_119 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_122 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_145 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_148 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_16 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_19 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_43 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_46 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_49 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_93 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_99 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_119 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_141 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_144 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_154 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_32 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_53 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_72 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_82 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_119 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_25 ();
 sky130_fd_sc_hd__fill_2 FILLER_21_28 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_104 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_107 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_154 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_25 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_62 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_65 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_104 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_23_110 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_126 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_148 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_43 ();
 sky130_fd_sc_hd__decap_3 FILLER_23_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_110 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_25 ();
 sky130_fd_sc_hd__fill_2 FILLER_24_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_3 ();
 sky130_fd_sc_hd__fill_2 FILLER_24_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_24_79 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_101 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_104 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_25_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_116 ();
 sky130_fd_sc_hd__fill_2 FILLER_25_119 ();
 sky130_fd_sc_hd__fill_2 FILLER_25_155 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_44 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_25_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_95 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_100 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_103 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_113 ();
 sky130_fd_sc_hd__fill_2 FILLER_26_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_134 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_37 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_51 ();
 sky130_fd_sc_hd__fill_2 FILLER_26_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_26_97 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_137 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_25 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_51 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_88 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_110 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_113 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_41 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_44 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_47 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_64 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_72 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_84 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_119 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_122 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_125 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_132 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_135 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_138 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_149 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_152 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_155 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_25 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_51 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_72 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_85 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_88 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_132 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_135 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_27 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_125 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_128 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_3 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_32 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_59 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_62 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_65 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_68 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_95 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_123 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_154 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_31 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_67 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_70 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_73 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_76 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_79 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_102 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_117 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_120 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_150 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_153 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_156 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_19 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_52 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_58 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_61 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_64 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_67 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_70 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_73 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_93 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_99 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_11 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_119 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_154 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_55 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_80 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_83 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Left_27 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Left_37 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Left_38 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Right_11 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Left_39 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Right_12 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Left_40 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Right_13 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Left_41 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Right_14 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Left_42 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Right_15 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Left_43 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Right_16 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Left_44 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Right_17 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Left_45 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Right_18 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Left_46 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Right_19 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Left_28 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_20_Left_47 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_20_Right_20 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_21_Left_48 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_21_Right_21 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_22_Left_49 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_22_Right_22 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_23_Left_50 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_23_Right_23 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_24_Left_51 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_24_Right_24 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_25_Left_52 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_25_Right_25 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_26_Left_53 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_26_Right_26 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Left_29 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Left_30 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Left_31 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Left_32 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Left_33 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Left_34 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Left_35 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Left_36 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_84 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_85 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_86 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_87 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_88 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_89 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_90 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_91 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_92 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_93 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_94 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_95 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_96 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_97 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_98 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_100 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_99 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_101 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_102 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_103 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_104 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_105 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_106 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_107 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_108 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_21_109 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_21_110 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_111 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_112 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_113 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_23_114 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_23_115 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_116 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_117 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_118 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_25_119 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_25_120 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_121 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_122 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_123 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_124 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_125 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_80 ();
 sky130_fd_sc_hd__nor2b_2 _145_ (.A(net31),
    .B_N(net45),
    .Y(_097_));
 sky130_fd_sc_hd__inv_2 _146_ (.A(net41),
    .Y(_098_));
 sky130_fd_sc_hd__nor3_4 _147_ (.A(\seq_timer[6] ),
    .B(\seq_timer[7] ),
    .C(\seq_timer[5] ),
    .Y(_099_));
 sky130_fd_sc_hd__nand4_2 _148_ (.A(net33),
    .B(\seq_timer[3] ),
    .C(net35),
    .D(net37),
    .Y(_100_));
 sky130_fd_sc_hd__inv_2 _149_ (.A(ret_ready_s),
    .Y(_101_));
 sky130_fd_sc_hd__inv_2 _150_ (.A(\seq_timer[4] ),
    .Y(_102_));
 sky130_fd_sc_hd__nand4_2 _151_ (.A(net26),
    .B(_100_),
    .C(_101_),
    .D(net25),
    .Y(_103_));
 sky130_fd_sc_hd__a21oi_2 _152_ (.A1(net35),
    .A2(net37),
    .B1(net33),
    .Y(_104_));
 sky130_fd_sc_hd__inv_2 _153_ (.A(\seq_timer[3] ),
    .Y(_105_));
 sky130_fd_sc_hd__nand4_4 _154_ (.A(net26),
    .B(_104_),
    .C(net25),
    .D(_105_),
    .Y(_106_));
 sky130_fd_sc_hd__and2_2 _155_ (.A(clk_stable_s),
    .B(pwr_stable_s),
    .X(_107_));
 sky130_fd_sc_hd__nand3_2 _156_ (.A(_103_),
    .B(_106_),
    .C(_107_),
    .Y(_108_));
 sky130_fd_sc_hd__nand2_2 _157_ (.A(clk_stable_s),
    .B(pwr_stable_s),
    .Y(_109_));
 sky130_fd_sc_hd__nand2_2 _158_ (.A(net33),
    .B(\seq_timer[3] ),
    .Y(_110_));
 sky130_fd_sc_hd__nand3_2 _159_ (.A(\seq_timer[4] ),
    .B(net35),
    .C(net37),
    .Y(_111_));
 sky130_fd_sc_hd__o21ai_2 _160_ (.A1(_110_),
    .A2(_111_),
    .B1(net26),
    .Y(_112_));
 sky130_fd_sc_hd__nand2_2 _161_ (.A(_109_),
    .B(_112_),
    .Y(_113_));
 sky130_fd_sc_hd__a31o_2 _162_ (.A1(_108_),
    .A2(_113_),
    .A3(\curr_state[6] ),
    .B1(net39),
    .X(_114_));
 sky130_fd_sc_hd__nand2_2 _163_ (.A(_098_),
    .B(_114_),
    .Y(_115_));
 sky130_fd_sc_hd__a31o_2 _164_ (.A1(net26),
    .A2(_100_),
    .A3(net25),
    .B1(ret_ready_s),
    .X(_116_));
 sky130_fd_sc_hd__a211oi_2 _165_ (.A1(_116_),
    .A2(net41),
    .B1(\curr_state[3] ),
    .C1(net43),
    .Y(_117_));
 sky130_fd_sc_hd__a21oi_2 _166_ (.A1(_115_),
    .A2(_117_),
    .B1(net45),
    .Y(_118_));
 sky130_fd_sc_hd__nand2b_2 _167_ (.A_N(net29),
    .B(net48),
    .Y(_119_));
 sky130_fd_sc_hd__or3_2 _168_ (.A(req_idle_s),
    .B(net27),
    .C(_119_),
    .X(_120_));
 sky130_fd_sc_hd__buf_1 _169_ (.A(_120_),
    .X(_121_));
 sky130_fd_sc_hd__o31a_2 _170_ (.A1(net49),
    .A2(_097_),
    .A3(_118_),
    .B1(_121_),
    .X(_122_));
 sky130_fd_sc_hd__inv_2 _171_ (.A(_122_),
    .Y(\next_state[0] ));
 sky130_fd_sc_hd__o21bai_2 _172_ (.A1(net49),
    .A2(_097_),
    .B1_N(net29),
    .Y(_123_));
 sky130_fd_sc_hd__nor2_2 _173_ (.A(net47),
    .B(req_idle_s),
    .Y(_124_));
 sky130_fd_sc_hd__or3_2 _174_ (.A(net27),
    .B(_123_),
    .C(_124_),
    .X(_125_));
 sky130_fd_sc_hd__buf_1 _175_ (.A(_125_),
    .X(_126_));
 sky130_fd_sc_hd__inv_2 _176_ (.A(net23),
    .Y(\next_state[1] ));
 sky130_fd_sc_hd__inv_2 _177_ (.A(req_idle_s),
    .Y(_127_));
 sky130_fd_sc_hd__inv_2 _178_ (.A(net27),
    .Y(_128_));
 sky130_fd_sc_hd__and4b_2 _179_ (.A_N(net29),
    .B(_127_),
    .C(_128_),
    .D(net49),
    .X(_129_));
 sky130_fd_sc_hd__inv_2 _180_ (.A(net43),
    .Y(_130_));
 sky130_fd_sc_hd__inv_2 _181_ (.A(\curr_state[3] ),
    .Y(_131_));
 sky130_fd_sc_hd__and4_2 _182_ (.A(net24),
    .B(_130_),
    .C(net41),
    .D(ret_ready_s),
    .X(_132_));
 sky130_fd_sc_hd__nand2_2 _183_ (.A(_132_),
    .B(_106_),
    .Y(_133_));
 sky130_fd_sc_hd__or3_4 _184_ (.A(net31),
    .B(net30),
    .C(_130_),
    .X(_134_));
 sky130_fd_sc_hd__a21o_2 _185_ (.A1(net45),
    .A2(net27),
    .B1(net48),
    .X(_135_));
 sky130_fd_sc_hd__a221oi_4 _186_ (.A1(net46),
    .A2(_130_),
    .B1(_133_),
    .B2(_134_),
    .C1(_135_),
    .Y(_136_));
 sky130_fd_sc_hd__a21oi_2 _187_ (.A1(net44),
    .A2(_129_),
    .B1(net22),
    .Y(_137_));
 sky130_fd_sc_hd__inv_2 _188_ (.A(_137_),
    .Y(\next_state[2] ));
 sky130_fd_sc_hd__o22a_2 _189_ (.A1(net43),
    .A2(net45),
    .B1(net29),
    .B2(net24),
    .X(_138_));
 sky130_fd_sc_hd__nor2_2 _190_ (.A(_135_),
    .B(_138_),
    .Y(_139_));
 sky130_fd_sc_hd__o21ai_2 _191_ (.A1(net36),
    .A2(net38),
    .B1(net33),
    .Y(_140_));
 sky130_fd_sc_hd__nand4_2 _192_ (.A(net26),
    .B(_140_),
    .C(net25),
    .D(_105_),
    .Y(_141_));
 sky130_fd_sc_hd__and2_2 _193_ (.A(net24),
    .B(net39),
    .X(_142_));
 sky130_fd_sc_hd__nor2_2 _194_ (.A(net31),
    .B(net24),
    .Y(_143_));
 sky130_fd_sc_hd__a31o_2 _195_ (.A1(_141_),
    .A2(_142_),
    .A3(_098_),
    .B1(_143_),
    .X(_144_));
 sky130_fd_sc_hd__o2bb2a_4 _196_ (.A1_N(_139_),
    .A2_N(_144_),
    .B1(_121_),
    .B2(net24),
    .X(_017_));
 sky130_fd_sc_hd__inv_4 _197_ (.A(_017_),
    .Y(\next_state[3] ));
 sky130_fd_sc_hd__nand2_2 _198_ (.A(_103_),
    .B(_106_),
    .Y(_018_));
 sky130_fd_sc_hd__o31ai_2 _199_ (.A1(net32),
    .A2(net24),
    .A3(net43),
    .B1(_134_),
    .Y(_019_));
 sky130_fd_sc_hd__a31o_2 _200_ (.A1(_131_),
    .A2(_130_),
    .A3(_018_),
    .B1(_019_),
    .X(_020_));
 sky130_fd_sc_hd__nor2_2 _201_ (.A(net45),
    .B(net82),
    .Y(_021_));
 sky130_fd_sc_hd__nor2_2 _202_ (.A(net27),
    .B(_127_),
    .Y(_022_));
 sky130_fd_sc_hd__or4b_2 _203_ (.A(net31),
    .B(net30),
    .C(net48),
    .D_N(net45),
    .X(_023_));
 sky130_fd_sc_hd__o21ai_2 _204_ (.A1(_119_),
    .A2(_022_),
    .B1(_023_),
    .Y(_024_));
 sky130_fd_sc_hd__or2_2 _205_ (.A(net41),
    .B(net28),
    .X(_025_));
 sky130_fd_sc_hd__a32oi_2 _206_ (.A1(_020_),
    .A2(_021_),
    .A3(net41),
    .B1(_024_),
    .B2(_025_),
    .Y(_026_));
 sky130_fd_sc_hd__inv_2 _207_ (.A(_026_),
    .Y(\next_state[4] ));
 sky130_fd_sc_hd__a31o_2 _208_ (.A1(net40),
    .A2(_127_),
    .A3(_128_),
    .B1(_119_),
    .X(_027_));
 sky130_fd_sc_hd__o21ba_2 _209_ (.A1(net39),
    .A2(net30),
    .B1_N(net32),
    .X(_028_));
 sky130_fd_sc_hd__a21oi_2 _210_ (.A1(_141_),
    .A2(_098_),
    .B1(\curr_state[3] ),
    .Y(_029_));
 sky130_fd_sc_hd__nand3_2 _211_ (.A(_103_),
    .B(_106_),
    .C(net42),
    .Y(_030_));
 sky130_fd_sc_hd__o2bb2ai_2 _212_ (.A1_N(_029_),
    .A2_N(_030_),
    .B1(_131_),
    .B2(net32),
    .Y(_031_));
 sky130_fd_sc_hd__and2_2 _213_ (.A(_130_),
    .B(net39),
    .X(_032_));
 sky130_fd_sc_hd__a22oi_2 _214_ (.A1(net43),
    .A2(_028_),
    .B1(_031_),
    .B2(_032_),
    .Y(_033_));
 sky130_fd_sc_hd__a21o_2 _215_ (.A1(_128_),
    .A2(net40),
    .B1(net29),
    .X(_034_));
 sky130_fd_sc_hd__a21oi_2 _216_ (.A1(_034_),
    .A2(_097_),
    .B1(net49),
    .Y(_035_));
 sky130_fd_sc_hd__o21ai_2 _217_ (.A1(net47),
    .A2(_033_),
    .B1(_035_),
    .Y(_036_));
 sky130_fd_sc_hd__nand2_2 _218_ (.A(_027_),
    .B(net21),
    .Y(_037_));
 sky130_fd_sc_hd__inv_2 _219_ (.A(_037_),
    .Y(\next_state[5] ));
 sky130_fd_sc_hd__inv_2 _220_ (.A(\curr_state[6] ),
    .Y(_038_));
 sky130_fd_sc_hd__or3_2 _221_ (.A(net81),
    .B(net28),
    .C(_038_),
    .X(_039_));
 sky130_fd_sc_hd__or2_2 _222_ (.A(net30),
    .B(_038_),
    .X(_040_));
 sky130_fd_sc_hd__or3_2 _223_ (.A(net31),
    .B(net28),
    .C(net48),
    .X(_041_));
 sky130_fd_sc_hd__o22a_2 _224_ (.A1(net46),
    .A2(net48),
    .B1(_040_),
    .B2(_041_),
    .X(_042_));
 sky130_fd_sc_hd__a31oi_2 _225_ (.A1(_108_),
    .A2(_113_),
    .A3(\curr_state[6] ),
    .B1(net39),
    .Y(_043_));
 sky130_fd_sc_hd__o21a_2 _226_ (.A1(_038_),
    .A2(_141_),
    .B1(net39),
    .X(_044_));
 sky130_fd_sc_hd__a311oi_2 _227_ (.A1(_018_),
    .A2(\curr_state[6] ),
    .A3(net42),
    .B1(\curr_state[3] ),
    .C1(net44),
    .Y(_045_));
 sky130_fd_sc_hd__o31ai_2 _228_ (.A1(net42),
    .A2(_043_),
    .A3(_044_),
    .B1(_045_),
    .Y(_046_));
 sky130_fd_sc_hd__and3b_2 _229_ (.A_N(net32),
    .B(_040_),
    .C(net43),
    .X(_047_));
 sky130_fd_sc_hd__a21oi_2 _230_ (.A1(_038_),
    .A2(_143_),
    .B1(_047_),
    .Y(_048_));
 sky130_fd_sc_hd__a21oi_2 _231_ (.A1(_046_),
    .A2(_048_),
    .B1(net46),
    .Y(_049_));
 sky130_fd_sc_hd__o22ai_4 _232_ (.A1(_119_),
    .A2(_039_),
    .B1(_042_),
    .B2(_049_),
    .Y(\next_state[6] ));
 sky130_fd_sc_hd__a211o_2 _233_ (.A1(_027_),
    .A2(net21),
    .B1(\next_state[6] ),
    .C1(\next_state[4] ),
    .X(next_seq_busy));
 sky130_fd_sc_hd__nand2_2 _234_ (.A(net22),
    .B(net23),
    .Y(_001_));
 sky130_fd_sc_hd__nand3_2 _235_ (.A(_036_),
    .B(_026_),
    .C(_027_),
    .Y(_050_));
 sky130_fd_sc_hd__a21oi_2 _236_ (.A1(_017_),
    .A2(_050_),
    .B1(\next_state[2] ),
    .Y(_051_));
 sky130_fd_sc_hd__o21a_2 _237_ (.A1(\next_state[1] ),
    .A2(_051_),
    .B1(_122_),
    .X(_003_));
 sky130_fd_sc_hd__a21o_2 _238_ (.A1(_027_),
    .A2(net21),
    .B1(\next_state[4] ),
    .X(_052_));
 sky130_fd_sc_hd__o211a_2 _239_ (.A1(\next_state[2] ),
    .A2(\next_state[3] ),
    .B1(_121_),
    .C1(net23),
    .X(_002_));
 sky130_fd_sc_hd__a31o_2 _240_ (.A1(_122_),
    .A2(net23),
    .A3(_052_),
    .B1(_002_),
    .X(_004_));
 sky130_fd_sc_hd__a21oi_2 _241_ (.A1(_027_),
    .A2(net21),
    .B1(\next_state[4] ),
    .Y(_053_));
 sky130_fd_sc_hd__and4b_2 _242_ (.A_N(net34),
    .B(net26),
    .C(_105_),
    .D(net25),
    .X(_054_));
 sky130_fd_sc_hd__nor2_2 _243_ (.A(net35),
    .B(net37),
    .Y(_055_));
 sky130_fd_sc_hd__nand4_4 _244_ (.A(\next_state[6] ),
    .B(_053_),
    .C(_054_),
    .D(_055_),
    .Y(_056_));
 sky130_fd_sc_hd__o311a_2 _245_ (.A1(net49),
    .A2(_097_),
    .A3(_118_),
    .B1(_121_),
    .C1(net23),
    .X(_057_));
 sky130_fd_sc_hd__nand2_2 _246_ (.A(_057_),
    .B(_137_),
    .Y(_058_));
 sky130_fd_sc_hd__a21oi_4 _247_ (.A1(_017_),
    .A2(_056_),
    .B1(_058_),
    .Y(_005_));
 sky130_fd_sc_hd__and2_2 _248_ (.A(net35),
    .B(net37),
    .X(_059_));
 sky130_fd_sc_hd__or3b_2 _249_ (.A(_059_),
    .B(_055_),
    .C_N(_054_),
    .X(_060_));
 sky130_fd_sc_hd__a21oi_2 _250_ (.A1(_027_),
    .A2(net21),
    .B1(_060_),
    .Y(_061_));
 sky130_fd_sc_hd__and3_2 _251_ (.A(_026_),
    .B(_017_),
    .C(_137_),
    .X(_062_));
 sky130_fd_sc_hd__and4_2 _252_ (.A(_057_),
    .B(_061_),
    .C(\next_state[6] ),
    .D(_062_),
    .X(_063_));
 sky130_fd_sc_hd__buf_4 _253_ (.A(_063_),
    .X(_007_));
 sky130_fd_sc_hd__and4b_2 _254_ (.A_N(net35),
    .B(_137_),
    .C(_054_),
    .D(_017_),
    .X(_064_));
 sky130_fd_sc_hd__and4_2 _255_ (.A(_122_),
    .B(net23),
    .C(_052_),
    .D(_064_),
    .X(_065_));
 sky130_fd_sc_hd__buf_2 _256_ (.A(_065_),
    .X(_008_));
 sky130_fd_sc_hd__nand2_2 _257_ (.A(_122_),
    .B(_126_),
    .Y(_066_));
 sky130_fd_sc_hd__nand3_2 _258_ (.A(_122_),
    .B(_126_),
    .C(_017_),
    .Y(_067_));
 sky130_fd_sc_hd__a21oi_2 _259_ (.A1(\next_state[6] ),
    .A2(_061_),
    .B1(\next_state[4] ),
    .Y(_068_));
 sky130_fd_sc_hd__o22ai_2 _260_ (.A1(_137_),
    .A2(_066_),
    .B1(_067_),
    .B2(_068_),
    .Y(_006_));
 sky130_fd_sc_hd__o31a_2 _261_ (.A1(\next_state[1] ),
    .A2(net22),
    .A3(\next_state[3] ),
    .B1(_121_),
    .X(_000_));
 sky130_fd_sc_hd__a311o_2 _262_ (.A1(_099_),
    .A2(_100_),
    .A3(_102_),
    .B1(_109_),
    .C1(ret_ready_s),
    .X(_069_));
 sky130_fd_sc_hd__a31oi_2 _263_ (.A1(_069_),
    .A2(\curr_state[6] ),
    .A3(_113_),
    .B1(net40),
    .Y(_070_));
 sky130_fd_sc_hd__o211a_2 _264_ (.A1(net41),
    .A2(_070_),
    .B1(_021_),
    .C1(_117_),
    .X(next_error));
 sky130_fd_sc_hd__nor2_2 _265_ (.A(_097_),
    .B(_118_),
    .Y(_071_));
 sky130_fd_sc_hd__o32ai_2 _266_ (.A1(req_idle_s),
    .A2(_119_),
    .A3(net28),
    .B1(net48),
    .B2(_071_),
    .Y(_072_));
 sky130_fd_sc_hd__a21o_2 _267_ (.A1(_144_),
    .A2(_139_),
    .B1(_129_),
    .X(_073_));
 sky130_fd_sc_hd__a21oi_2 _268_ (.A1(_144_),
    .A2(_139_),
    .B1(\curr_state[3] ),
    .Y(_074_));
 sky130_fd_sc_hd__a21oi_2 _269_ (.A1(_073_),
    .A2(\curr_state[3] ),
    .B1(_074_),
    .Y(_075_));
 sky130_fd_sc_hd__and2b_2 _270_ (.A_N(\curr_state[0] ),
    .B(net31),
    .X(_076_));
 sky130_fd_sc_hd__o31a_2 _271_ (.A1(net29),
    .A2(net28),
    .A3(_076_),
    .B1(net47),
    .X(_077_));
 sky130_fd_sc_hd__or4_2 _272_ (.A(net47),
    .B(_127_),
    .C(net27),
    .D(_119_),
    .X(_078_));
 sky130_fd_sc_hd__o21ai_2 _273_ (.A1(_129_),
    .A2(_136_),
    .B1(net44),
    .Y(_079_));
 sky130_fd_sc_hd__o21ai_2 _274_ (.A1(net44),
    .A2(_136_),
    .B1(_079_),
    .Y(_080_));
 sky130_fd_sc_hd__and4bb_2 _275_ (.A_N(_075_),
    .B_N(_077_),
    .C(_078_),
    .D(_080_),
    .X(_081_));
 sky130_fd_sc_hd__nand2_2 _276_ (.A(net20),
    .B(_081_),
    .Y(_082_));
 sky130_fd_sc_hd__nor2_2 _277_ (.A(net37),
    .B(_082_),
    .Y(_009_));
 sky130_fd_sc_hd__and4bb_2 _278_ (.A_N(_059_),
    .B_N(_055_),
    .C(_081_),
    .D(net20),
    .X(_083_));
 sky130_fd_sc_hd__buf_2 _279_ (.A(_083_),
    .X(_010_));
 sky130_fd_sc_hd__and3_2 _280_ (.A(net33),
    .B(net36),
    .C(net38),
    .X(_084_));
 sky130_fd_sc_hd__and4bb_2 _281_ (.A_N(_084_),
    .B_N(_104_),
    .C(_081_),
    .D(_072_),
    .X(_085_));
 sky130_fd_sc_hd__buf_2 _282_ (.A(_085_),
    .X(_011_));
 sky130_fd_sc_hd__a31o_2 _283_ (.A1(net33),
    .A2(net36),
    .A3(net38),
    .B1(\seq_timer[3] ),
    .X(_086_));
 sky130_fd_sc_hd__and4_2 _284_ (.A(_100_),
    .B(net20),
    .C(_081_),
    .D(_086_),
    .X(_087_));
 sky130_fd_sc_hd__buf_2 _285_ (.A(_087_),
    .X(_012_));
 sky130_fd_sc_hd__or3b_2 _286_ (.A(net25),
    .B(_105_),
    .C_N(_084_),
    .X(_088_));
 sky130_fd_sc_hd__a31o_2 _287_ (.A1(net34),
    .A2(\seq_timer[3] ),
    .A3(_059_),
    .B1(\seq_timer[4] ),
    .X(_089_));
 sky130_fd_sc_hd__and4_2 _288_ (.A(_088_),
    .B(net20),
    .C(_081_),
    .D(_089_),
    .X(_090_));
 sky130_fd_sc_hd__buf_2 _289_ (.A(_090_),
    .X(_013_));
 sky130_fd_sc_hd__xor2_2 _290_ (.A(net79),
    .B(_088_),
    .X(_091_));
 sky130_fd_sc_hd__nor2_2 _291_ (.A(_082_),
    .B(_091_),
    .Y(_014_));
 sky130_fd_sc_hd__and3_2 _292_ (.A(net34),
    .B(\seq_timer[3] ),
    .C(_059_),
    .X(_092_));
 sky130_fd_sc_hd__a31oi_2 _293_ (.A1(\seq_timer[5] ),
    .A2(\seq_timer[4] ),
    .A3(_092_),
    .B1(net80),
    .Y(_093_));
 sky130_fd_sc_hd__nand4_2 _294_ (.A(\seq_timer[6] ),
    .B(\seq_timer[5] ),
    .C(\seq_timer[4] ),
    .D(_092_),
    .Y(_094_));
 sky130_fd_sc_hd__or2b_2 _295_ (.A(_093_),
    .B_N(_094_),
    .X(_095_));
 sky130_fd_sc_hd__nor2_2 _296_ (.A(_082_),
    .B(_095_),
    .Y(_015_));
 sky130_fd_sc_hd__xor2_2 _297_ (.A(net77),
    .B(_094_),
    .X(_096_));
 sky130_fd_sc_hd__nor2_2 _298_ (.A(_082_),
    .B(net78),
    .Y(_016_));
 sky130_fd_sc_hd__dfrtp_2 _299_ (.CLK(clknet_3_1__leaf_clk),
    .D(_000_),
    .RESET_B(net50),
    .Q(net9));
 sky130_fd_sc_hd__dfrtp_2 _300_ (.CLK(clknet_3_0__leaf_clk),
    .D(_002_),
    .RESET_B(net50),
    .Q(net12));
 sky130_fd_sc_hd__dfrtp_2 _301_ (.CLK(clknet_3_0__leaf_clk),
    .D(_006_),
    .RESET_B(net50),
    .Q(net16));
 sky130_fd_sc_hd__dfrtp_2 _302_ (.CLK(clknet_3_1__leaf_clk),
    .D(_008_),
    .RESET_B(net50),
    .Q(net18));
 sky130_fd_sc_hd__dfrtp_2 _303_ (.CLK(clknet_3_1__leaf_clk),
    .D(_007_),
    .RESET_B(net51),
    .Q(net17));
 sky130_fd_sc_hd__dfrtp_2 _304_ (.CLK(clknet_3_2__leaf_clk),
    .D(_005_),
    .RESET_B(net52),
    .Q(net15));
 sky130_fd_sc_hd__dfrtp_2 _305_ (.CLK(clknet_3_3__leaf_clk),
    .D(_003_),
    .RESET_B(net52),
    .Q(net13));
 sky130_fd_sc_hd__dfrtp_2 _306_ (.CLK(clknet_3_3__leaf_clk),
    .D(_004_),
    .RESET_B(net52),
    .Q(net14));
 sky130_fd_sc_hd__dfrtp_2 _307_ (.CLK(clknet_3_2__leaf_clk),
    .D(next_seq_busy),
    .RESET_B(net52),
    .Q(net19));
 sky130_fd_sc_hd__dfrtp_2 _308_ (.CLK(clknet_3_2__leaf_clk),
    .D(net83),
    .RESET_B(net52),
    .Q(net11));
 sky130_fd_sc_hd__dfstp_2 _309_ (.CLK(clknet_3_0__leaf_clk),
    .D(\next_state[0] ),
    .SET_B(net50),
    .Q(\curr_state[0] ));
 sky130_fd_sc_hd__dfrtp_2 _310_ (.CLK(clknet_3_1__leaf_clk),
    .D(\next_state[1] ),
    .RESET_B(net51),
    .Q(\curr_state[1] ));
 sky130_fd_sc_hd__dfrtp_2 _311_ (.CLK(clknet_3_6__leaf_clk),
    .D(\next_state[2] ),
    .RESET_B(net51),
    .Q(\curr_state[2] ));
 sky130_fd_sc_hd__dfrtp_2 _312_ (.CLK(clknet_3_4__leaf_clk),
    .D(\next_state[3] ),
    .RESET_B(net51),
    .Q(\curr_state[3] ));
 sky130_fd_sc_hd__dfrtp_2 _313_ (.CLK(clknet_3_6__leaf_clk),
    .D(\next_state[4] ),
    .RESET_B(net53),
    .Q(\curr_state[4] ));
 sky130_fd_sc_hd__dfrtp_2 _314_ (.CLK(clknet_3_6__leaf_clk),
    .D(\next_state[5] ),
    .RESET_B(net53),
    .Q(\curr_state[5] ));
 sky130_fd_sc_hd__dfrtp_2 _315_ (.CLK(clknet_3_4__leaf_clk),
    .D(\next_state[6] ),
    .RESET_B(net57),
    .Q(\curr_state[6] ));
 sky130_fd_sc_hd__dfrtp_2 _316_ (.CLK(clknet_3_3__leaf_clk),
    .D(_009_),
    .RESET_B(net53),
    .Q(\seq_timer[0] ));
 sky130_fd_sc_hd__dfrtp_2 _317_ (.CLK(clknet_3_2__leaf_clk),
    .D(_010_),
    .RESET_B(net53),
    .Q(\seq_timer[1] ));
 sky130_fd_sc_hd__dfrtp_2 _318_ (.CLK(clknet_3_3__leaf_clk),
    .D(_011_),
    .RESET_B(net53),
    .Q(\seq_timer[2] ));
 sky130_fd_sc_hd__dfrtp_2 _319_ (.CLK(clknet_3_3__leaf_clk),
    .D(_012_),
    .RESET_B(net54),
    .Q(\seq_timer[3] ));
 sky130_fd_sc_hd__dfrtp_2 _320_ (.CLK(clknet_3_6__leaf_clk),
    .D(_013_),
    .RESET_B(net57),
    .Q(\seq_timer[4] ));
 sky130_fd_sc_hd__dfrtp_2 _321_ (.CLK(clknet_3_7__leaf_clk),
    .D(_014_),
    .RESET_B(net56),
    .Q(\seq_timer[5] ));
 sky130_fd_sc_hd__dfrtp_2 _322_ (.CLK(clknet_3_7__leaf_clk),
    .D(_015_),
    .RESET_B(net56),
    .Q(\seq_timer[6] ));
 sky130_fd_sc_hd__dfrtp_2 _323_ (.CLK(clknet_3_7__leaf_clk),
    .D(_016_),
    .RESET_B(net56),
    .Q(\seq_timer[7] ));
 sky130_fd_sc_hd__dfrtp_2 _324_ (.CLK(clknet_3_5__leaf_clk),
    .D(net8),
    .RESET_B(net55),
    .Q(\req_sync1[0] ));
 sky130_fd_sc_hd__dfrtp_2 _325_ (.CLK(clknet_3_4__leaf_clk),
    .D(net4),
    .RESET_B(net55),
    .Q(\req_sync1[1] ));
 sky130_fd_sc_hd__dfrtp_2 _326_ (.CLK(clknet_3_0__leaf_clk),
    .D(net5),
    .RESET_B(net54),
    .Q(\req_sync1[2] ));
 sky130_fd_sc_hd__dfrtp_2 _327_ (.CLK(clknet_3_1__leaf_clk),
    .D(net3),
    .RESET_B(net50),
    .Q(\req_sync1[3] ));
 sky130_fd_sc_hd__dfrtp_2 _328_ (.CLK(clknet_3_5__leaf_clk),
    .D(net76),
    .RESET_B(net55),
    .Q(wake_up_s));
 sky130_fd_sc_hd__dfrtp_2 _329_ (.CLK(clknet_3_5__leaf_clk),
    .D(net74),
    .RESET_B(net55),
    .Q(req_off_s));
 sky130_fd_sc_hd__dfrtp_2 _330_ (.CLK(clknet_3_4__leaf_clk),
    .D(net70),
    .RESET_B(net55),
    .Q(req_sleep_s));
 sky130_fd_sc_hd__dfrtp_2 _331_ (.CLK(clknet_3_0__leaf_clk),
    .D(net72),
    .RESET_B(net51),
    .Q(req_idle_s));
 sky130_fd_sc_hd__dfrtp_2 _332_ (.CLK(clknet_3_7__leaf_clk),
    .D(net7),
    .RESET_B(net56),
    .Q(\sts_sync1[0] ));
 sky130_fd_sc_hd__dfrtp_2 _333_ (.CLK(clknet_3_5__leaf_clk),
    .D(net1),
    .RESET_B(net56),
    .Q(\sts_sync1[1] ));
 sky130_fd_sc_hd__dfrtp_2 _334_ (.CLK(clknet_3_4__leaf_clk),
    .D(net2),
    .RESET_B(net55),
    .Q(\sts_sync1[2] ));
 sky130_fd_sc_hd__dfrtp_2 _335_ (.CLK(clknet_3_7__leaf_clk),
    .D(net73),
    .RESET_B(net57),
    .Q(ret_ready_s));
 sky130_fd_sc_hd__dfrtp_2 _336_ (.CLK(clknet_3_6__leaf_clk),
    .D(net71),
    .RESET_B(net56),
    .Q(clk_stable_s));
 sky130_fd_sc_hd__dfrtp_2 _337_ (.CLK(clknet_3_5__leaf_clk),
    .D(net75),
    .RESET_B(net58),
    .Q(pwr_stable_s));
 sky130_fd_sc_hd__dfstp_2 _338_ (.CLK(clknet_3_2__leaf_clk),
    .D(_001_),
    .SET_B(net52),
    .Q(net10));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_0__f_clk (.A(clknet_0_clk),
    .X(clknet_3_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_1__f_clk (.A(clknet_0_clk),
    .X(clknet_3_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_2__f_clk (.A(clknet_0_clk),
    .X(clknet_3_2__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_3__f_clk (.A(clknet_0_clk),
    .X(clknet_3_3__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_4__f_clk (.A(clknet_0_clk),
    .X(clknet_3_4__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_5__f_clk (.A(clknet_0_clk),
    .X(clknet_3_5__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_6__f_clk (.A(clknet_0_clk),
    .X(clknet_3_6__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_3_7__f_clk (.A(clknet_0_clk),
    .X(clknet_3_7__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload0 (.A(clknet_3_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload1 (.A(clknet_3_3__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload2 (.A(clknet_3_4__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload3 (.A(clknet_3_5__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload4 (.A(clknet_3_6__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload5 (.A(clknet_3_7__leaf_clk));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout23 (.A(_126_),
    .X(net23));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout24 (.A(_131_),
    .X(net24));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout25 (.A(_102_),
    .X(net25));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout26 (.A(_099_),
    .X(net26));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout27 (.A(req_sleep_s),
    .X(net27));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout28 (.A(req_sleep_s),
    .X(net28));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout29 (.A(req_off_s),
    .X(net29));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout30 (.A(req_off_s),
    .X(net30));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout31 (.A(wake_up_s),
    .X(net31));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout32 (.A(wake_up_s),
    .X(net32));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout33 (.A(\seq_timer[2] ),
    .X(net33));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout34 (.A(\seq_timer[2] ),
    .X(net34));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout35 (.A(\seq_timer[1] ),
    .X(net35));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout36 (.A(\seq_timer[1] ),
    .X(net36));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout37 (.A(\seq_timer[0] ),
    .X(net37));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout38 (.A(\seq_timer[0] ),
    .X(net38));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout39 (.A(net40),
    .X(net39));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout40 (.A(\curr_state[5] ),
    .X(net40));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout41 (.A(\curr_state[4] ),
    .X(net41));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout42 (.A(\curr_state[4] ),
    .X(net42));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout43 (.A(net44),
    .X(net43));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout44 (.A(\curr_state[2] ),
    .X(net44));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout45 (.A(net47),
    .X(net45));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout46 (.A(net47),
    .X(net46));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout47 (.A(\curr_state[1] ),
    .X(net47));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout48 (.A(net49),
    .X(net48));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout49 (.A(\curr_state[0] ),
    .X(net49));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout50 (.A(net51),
    .X(net50));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout51 (.A(net54),
    .X(net51));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout52 (.A(net53),
    .X(net52));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout53 (.A(net54),
    .X(net53));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout54 (.A(net6),
    .X(net54));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout55 (.A(net58),
    .X(net55));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout56 (.A(net57),
    .X(net56));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout57 (.A(net58),
    .X(net57));
 sky130_fd_sc_hd__clkdlybuf4s25_1 fanout58 (.A(net6),
    .X(net58));
 sky130_fd_sc_hd__dlygate4sd3_1 hold59 (.A(net10),
    .X(net59));
 sky130_fd_sc_hd__dlygate4sd3_1 hold60 (.A(net12),
    .X(net60));
 sky130_fd_sc_hd__dlygate4sd3_1 hold61 (.A(net13),
    .X(net61));
 sky130_fd_sc_hd__dlygate4sd3_1 hold62 (.A(net16),
    .X(net62));
 sky130_fd_sc_hd__dlygate4sd3_1 hold63 (.A(net19),
    .X(net63));
 sky130_fd_sc_hd__dlygate4sd3_1 hold64 (.A(net17),
    .X(net64));
 sky130_fd_sc_hd__dlygate4sd3_1 hold65 (.A(net14),
    .X(net65));
 sky130_fd_sc_hd__dlygate4sd3_1 hold66 (.A(net11),
    .X(net66));
 sky130_fd_sc_hd__dlygate4sd3_1 hold67 (.A(net18),
    .X(net67));
 sky130_fd_sc_hd__dlygate4sd3_1 hold68 (.A(net15),
    .X(net68));
 sky130_fd_sc_hd__dlygate4sd3_1 hold69 (.A(net9),
    .X(net69));
 sky130_fd_sc_hd__dlygate4sd3_1 hold70 (.A(\req_sync1[2] ),
    .X(net70));
 sky130_fd_sc_hd__dlygate4sd3_1 hold71 (.A(\sts_sync1[1] ),
    .X(net71));
 sky130_fd_sc_hd__dlygate4sd3_1 hold72 (.A(\req_sync1[3] ),
    .X(net72));
 sky130_fd_sc_hd__dlygate4sd3_1 hold73 (.A(\sts_sync1[0] ),
    .X(net73));
 sky130_fd_sc_hd__dlygate4sd3_1 hold74 (.A(\req_sync1[1] ),
    .X(net74));
 sky130_fd_sc_hd__dlygate4sd3_1 hold75 (.A(\sts_sync1[2] ),
    .X(net75));
 sky130_fd_sc_hd__dlygate4sd3_1 hold76 (.A(\req_sync1[0] ),
    .X(net76));
 sky130_fd_sc_hd__dlygate4sd3_1 hold77 (.A(\seq_timer[7] ),
    .X(net77));
 sky130_fd_sc_hd__dlygate4sd3_1 hold78 (.A(_096_),
    .X(net78));
 sky130_fd_sc_hd__dlygate4sd3_1 hold79 (.A(\seq_timer[5] ),
    .X(net79));
 sky130_fd_sc_hd__dlygate4sd3_1 hold80 (.A(\seq_timer[6] ),
    .X(net80));
 sky130_fd_sc_hd__dlygate4sd3_1 hold81 (.A(req_idle_s),
    .X(net81));
 sky130_fd_sc_hd__dlygate4sd3_1 hold82 (.A(\curr_state[0] ),
    .X(net82));
 sky130_fd_sc_hd__dlygate4sd3_1 hold83 (.A(next_error),
    .X(net83));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input1 (.A(clk_stable),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input2 (.A(pwr_stable),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input3 (.A(req_idle),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input4 (.A(req_off),
    .X(net4));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input5 (.A(req_sleep),
    .X(net5));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input6 (.A(reset_n),
    .X(net6));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input7 (.A(retention_ready),
    .X(net7));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input8 (.A(wake_up),
    .X(net8));
 sky130_fd_sc_hd__buf_1 max_cap20 (.A(_072_),
    .X(net20));
 sky130_fd_sc_hd__clkbuf_2 max_cap21 (.A(_036_),
    .X(net21));
 sky130_fd_sc_hd__clkbuf_2 max_cap22 (.A(_136_),
    .X(net22));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output10 (.A(net59),
    .X(dvfs_ctrl[1]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output11 (.A(net66),
    .X(error));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output12 (.A(net60),
    .X(pwr_gate_en));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output13 (.A(net61),
    .X(pwr_state[0]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output14 (.A(net65),
    .X(pwr_state[1]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output15 (.A(net68),
    .X(reset_ctrl));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output16 (.A(net62),
    .X(retention_en));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output17 (.A(net64),
    .X(retention_restore));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output18 (.A(net67),
    .X(retention_save));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output19 (.A(net63),
    .X(seq_busy));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output9 (.A(net69),
    .X(clk_gate_en));
 sky130_fd_sc_hd__conb_1 pmu_fsm (.HI(net));
 assign dvfs_ctrl[0] = net;
endmodule
