//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
//Date        : Wed Apr 22 19:14:08 2026
//Host        : dendenx running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=2,da_board_cnt=2,da_clkrst_cnt=5,synth_mode=None}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (LED,
    SW,
    UART_0_rxd,
    UART_0_txd,
    clk_100MHz,
    hdmi_reset,
    hdmi_tx_0_0_tmds_clk_n,
    hdmi_tx_0_0_tmds_clk_p,
    hdmi_tx_0_0_tmds_data_n,
    hdmi_tx_0_0_tmds_data_p,
    o_Seven_Seg_P1_en_0_port_out_0,
    o_Seven_Seg_P1_out_0_port_out_0,
    o_Seven_Seg_P2_out_0_port_out_0);
  output [3:0]LED;
  input [3:0]SW;
  input UART_0_rxd;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.UART_0_TXD DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.UART_0_TXD, LAYERED_METADATA undef" *) output UART_0_txd;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN design_1_clk_100MHz, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk_100MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.HDMI_RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.HDMI_RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input hdmi_reset;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.HDMI_TX_0_0_TMDS_CLK_N CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.HDMI_TX_0_0_TMDS_CLK_N, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output hdmi_tx_0_0_tmds_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.HDMI_TX_0_0_TMDS_CLK_P CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.HDMI_TX_0_0_TMDS_CLK_P, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output hdmi_tx_0_0_tmds_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.HDMI_TX_0_0_TMDS_DATA_N DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.HDMI_TX_0_0_TMDS_DATA_N, LAYERED_METADATA undef" *) output [2:0]hdmi_tx_0_0_tmds_data_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.HDMI_TX_0_0_TMDS_DATA_P DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.HDMI_TX_0_0_TMDS_DATA_P, LAYERED_METADATA undef" *) output [2:0]hdmi_tx_0_0_tmds_data_p;
  output [1:0]o_Seven_Seg_P1_en_0_port_out_0;
  output [6:0]o_Seven_Seg_P1_out_0_port_out_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.O_SEVEN_SEG_P2_OUT_0_PORT_OUT_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.O_SEVEN_SEG_P2_OUT_0_PORT_OUT_0, LAYERED_METADATA undef" *) output [6:0]o_Seven_Seg_P2_out_0_port_out_0;

  wire [3:0]LED;
  wire [3:0]SW;
  wire UART_0_rxd;
  wire UART_0_txd;
  wire clk_100MHz;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire clk_wiz_0_locked;
  wire hdmi_reset;
  wire hdmi_tx_0_0_tmds_clk_n;
  wire hdmi_tx_0_0_tmds_clk_p;
  wire [2:0]hdmi_tx_0_0_tmds_data_n;
  wire [2:0]hdmi_tx_0_0_tmds_data_p;
  wire [3:0]main_smartconnect_0_M00_AXI_ARADDR;
  wire [2:0]main_smartconnect_0_M00_AXI_ARPROT;
  wire main_smartconnect_0_M00_AXI_ARREADY;
  wire main_smartconnect_0_M00_AXI_ARVALID;
  wire [3:0]main_smartconnect_0_M00_AXI_AWADDR;
  wire [2:0]main_smartconnect_0_M00_AXI_AWPROT;
  wire main_smartconnect_0_M00_AXI_AWREADY;
  wire main_smartconnect_0_M00_AXI_AWVALID;
  wire main_smartconnect_0_M00_AXI_BREADY;
  wire [1:0]main_smartconnect_0_M00_AXI_BRESP;
  wire main_smartconnect_0_M00_AXI_BVALID;
  wire [31:0]main_smartconnect_0_M00_AXI_RDATA;
  wire main_smartconnect_0_M00_AXI_RREADY;
  wire [1:0]main_smartconnect_0_M00_AXI_RRESP;
  wire main_smartconnect_0_M00_AXI_RVALID;
  wire [31:0]main_smartconnect_0_M00_AXI_WDATA;
  wire main_smartconnect_0_M00_AXI_WREADY;
  wire [3:0]main_smartconnect_0_M00_AXI_WSTRB;
  wire main_smartconnect_0_M00_AXI_WVALID;
  wire [31:0]neorv32_vivado_ip_0_m_axi_ARADDR;
  wire [1:0]neorv32_vivado_ip_0_m_axi_ARBURST;
  wire [3:0]neorv32_vivado_ip_0_m_axi_ARCACHE;
  wire [7:0]neorv32_vivado_ip_0_m_axi_ARLEN;
  wire [2:0]neorv32_vivado_ip_0_m_axi_ARPROT;
  wire neorv32_vivado_ip_0_m_axi_ARREADY;
  wire [2:0]neorv32_vivado_ip_0_m_axi_ARSIZE;
  wire neorv32_vivado_ip_0_m_axi_ARVALID;
  wire [31:0]neorv32_vivado_ip_0_m_axi_AWADDR;
  wire [1:0]neorv32_vivado_ip_0_m_axi_AWBURST;
  wire [3:0]neorv32_vivado_ip_0_m_axi_AWCACHE;
  wire [7:0]neorv32_vivado_ip_0_m_axi_AWLEN;
  wire [2:0]neorv32_vivado_ip_0_m_axi_AWPROT;
  wire neorv32_vivado_ip_0_m_axi_AWREADY;
  wire [2:0]neorv32_vivado_ip_0_m_axi_AWSIZE;
  wire neorv32_vivado_ip_0_m_axi_AWVALID;
  wire neorv32_vivado_ip_0_m_axi_BREADY;
  wire [1:0]neorv32_vivado_ip_0_m_axi_BRESP;
  wire neorv32_vivado_ip_0_m_axi_BVALID;
  wire [31:0]neorv32_vivado_ip_0_m_axi_RDATA;
  wire neorv32_vivado_ip_0_m_axi_RLAST;
  wire neorv32_vivado_ip_0_m_axi_RREADY;
  wire [1:0]neorv32_vivado_ip_0_m_axi_RRESP;
  wire neorv32_vivado_ip_0_m_axi_RVALID;
  wire [31:0]neorv32_vivado_ip_0_m_axi_WDATA;
  wire neorv32_vivado_ip_0_m_axi_WLAST;
  wire neorv32_vivado_ip_0_m_axi_WREADY;
  wire [3:0]neorv32_vivado_ip_0_m_axi_WSTRB;
  wire neorv32_vivado_ip_0_m_axi_WVALID;
  wire [1:0]o_Seven_Seg_P1_en_0_port_out_0;
  wire [6:0]o_Seven_Seg_P1_out_0_port_out_0;
  wire [6:0]o_Seven_Seg_P2_out_0_port_out_0;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;

  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_100MHz),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3),
        .locked(clk_wiz_0_locked),
        .reset(hdmi_reset));
  design_1_smartconnect_0_2 main_smartconnect_0
       (.M00_AXI_araddr(main_smartconnect_0_M00_AXI_ARADDR),
        .M00_AXI_arprot(main_smartconnect_0_M00_AXI_ARPROT),
        .M00_AXI_arready(main_smartconnect_0_M00_AXI_ARREADY),
        .M00_AXI_arvalid(main_smartconnect_0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(main_smartconnect_0_M00_AXI_AWADDR),
        .M00_AXI_awprot(main_smartconnect_0_M00_AXI_AWPROT),
        .M00_AXI_awready(main_smartconnect_0_M00_AXI_AWREADY),
        .M00_AXI_awvalid(main_smartconnect_0_M00_AXI_AWVALID),
        .M00_AXI_bready(main_smartconnect_0_M00_AXI_BREADY),
        .M00_AXI_bresp(main_smartconnect_0_M00_AXI_BRESP),
        .M00_AXI_bvalid(main_smartconnect_0_M00_AXI_BVALID),
        .M00_AXI_rdata(main_smartconnect_0_M00_AXI_RDATA),
        .M00_AXI_rready(main_smartconnect_0_M00_AXI_RREADY),
        .M00_AXI_rresp(main_smartconnect_0_M00_AXI_RRESP),
        .M00_AXI_rvalid(main_smartconnect_0_M00_AXI_RVALID),
        .M00_AXI_wdata(main_smartconnect_0_M00_AXI_WDATA),
        .M00_AXI_wready(main_smartconnect_0_M00_AXI_WREADY),
        .M00_AXI_wstrb(main_smartconnect_0_M00_AXI_WSTRB),
        .M00_AXI_wvalid(main_smartconnect_0_M00_AXI_WVALID),
        .S00_AXI_araddr(neorv32_vivado_ip_0_m_axi_ARADDR),
        .S00_AXI_arburst(neorv32_vivado_ip_0_m_axi_ARBURST),
        .S00_AXI_arcache(neorv32_vivado_ip_0_m_axi_ARCACHE),
        .S00_AXI_arlen(neorv32_vivado_ip_0_m_axi_ARLEN),
        .S00_AXI_arlock(1'b0),
        .S00_AXI_arprot(neorv32_vivado_ip_0_m_axi_ARPROT),
        .S00_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arready(neorv32_vivado_ip_0_m_axi_ARREADY),
        .S00_AXI_arsize(neorv32_vivado_ip_0_m_axi_ARSIZE),
        .S00_AXI_arvalid(neorv32_vivado_ip_0_m_axi_ARVALID),
        .S00_AXI_awaddr(neorv32_vivado_ip_0_m_axi_AWADDR),
        .S00_AXI_awburst(neorv32_vivado_ip_0_m_axi_AWBURST),
        .S00_AXI_awcache(neorv32_vivado_ip_0_m_axi_AWCACHE),
        .S00_AXI_awlen(neorv32_vivado_ip_0_m_axi_AWLEN),
        .S00_AXI_awlock(1'b0),
        .S00_AXI_awprot(neorv32_vivado_ip_0_m_axi_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(neorv32_vivado_ip_0_m_axi_AWREADY),
        .S00_AXI_awsize(neorv32_vivado_ip_0_m_axi_AWSIZE),
        .S00_AXI_awvalid(neorv32_vivado_ip_0_m_axi_AWVALID),
        .S00_AXI_bready(neorv32_vivado_ip_0_m_axi_BREADY),
        .S00_AXI_bresp(neorv32_vivado_ip_0_m_axi_BRESP),
        .S00_AXI_bvalid(neorv32_vivado_ip_0_m_axi_BVALID),
        .S00_AXI_rdata(neorv32_vivado_ip_0_m_axi_RDATA),
        .S00_AXI_rlast(neorv32_vivado_ip_0_m_axi_RLAST),
        .S00_AXI_rready(neorv32_vivado_ip_0_m_axi_RREADY),
        .S00_AXI_rresp(neorv32_vivado_ip_0_m_axi_RRESP),
        .S00_AXI_rvalid(neorv32_vivado_ip_0_m_axi_RVALID),
        .S00_AXI_wdata(neorv32_vivado_ip_0_m_axi_WDATA),
        .S00_AXI_wlast(neorv32_vivado_ip_0_m_axi_WLAST),
        .S00_AXI_wready(neorv32_vivado_ip_0_m_axi_WREADY),
        .S00_AXI_wstrb(neorv32_vivado_ip_0_m_axi_WSTRB),
        .S00_AXI_wvalid(neorv32_vivado_ip_0_m_axi_WVALID),
        .S01_AXI_araddr(1'b0),
        .S01_AXI_arburst({1'b0,1'b1}),
        .S01_AXI_arcache({1'b0,1'b0,1'b1,1'b1}),
        .S01_AXI_arid(1'b0),
        .S01_AXI_arlen(1'b0),
        .S01_AXI_arlock(1'b0),
        .S01_AXI_arprot({1'b0,1'b0,1'b0}),
        .S01_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S01_AXI_arregion({1'b0,1'b0,1'b0,1'b0}),
        .S01_AXI_arsize({1'b0,1'b1,1'b0}),
        .S01_AXI_aruser(1'b0),
        .S01_AXI_arvalid(1'b0),
        .S01_AXI_awaddr(1'b0),
        .S01_AXI_awburst({1'b0,1'b1}),
        .S01_AXI_awcache({1'b0,1'b0,1'b1,1'b1}),
        .S01_AXI_awid(1'b0),
        .S01_AXI_awlen(1'b0),
        .S01_AXI_awlock(1'b0),
        .S01_AXI_awprot({1'b0,1'b0,1'b0}),
        .S01_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S01_AXI_awregion({1'b0,1'b0,1'b0,1'b0}),
        .S01_AXI_awsize({1'b0,1'b1,1'b0}),
        .S01_AXI_awuser(1'b0),
        .S01_AXI_awvalid(1'b0),
        .S01_AXI_bready(1'b0),
        .S01_AXI_rready(1'b0),
        .S01_AXI_wdata(1'b0),
        .S01_AXI_wid(1'b0),
        .S01_AXI_wlast(1'b0),
        .S01_AXI_wstrb(1'b1),
        .S01_AXI_wuser(1'b0),
        .S01_AXI_wvalid(1'b0),
        .aclk(clk_wiz_0_clk_out1),
        .aresetn(proc_sys_reset_0_peripheral_aresetn));
  design_1_neorv32_vivado_ip_0_3 neorv32_vivado_ip_0
       (.clk(clk_wiz_0_clk_out1),
        .gpio_i(SW),
        .gpio_o(LED),
        .irq_mei_i(1'b0),
        .irq_msi_i(1'b0),
        .irq_mti_i(1'b0),
        .m_axi_araddr(neorv32_vivado_ip_0_m_axi_ARADDR),
        .m_axi_arburst(neorv32_vivado_ip_0_m_axi_ARBURST),
        .m_axi_arcache(neorv32_vivado_ip_0_m_axi_ARCACHE),
        .m_axi_arlen(neorv32_vivado_ip_0_m_axi_ARLEN),
        .m_axi_arprot(neorv32_vivado_ip_0_m_axi_ARPROT),
        .m_axi_arready(neorv32_vivado_ip_0_m_axi_ARREADY),
        .m_axi_arsize(neorv32_vivado_ip_0_m_axi_ARSIZE),
        .m_axi_arvalid(neorv32_vivado_ip_0_m_axi_ARVALID),
        .m_axi_awaddr(neorv32_vivado_ip_0_m_axi_AWADDR),
        .m_axi_awburst(neorv32_vivado_ip_0_m_axi_AWBURST),
        .m_axi_awcache(neorv32_vivado_ip_0_m_axi_AWCACHE),
        .m_axi_awlen(neorv32_vivado_ip_0_m_axi_AWLEN),
        .m_axi_awprot(neorv32_vivado_ip_0_m_axi_AWPROT),
        .m_axi_awready(neorv32_vivado_ip_0_m_axi_AWREADY),
        .m_axi_awsize(neorv32_vivado_ip_0_m_axi_AWSIZE),
        .m_axi_awvalid(neorv32_vivado_ip_0_m_axi_AWVALID),
        .m_axi_bready(neorv32_vivado_ip_0_m_axi_BREADY),
        .m_axi_bresp(neorv32_vivado_ip_0_m_axi_BRESP),
        .m_axi_bvalid(neorv32_vivado_ip_0_m_axi_BVALID),
        .m_axi_rdata(neorv32_vivado_ip_0_m_axi_RDATA),
        .m_axi_rlast(neorv32_vivado_ip_0_m_axi_RLAST),
        .m_axi_rready(neorv32_vivado_ip_0_m_axi_RREADY),
        .m_axi_rresp(neorv32_vivado_ip_0_m_axi_RRESP),
        .m_axi_rvalid(neorv32_vivado_ip_0_m_axi_RVALID),
        .m_axi_wdata(neorv32_vivado_ip_0_m_axi_WDATA),
        .m_axi_wlast(neorv32_vivado_ip_0_m_axi_WLAST),
        .m_axi_wready(neorv32_vivado_ip_0_m_axi_WREADY),
        .m_axi_wstrb(neorv32_vivado_ip_0_m_axi_WSTRB),
        .m_axi_wvalid(neorv32_vivado_ip_0_m_axi_WVALID),
        .resetn(proc_sys_reset_0_peripheral_aresetn),
        .uart0_ctsn_i(1'b0),
        .uart0_rxd_i(UART_0_rxd),
        .uart0_txd_o(UART_0_txd));
  design_1_pong_axi_0_1 pong_axi_0
       (.clk_125MHz(clk_wiz_0_clk_out3),
        .clk_25MHz(clk_wiz_0_clk_out2),
        .hdmi_tx_0_tmds_clk_n_port_out(hdmi_tx_0_0_tmds_clk_n),
        .hdmi_tx_0_tmds_clk_p_port_out(hdmi_tx_0_0_tmds_clk_p),
        .hdmi_tx_0_tmds_data_n_port_out(hdmi_tx_0_0_tmds_data_n),
        .hdmi_tx_0_tmds_data_p_port_out(hdmi_tx_0_0_tmds_data_p),
        .locked(clk_wiz_0_locked),
        .rst_0_port_out(proc_sys_reset_0_peripheral_aresetn),
        .s00_axi_aclk(clk_wiz_0_clk_out1),
        .s00_axi_araddr(main_smartconnect_0_M00_AXI_ARADDR),
        .s00_axi_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .s00_axi_arprot(main_smartconnect_0_M00_AXI_ARPROT),
        .s00_axi_arready(main_smartconnect_0_M00_AXI_ARREADY),
        .s00_axi_arvalid(main_smartconnect_0_M00_AXI_ARVALID),
        .s00_axi_awaddr(main_smartconnect_0_M00_AXI_AWADDR),
        .s00_axi_awprot(main_smartconnect_0_M00_AXI_AWPROT),
        .s00_axi_awready(main_smartconnect_0_M00_AXI_AWREADY),
        .s00_axi_awvalid(main_smartconnect_0_M00_AXI_AWVALID),
        .s00_axi_bready(main_smartconnect_0_M00_AXI_BREADY),
        .s00_axi_bresp(main_smartconnect_0_M00_AXI_BRESP),
        .s00_axi_bvalid(main_smartconnect_0_M00_AXI_BVALID),
        .s00_axi_rdata(main_smartconnect_0_M00_AXI_RDATA),
        .s00_axi_rready(main_smartconnect_0_M00_AXI_RREADY),
        .s00_axi_rresp(main_smartconnect_0_M00_AXI_RRESP),
        .s00_axi_rvalid(main_smartconnect_0_M00_AXI_RVALID),
        .s00_axi_wdata(main_smartconnect_0_M00_AXI_WDATA),
        .s00_axi_wready(main_smartconnect_0_M00_AXI_WREADY),
        .s00_axi_wstrb(main_smartconnect_0_M00_AXI_WSTRB),
        .s00_axi_wvalid(main_smartconnect_0_M00_AXI_WVALID),
        .seven_seg_data_line2_port_out(o_Seven_Seg_P2_out_0_port_out_0),
        .seven_seg_data_line_port_out(o_Seven_Seg_P1_out_0_port_out_0),
        .seven_seg_enabler_port_out(o_Seven_Seg_P1_en_0_port_out_0));
  design_1_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(hdmi_reset),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_0_clk_out1));
endmodule
