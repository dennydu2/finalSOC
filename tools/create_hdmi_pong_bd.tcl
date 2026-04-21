# Vivado Tcl script to create a NEORV32 + HDMI Pong block design.
# Usage in Vivado Tcl console:
#   cd <repo_root>/final
#   source ../tools/create_hdmi_pong_bd.tcl
#   create_hdmi_pong_bd design_1

proc _require_ip {pattern friendly_name} {
  set defs [get_ipdefs -all $pattern]
  if {[llength $defs] == 0} {
    error "Missing IP: $friendly_name ($pattern). Add the IP repository first."
  }
}

proc _delete_bd_if_exists {design_name} {
  set existing [get_files -quiet "*/bd/${design_name}/${design_name}.bd"]
  if {[llength $existing] > 0} {
    puts "INFO: Removing existing BD '$design_name'"
    foreach f $existing {
      remove_files -quiet $f
    }
  }
}

proc create_hdmi_pong_bd {{design_name design_1}} {
  if {[current_project -quiet] eq ""} {
    error "No open Vivado project. Open final.xpr first."
  }

  # Add Pong IP repo from this repository.
  set script_dir [file dirname [file normalize [info script]]]
  set repo_root  [file normalize "$script_dir/.."]
  set pong_repo  [file normalize "$repo_root/part2_expo"]

  if {![file exists $pong_repo]} {
    error "Pong IP repository not found at: $pong_repo"
  }

  set_property ip_repo_paths [list $pong_repo] [current_project]
  update_ip_catalog

  _require_ip "NEORV32:user:neorv32_vivado_ip:*" "NEORV32 Vivado IP"
  _require_ip "xilinx.com:ip:clk_wiz:*" "Clocking Wizard"
  _require_ip "xilinx.com:ip:proc_sys_reset:*" "Processor System Reset"
  _require_ip "xilinx.com:user:P2_BD_pongIP_S2026:*" "P2_BD_pongIP_S2026"
  _require_ip "xilinx.com:ip:xlslice:*" "XLSLICE"

  _delete_bd_if_exists $design_name

  create_bd_design $design_name
  current_bd_design $design_name

  # Top-level ports.
  set p_clk100  [create_bd_port -dir I -type clk clk_100MHz]
  set_property -dict [list CONFIG.FREQ_HZ {100000000}] $p_clk100
  set p_reset   [create_bd_port -dir I -type rst reset_rtl_0]
  set_property -dict [list CONFIG.POLARITY {ACTIVE_HIGH}] $p_reset

  set p_uart_rx [create_bd_port -dir I uart0_rxd_i_0]
  set p_uart_tx [create_bd_port -dir O uart0_txd_o_0]
  set p_gpio_i  [create_bd_port -dir I -from 7 -to 0 gpio_i_0]
  set p_gpio_o  [create_bd_port -dir O -from 7 -to 0 gpio_o_0]

  # Core IP blocks.
  set clk_wiz_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0]
  set_property -dict [list \
    CONFIG.PRIM_IN_FREQ {100.000} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25.000} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {125.000} \
  ] $clk_wiz_0

  set proc_sys_reset_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0]

  set neorv32_vivado_ip_0 [create_bd_cell -type ip -vlnv NEORV32:user:neorv32_vivado_ip:1.0 neorv32_vivado_ip_0]
  set_property -dict [list \
    CONFIG.CLOCK_FREQUENCY {100000000} \
    CONFIG.IO_UART0_EN {true} \
    CONFIG.IO_GPIO_EN {true} \
    CONFIG.IO_GPIO_IN_NUM {8} \
    CONFIG.IO_GPIO_OUT_NUM {8} \
  ] $neorv32_vivado_ip_0

  set pong_0 [create_bd_cell -type ip -vlnv xilinx.com:user:P2_BD_pongIP_S2026:1.0 pong_0]

  # Slice NEORV32 GPIO outputs into 5 switch control bits for Pong.
  set slices {}
  for {set i 0} {$i < 5} {incr i} {
    set s [create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 gpio_slice_$i]
    set_property -dict [list CONFIG.DIN_WIDTH {8} CONFIG.DIN_FROM $i CONFIG.DIN_TO $i] $s
    lappend slices $s
  }

  # Clock and reset routing.
  connect_bd_net $p_clk100 [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net $p_reset  [get_bd_pins clk_wiz_0/reset]
  connect_bd_net $p_reset  [get_bd_pins proc_sys_reset_0/ext_reset_in]

  connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net [get_bd_pins clk_wiz_0/locked]   [get_bd_pins proc_sys_reset_0/dcm_locked]

  connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins neorv32_vivado_ip_0/clk]
  connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins neorv32_vivado_ip_0/resetn]

  connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins pong_0/clk_25MHz]
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins pong_0/clk_125MHz]
  connect_bd_net [get_bd_pins clk_wiz_0/locked]   [get_bd_pins pong_0/locked]
  connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins pong_0/rst_0]

  # GPIO and UART routing.
  connect_bd_net $p_gpio_i [get_bd_pins neorv32_vivado_ip_0/gpio_i]
  connect_bd_net [get_bd_pins neorv32_vivado_ip_0/gpio_o] $p_gpio_o
  connect_bd_net $p_uart_rx [get_bd_pins neorv32_vivado_ip_0/uart0_rxd_i]
  connect_bd_net [get_bd_pins neorv32_vivado_ip_0/uart0_txd_o] $p_uart_tx

  # Connect gpio_o[4:0] -> Pong switch inputs.
  foreach s $slices {
    connect_bd_net [get_bd_pins neorv32_vivado_ip_0/gpio_o] [get_bd_pins ${s}/Din]
  }
  connect_bd_net [get_bd_pins [lindex $slices 0]/Dout] [get_bd_pins pong_0/i_Switch_0]
  connect_bd_net [get_bd_pins [lindex $slices 1]/Dout] [get_bd_pins pong_0/i_Switch_1]
  connect_bd_net [get_bd_pins [lindex $slices 2]/Dout] [get_bd_pins pong_0/i_Switch_2]
  connect_bd_net [get_bd_pins [lindex $slices 3]/Dout] [get_bd_pins pong_0/i_Switch_3]
  connect_bd_net [get_bd_pins [lindex $slices 4]/Dout] [get_bd_pins pong_0/i_Switch_4]

  # Export HDMI interface from Pong.
  set hdmi_if [make_bd_intf_pins_external [get_bd_intf_pins pong_0/hdmi_tx_0]]
  if {[llength $hdmi_if] > 0} {
    set if_obj [lindex $hdmi_if 0]
    set if_name [get_property NAME $if_obj]
    if {$if_name ne "hdmi_tx_0_0"} {
      rename_bd_objs $if_obj hdmi_tx_0_0
    }
  }

  validate_bd_design
  save_bd_design

  puts "INFO: Block design '$design_name' created successfully."
  puts "INFO: Next: create HDL wrapper, then run synthesis/implementation."
}
