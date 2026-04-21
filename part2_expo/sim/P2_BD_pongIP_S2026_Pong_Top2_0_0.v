// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:Pong_Top2:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module P2_BD_pongIP_S2026_Pong_Top2_0_0 (
  i_Clk,
  i_Col_Count,
  i_Row_Count,
  i_Game_Start,
  i_Paddle_Up_P1,
  i_Paddle_Dn_P1,
  i_Paddle_Up_P2,
  i_Paddle_Dn_P2,
  o_Red_Video,
  o_Blu_Video,
  o_Grn_Video,
  D0_AN,
  D0_SEG,
  D1_AN,
  D1_SEG
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 i_Clk CLK" *)
(* X_INTERFACE_MODE = "slave" *)
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME i_Clk, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN P2_BD_pongIP_S2026_clk_25MHz, INSERT_VIP 0" *)
input wire i_Clk;
input wire [9 : 0] i_Col_Count;
input wire [9 : 0] i_Row_Count;
input wire i_Game_Start;
input wire i_Paddle_Up_P1;
input wire i_Paddle_Dn_P1;
input wire i_Paddle_Up_P2;
input wire i_Paddle_Dn_P2;
output wire [2 : 0] o_Red_Video;
output wire [2 : 0] o_Blu_Video;
output wire [2 : 0] o_Grn_Video;
output wire [3 : 0] D0_AN;
output wire [7 : 0] D0_SEG;
output wire [3 : 0] D1_AN;
output wire [7 : 0] D1_SEG;

  Pong_Top2 #(
    .g_Video_Width(3),
    .g_Total_Cols(800),
    .g_Total_Rows(525),
    .g_Active_Cols(640),
    .g_Active_Rows(480)
  ) inst (
    .i_Clk(i_Clk),
    .i_Col_Count(i_Col_Count),
    .i_Row_Count(i_Row_Count),
    .i_Game_Start(i_Game_Start),
    .i_Paddle_Up_P1(i_Paddle_Up_P1),
    .i_Paddle_Dn_P1(i_Paddle_Dn_P1),
    .i_Paddle_Up_P2(i_Paddle_Up_P2),
    .i_Paddle_Dn_P2(i_Paddle_Dn_P2),
    .o_Red_Video(o_Red_Video),
    .o_Blu_Video(o_Blu_Video),
    .o_Grn_Video(o_Grn_Video),
    .D0_AN(D0_AN),
    .D0_SEG(D0_SEG),
    .D1_AN(D1_AN),
    .D1_SEG(D1_SEG)
  );
endmodule
