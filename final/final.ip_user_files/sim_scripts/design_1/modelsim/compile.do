vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/proc_sys_reset_v5_0_17
vlib modelsim_lib/msim/xlconstant_v1_1_10
vlib modelsim_lib/msim/smartconnect_v1_0
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_35
vlib modelsim_lib/msim/axi_vip_v1_1_21
vlib modelsim_lib/msim/neorv32

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap proc_sys_reset_v5_0_17 modelsim_lib/msim/proc_sys_reset_v5_0_17
vmap xlconstant_v1_1_10 modelsim_lib/msim/xlconstant_v1_1_10
vmap smartconnect_v1_0 modelsim_lib/msim/smartconnect_v1_0
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_35 modelsim_lib/msim/axi_register_slice_v2_1_35
vmap axi_vip_v1_1_21 modelsim_lib/msim/axi_vip_v1_1_21
vmap neorv32 modelsim_lib/msim/neorv32

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.v" \

vcom -work proc_sys_reset_v5_0_17  -93  \
"../../../../final.gen/sources_1/bd/design_1/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_proc_sys_reset_0_0/sim/design_1_proc_sys_reset_0_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/sim/bd_892d.v" \

vlog -work xlconstant_v1_1_10  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/a165/hdl/xlconstant_v1_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_0/sim/bd_892d_one_0.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_1/sim/bd_892d_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/3718/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_2/sim/bd_892d_arinsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_3/sim/bd_892d_rinsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_4/sim/bd_892d_awinsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_5/sim/bd_892d_winsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_6/sim/bd_892d_binsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_7/sim/bd_892d_aroutsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_8/sim/bd_892d_routsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_9/sim/bd_892d_awoutsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_10/sim/bd_892d_woutsw_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_11/sim/bd_892d_boutsw_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_12/sim/bd_892d_arni_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_13/sim/bd_892d_rni_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_14/sim/bd_892d_awni_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_15/sim/bd_892d_wni_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_16/sim/bd_892d_bni_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/d800/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_17/sim/bd_892d_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/2da8/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_18/sim/bd_892d_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/dce3/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_19/sim/bd_892d_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/cef3/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_20/sim/bd_892d_s00a2s_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_21/sim/bd_892d_sarn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_22/sim/bd_892d_srn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_23/sim/bd_892d_sawn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_24/sim/bd_892d_swn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_25/sim/bd_892d_sbn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/7f4f/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_26/sim/bd_892d_m00s2a_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_27/sim/bd_892d_m00arn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_28/sim/bd_892d_m00rn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_29/sim/bd_892d_m00awn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_30/sim/bd_892d_m00wn_0.sv" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_31/sim/bd_892d_m00bn_0.sv" \

vlog -work smartconnect_v1_0  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/0133/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/bd_0/ip/ip_32/sim/bd_892d_m00e_0.sv" \

vlog -work axi_infrastructure_v1_1_0  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_35  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/c5b7/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_21  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../final.gen/sources_1/bd/design_1/ipshared/f16f/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_smartconnect_0_2/sim/design_1_smartconnect_0_2.sv" \

vcom -work neorv32  -93  \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_package.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_bootrom.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_bootrom_image.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_bootrom_rom.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_bus.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_prim.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cache.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cache_ram.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cfs.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_clint.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_decompressor.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_frontend.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_control.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_hwtrig.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_counters.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_regfile.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_shifter.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_muldiv.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_bitmanip.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_fpu.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_cfu.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_cond.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu_crypto.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_alu.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_lsu.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_pmp.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu_trace.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_cpu.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_debug_auth.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_debug_dm.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_debug_dtm.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_dma.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_dmem.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_dmem_ram.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_gpio.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_gptmr.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_imem.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_imem_image.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_imem_ram.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_imem_rom.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_neoled.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_onewire.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_pwm.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_sdi.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_slink.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_spi.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_sys.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_sysinfo.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_xbus.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_wdt.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_uart.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_twi.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_twd.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_trng.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_tracer.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32/neorv32_top.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ipshared/9444/src/xbus2axi4_bridge.vhd" \
"../../../bd/design_1/ipshared/9444/src/neorv32_vivado_ip.vhd" \
"../../../bd/design_1/ip/design_1_neorv32_vivado_ip_0_3/sim/design_1_neorv32_vivado_ip_0_3.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_AXI_S2026.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Debounce_Switch_0_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Debounce_Switch_1_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Debounce_Switch_2_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Debounce_Switch_3_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Debounce_Switch_4_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Pong_Top2_0_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_Sync_To_Count2_0_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_VGA_Sync_Porch_0_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/P2_BD_pongIP_S2026_VGA_Sync_Pulses_0_0.v" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_1/ipshared/7a7c/src/Debounce_Switch.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/Pong_Ball_Ctrl.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/Pong_Paddle_Ctrl.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/Pong_Pkg.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/Pong_Top2.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/Sync_To_Count.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/Sync_To_Count2.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/VGA_Sync_Porch.vhd" \
"../../../bd/design_1/ipshared/7a7c/src/VGA_Sync_Pulses.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a9be" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+../../../../final.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/7a7c/src/encode.v" \
"../../../bd/design_1/ipshared/7a7c/src/hdmi_tx_v1_0.v" \
"../../../bd/design_1/ipshared/7a7c/src/serdes_10_to_1.v" \
"../../../bd/design_1/ipshared/7a7c/src/srldelay.v" \
"../../../bd/design_1/ip/design_1_pong_axi_0_1/sim/design_1_pong_axi_0_1.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

