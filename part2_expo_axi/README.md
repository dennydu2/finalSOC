# P2_BD_pongIP_AXI_S2026

AXI4-Lite wrapper around `P2_BD_pongIP_S2026`.

This wrapper lets NEORV32 `m_axi` control Pong switch inputs through a memory-mapped register.

## Ports

- AXI4-Lite slave:
  - `s00_axi_*`
- Video/control clocks:
  - `clk_25MHz`
  - `clk_125MHz`
  - `locked`
  - `rst_0_port_out` (active low, forwarded to Pong `rst_0`)
- HDMI outputs:
  - `hdmi_tx_0_tmds_*`
- 7-segment data lines (active-low):
  - `seven_seg_data_line_port_out[7:0]` as `{dp,g,f,e,d,c,b,a}`
  - `seven_seg_data_line2_port_out[7:0]` as `{dp,g,f,e,d,c,b,a}`
- Debug:
  - `sw_debug_port_out[4:0]`

## Register map

Base address is assigned in Vivado Address Editor.

- `0x00` - `CTRL` (RW)
  - bit 0 -> `i_Switch_0`
  - bit 1 -> `i_Switch_1`
  - bit 2 -> `i_Switch_2`
  - bit 3 -> `i_Switch_3`
  - bit 4 -> `i_Switch_4`
  - bits [3:0] also drive `seven_seg_data_line_port_out` as a hex digit
  - bits [7:4] also drive `seven_seg_data_line2_port_out` as a hex digit

## Vivado integration

1. Add sources:
   - `part2_expo_axi/src/P2_BD_pongIP_AXI_S2026.v`
   - existing `part2_expo` sources needed by `P2_BD_pongIP_S2026`
2. Package `P2_BD_pongIP_AXI_S2026.v` as a custom IP (AXI interface inferred from `s00_axi_*` naming).
3. In Block Design:
   - `main_smartconnect_0/M00_AXI` -> new IP `S00_AXI`
   - `s00_axi_aclk` -> AXI clock domain
   - `s00_axi_aresetn` -> AXI active-low reset
   - connect `clk_25MHz`, `clk_125MHz`, `locked`, `rst_0_port_out` same as your original Pong block
   - make `hdmi_tx_0` outputs external
