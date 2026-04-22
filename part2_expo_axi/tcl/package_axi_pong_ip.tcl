# Package P2_BD_pongIP_AXI_S2026 as a custom Vivado IP.
# Run from Vivado Tcl console with an open project.
# Usage:
#   source c:/Users/denny/OneDrive/Documents/GitHub/finalSOC/part2_expo_axi/tcl/package_axi_pong_ip.tcl
#   package_axi_pong_ip

proc package_axi_pong_ip {} {
  if {[current_project -quiet] eq ""} {
    error "Open your Vivado project first (final.xpr)."
  }

  set repo_root [file normalize "c:/Users/denny/OneDrive/Documents/GitHub/finalSOC"]
  set ip_root   [file normalize "$repo_root/part2_expo_axi"]
  set work_dir  [file normalize "$ip_root/.ip_pack"]
  set comp_xml  [file normalize "$ip_root/component.xml"]

  file mkdir $work_dir

  # Start from a clean component definition to avoid stale port metadata.
  if {[file exists $comp_xml]} {
    file delete -force $comp_xml
  }
  if {[file exists [file normalize "$ip_root/xgui"]]} {
    file delete -force [file normalize "$ip_root/xgui"]
  }

  # Temporary in-memory project for IP packaging.
  create_project -in_memory -part [get_property PART [current_project]]

  # Wrapper source.
  add_files -norecurse [file normalize "$ip_root/src/P2_BD_pongIP_AXI_S2026.v"]

  # Include Pong and HDMI implementation sources used by the wrapper.
  foreach f [glob -nocomplain [file normalize "$repo_root/part2_expo/src/*.v"]] {
    add_files -norecurse $f
  }
  foreach f [glob -nocomplain [file normalize "$repo_root/part2_expo/src/*.vhd"]] {
    add_files -norecurse $f
  }
  foreach f [glob -nocomplain [file normalize "$repo_root/part2_expo/hdmi_tx_1.0/hdl/*.v"]] {
    add_files -norecurse $f
  }

  set_property top P2_BD_pongIP_AXI_S2026 [current_fileset]
  update_compile_order -fileset sources_1

  # Package into part2_expo_axi folder directly from current RTL files.
  ipx::package_project -root_dir $ip_root -vendor xilinx.com -library user -taxonomy /UserIP -import_files -set_current true

  set core [ipx::current_core]
  set_property name P2_BD_pongIP_AXI_S2026 $core
  set_property display_name {P2_BD_pongIP_AXI_S2026} $core
  set_property description {AXI-controlled Pong HDMI wrapper with dual 7-line seven-segment outputs} $core
  set_property version 1.2 $core
  set_property core_revision [clock seconds] $core

  # Infer AXI interface from s00_axi_* naming.
  ipx::infer_bus_interface s00_axi xilinx.com:interface:aximm_rtl:1.0 $core
  ipx::associate_bus_interfaces -busif s00_axi -clock s00_axi_aclk $core

  # Ensure required user clocks/resets are plain ports.
  ipx::update_source_project_archive $core
  ipx::check_integrity -quiet $core
  ipx::save_core $core
  ipx::unload_core $core
  close_project -delete

  # Add repository and refresh catalog in the user's real project.
  set_property ip_repo_paths [list $ip_root [file normalize "$repo_root/part2_expo"]] [current_project]
  update_ip_catalog

  puts "INFO: Packaged IP at $ip_root"
  puts "INFO: You can now run: add_axi_pong_to_bd design_1"
}
