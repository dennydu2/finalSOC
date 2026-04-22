# Add and wire P2_BD_pongIP_AXI_S2026 into an open block design.
# Expected existing cells in BD:
#   - main_smartconnect_0
#   - clk_wiz_0
#   - proc_sys_reset_0
#
# Usage:
#   source <repo>/part2_expo_axi/tcl/add_axi_pong_to_bd.tcl
#   add_axi_pong_to_bd design_1

proc _require_bd_obj {obj_path kind} {
  set o [get_bd_${kind}s -quiet $obj_path]
  if {[llength $o] == 0} {
    error "Missing BD $kind: $obj_path"
  }
}

proc add_axi_pong_to_bd {{design_name design_1}} {
  current_bd_design $design_name

  _require_bd_obj main_smartconnect_0 cell
  _require_bd_obj clk_wiz_0 cell
  _require_bd_obj proc_sys_reset_0 cell

  set ipdefs [lsort -decreasing -dictionary [get_ipdefs -all xilinx.com:user:P2_BD_pongIP_AXI_S2026:*]]
  if {[llength $ipdefs] == 0} {
    error "P2_BD_pongIP_AXI_S2026 IP not found in catalog. Package/add repository first."
  }

  set existing_pong [get_bd_cells -quiet pong_axi_0]
  if {[llength $existing_pong] > 0} {
    delete_bd_objs $existing_pong
  }
  set pong_axi [create_bd_cell -type ip -vlnv [lindex $ipdefs 0] pong_axi_0]

  # AXI link
  connect_bd_intf_net [get_bd_intf_pins main_smartconnect_0/M00_AXI] [get_bd_intf_pins ${pong_axi}/S00_AXI]

  # AXI clock/reset
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins ${pong_axi}/s00_axi_aclk]
  connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ${pong_axi}/s00_axi_aresetn]

  # Pong video clocks/reset
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins ${pong_axi}/clk_25MHz]
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins ${pong_axi}/clk_125MHz]
  connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins ${pong_axi}/locked]
  connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins ${pong_axi}/rst_0_port_out]

  # Export HDMI interface if not already exported
  if {[llength [get_bd_intf_ports -quiet hdmi_tx_0_0]] == 0} {
    set ext_if [make_bd_intf_pins_external [get_bd_intf_pins ${pong_axi}/hdmi_tx_0]]
    if {[llength $ext_if] > 0} {
      set if_obj [lindex $ext_if 0]
      if {[get_property NAME $if_obj] ne "hdmi_tx_0_0"} {
        rename_bd_objs $if_obj hdmi_tx_0_0
      }
    }
  }

  # Export seven-segment ports so they are visible at BD top level.
  if {[llength [get_bd_ports -quiet seven_seg_data_line_port_out_0]] == 0} {
    set p [make_bd_pins_external [get_bd_pins ${pong_axi}/seven_seg_data_line_port_out]]
    if {[llength $p] > 0} {
      rename_bd_objs [lindex $p 0] seven_seg_data_line_port_out_0
    }
  }

  if {[llength [get_bd_ports -quiet seven_seg_data_line2_port_out_0]] == 0} {
    set p [make_bd_pins_external [get_bd_pins ${pong_axi}/seven_seg_data_line2_port_out]]
    if {[llength $p] > 0} {
      rename_bd_objs [lindex $p 0] seven_seg_data_line2_port_out_0
    }
  }

  if {[llength [get_bd_ports -quiet seven_seg_enabler_port_out_0]] == 0} {
    set p [make_bd_pins_external [get_bd_pins ${pong_axi}/seven_seg_enabler_port_out]]
    if {[llength $p] > 0} {
      rename_bd_objs [lindex $p 0] seven_seg_enabler_port_out_0
    }
  }

  validate_bd_design
  save_bd_design

  puts "INFO: Added pong_axi_0 and connected to main_smartconnect_0/M00_AXI."
}
