//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
//Date        : Sat Feb 21 16:29:23 2026
//Host        : mobile running 64-bit major release  (build 9200)
//Command     : generate_target P2_BD_pongIP_S2026.bd
//Design      : P2_BD_pongIP_S2026
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Debounce_imp_K0Q0PB
   (i_Clk,
    i_Switch_0,
    i_Switch_1,
    i_Switch_2,
    i_Switch_3,
    i_Switch_4,
    o_Switch0,
    o_Switch1,
    o_Switch2,
    o_Switch3,
    o_Switch4);
  input i_Clk;
  input i_Switch_0;
  input i_Switch_1;
  input i_Switch_2;
  input i_Switch_3;
  input i_Switch_4;
  output o_Switch0;
  output o_Switch1;
  output o_Switch2;
  output o_Switch3;
  output o_Switch4;

  wire i_Clk;
  wire i_Switch_0;
  wire i_Switch_1;
  wire i_Switch_2;
  wire i_Switch_3;
  wire i_Switch_4;
  wire o_Switch0;
  wire o_Switch1;
  wire o_Switch2;
  wire o_Switch3;
  wire o_Switch4;

  P2_BD_pongIP_S2026_Debounce_Switch_0_0 Debounce_Switch_0
       (.i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(o_Switch1));
  P2_BD_pongIP_S2026_Debounce_Switch_1_0 Debounce_Switch_1
       (.i_Clk(i_Clk),
        .i_Switch(i_Switch_0),
        .o_Switch(o_Switch0));
  P2_BD_pongIP_S2026_Debounce_Switch_2_0 Debounce_Switch_2
       (.i_Clk(i_Clk),
        .i_Switch(i_Switch_3),
        .o_Switch(o_Switch3));
  P2_BD_pongIP_S2026_Debounce_Switch_3_0 Debounce_Switch_3
       (.i_Clk(i_Clk),
        .i_Switch(i_Switch_2),
        .o_Switch(o_Switch2));
  P2_BD_pongIP_S2026_Debounce_Switch_4_0 Debounce_Switch_4
       (.i_Clk(i_Clk),
        .i_Switch(i_Switch_4),
        .o_Switch(o_Switch4));
endmodule

(* CORE_GENERATION_INFO = "P2_BD_pongIP_S2026,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=P2_BD_pongIP_S2026,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=13,numReposBlks=11,numNonXlnxBlks=1,numHierBlks=2,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=9,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "P2_BD_pongIP_S2026.hwdef" *) 
module P2_BD_pongIP_S2026
   (clk_125MHz,
    clk_25MHz,
    hdmi_tx_0_tmds_clk_n,
    hdmi_tx_0_tmds_clk_p,
    hdmi_tx_0_tmds_data_n,
    hdmi_tx_0_tmds_data_p,
    i_Switch_0,
    i_Switch_1,
    i_Switch_2,
    i_Switch_3,
    i_Switch_4,
    locked,
    rst_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_125MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_125MHZ, CLK_DOMAIN P2_BD_pongIP_S2026_clk_125MHz, FREQ_HZ 125000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_125MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_25MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_25MHZ, CLK_DOMAIN P2_BD_pongIP_S2026_clk_25MHz, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_25MHz;
  (* X_INTERFACE_INFO = "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_CLK_N" *) (* X_INTERFACE_MODE = "Master" *) output hdmi_tx_0_tmds_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_CLK_P" *) output hdmi_tx_0_tmds_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_DATA_N" *) output [2:0]hdmi_tx_0_tmds_data_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:hdmi:2.0 hdmi_tx_0 TMDS_DATA_P" *) output [2:0]hdmi_tx_0_tmds_data_p;
  input i_Switch_0;
  input i_Switch_1;
  input i_Switch_2;
  input i_Switch_3;
  input i_Switch_4;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.LOCKED RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.LOCKED, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input locked;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input rst_0;

  wire Debounce_o_Switch1;
  wire Debounce_o_Switch2;
  wire Debounce_o_Switch3;
  wire Debounce_o_Switch4;
  wire Debounce_o_Switch5;
  wire [2:0]Pong_Top2_0_o_Blu_Video;
  wire [2:0]Pong_Top2_0_o_Grn_Video;
  wire [2:0]Pong_Top2_0_o_Red_Video;
  wire [2:0]VGA_o_Blu_Video_0;
  wire [9:0]VGA_o_Col_Count;
  wire [2:0]VGA_o_Grn_Video_0;
  wire VGA_o_HSync_0;
  wire [2:0]VGA_o_Red_Video_0;
  wire [9:0]VGA_o_Row_Count;
  wire VGA_o_VSync_0;
  wire [0:0]VGA_o_vde;
  wire clk_125MHz;
  wire clk_25MHz;
  wire hdmi_tx_0_tmds_clk_n;
  wire hdmi_tx_0_tmds_clk_p;
  wire [2:0]hdmi_tx_0_tmds_data_n;
  wire [2:0]hdmi_tx_0_tmds_data_p;
  wire i_Switch_0;
  wire i_Switch_1;
  wire i_Switch_2;
  wire i_Switch_3;
  wire i_Switch_4;
  wire locked;
  wire rst_0;

  Debounce_imp_K0Q0PB Debounce
       (.i_Clk(clk_25MHz),
        .i_Switch_0(i_Switch_0),
        .i_Switch_1(i_Switch_1),
        .i_Switch_2(i_Switch_2),
        .i_Switch_3(i_Switch_3),
        .i_Switch_4(i_Switch_4),
        .o_Switch0(Debounce_o_Switch1),
        .o_Switch1(Debounce_o_Switch2),
        .o_Switch2(Debounce_o_Switch5),
        .o_Switch3(Debounce_o_Switch3),
        .o_Switch4(Debounce_o_Switch4));
  P2_BD_pongIP_S2026_Pong_Top2_0_0 Pong_Top2_0
       (.i_Clk(clk_25MHz),
        .i_Col_Count(VGA_o_Col_Count),
        .i_Game_Start(Debounce_o_Switch4),
        .i_Paddle_Dn_P1(Debounce_o_Switch1),
        .i_Paddle_Dn_P2(Debounce_o_Switch5),
        .i_Paddle_Up_P1(Debounce_o_Switch2),
        .i_Paddle_Up_P2(Debounce_o_Switch3),
        .i_Row_Count(VGA_o_Row_Count),
        .o_Blu_Video(Pong_Top2_0_o_Blu_Video),
        .o_Grn_Video(Pong_Top2_0_o_Grn_Video),
        .o_Red_Video(Pong_Top2_0_o_Red_Video));
  VGA_imp_33E8YF VGA
       (.i_Blu_Video(Pong_Top2_0_o_Blu_Video),
        .i_Clk(clk_25MHz),
        .i_Grn_Video(Pong_Top2_0_o_Grn_Video),
        .i_Red_Video(Pong_Top2_0_o_Red_Video),
        .o_Blu_Video_0(VGA_o_Blu_Video_0),
        .o_Col_Count(VGA_o_Col_Count),
        .o_Grn_Video_0(VGA_o_Grn_Video_0),
        .o_HSync_0(VGA_o_HSync_0),
        .o_Red_Video_0(VGA_o_Red_Video_0),
        .o_Row_Count(VGA_o_Row_Count),
        .o_VSync_0(VGA_o_VSync_0),
        .o_vde(VGA_o_vde));
  P2_BD_pongIP_S2026_hdmi_tx_0_0 hdmi_tx_0
       (.TMDS_CLK_N(hdmi_tx_0_tmds_clk_n),
        .TMDS_CLK_P(hdmi_tx_0_tmds_clk_p),
        .TMDS_DATA_N(hdmi_tx_0_tmds_data_n),
        .TMDS_DATA_P(hdmi_tx_0_tmds_data_p),
        .blue(VGA_o_Blu_Video_0),
        .green(VGA_o_Grn_Video_0),
        .hsync(VGA_o_HSync_0),
        .pix_clk(clk_25MHz),
        .pix_clk_locked(locked),
        .pix_clkx5(clk_125MHz),
        .red(VGA_o_Red_Video_0),
        .rst(rst_0),
        .vde(VGA_o_vde),
        .vsync(VGA_o_VSync_0));
endmodule

module VGA_imp_33E8YF
   (i_Blu_Video,
    i_Clk,
    i_Grn_Video,
    i_Red_Video,
    o_Blu_Video_0,
    o_Col_Count,
    o_Grn_Video_0,
    o_HSync_0,
    o_Red_Video_0,
    o_Row_Count,
    o_VSync_0,
    o_vde);
  input [2:0]i_Blu_Video;
  input i_Clk;
  input [2:0]i_Grn_Video;
  input [2:0]i_Red_Video;
  output [2:0]o_Blu_Video_0;
  output [9:0]o_Col_Count;
  output [2:0]o_Grn_Video_0;
  output o_HSync_0;
  output [2:0]o_Red_Video_0;
  output [9:0]o_Row_Count;
  output o_VSync_0;
  output [0:0]o_vde;

  wire Sync_To_Count2_0_o_HSync;
  wire Sync_To_Count2_0_o_VSync;
  wire VGA_Sync_Pulses_0_o_HSync;
  wire VGA_Sync_Pulses_0_o_VSync;
  wire [2:0]i_Blu_Video;
  wire i_Clk;
  wire [2:0]i_Grn_Video;
  wire [2:0]i_Red_Video;
  wire [2:0]o_Blu_Video_0;
  wire [9:0]o_Col_Count;
  wire [2:0]o_Grn_Video_0;
  wire o_HSync_0;
  wire [2:0]o_Red_Video_0;
  wire [9:0]o_Row_Count;
  wire o_VSync_0;
  wire [0:0]o_vde;

  P2_BD_pongIP_S2026_Sync_To_Count2_0_0 Sync_To_Count2_0
       (.i_Clk(i_Clk),
        .i_HSync(VGA_Sync_Pulses_0_o_HSync),
        .i_VSync(VGA_Sync_Pulses_0_o_VSync),
        .o_Col_Count(o_Col_Count),
        .o_HSync(Sync_To_Count2_0_o_HSync),
        .o_Row_Count(o_Row_Count),
        .o_VSync(Sync_To_Count2_0_o_VSync));
  P2_BD_pongIP_S2026_VGA_Sync_Porch_0_0 VGA_Sync_Porch_0
       (.i_Blu_Video(i_Blu_Video),
        .i_Clk(i_Clk),
        .i_Grn_Video(i_Grn_Video),
        .i_HSync(Sync_To_Count2_0_o_HSync),
        .i_Red_Video(i_Red_Video),
        .i_VSync(Sync_To_Count2_0_o_VSync),
        .o_Blu_Video(o_Blu_Video_0),
        .o_Grn_Video(o_Grn_Video_0),
        .o_HSync(o_HSync_0),
        .o_Red_Video(o_Red_Video_0),
        .o_VSync(o_VSync_0));
  P2_BD_pongIP_S2026_VGA_Sync_Pulses_0_0 VGA_Sync_Pulses_0
       (.i_Clk(i_Clk),
        .o_HSync(VGA_Sync_Pulses_0_o_HSync),
        .o_VSync(VGA_Sync_Pulses_0_o_VSync));
  assign o_vde = VGA_Sync_Pulses_0_o_HSync & VGA_Sync_Pulses_0_o_VSync;
endmodule
