// ================================================================================ //
// The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              //
// Copyright (c) NEORV32 contributors.                                              //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

/**********************************************************************//**
 * @file demo_pong_axi_gpio/main.c
 * @brief Read NEORV32 GPIO inputs and forward them to the AXI Pong control register.
 *
 * GPIO input mapping (active-high):
 * - bit 0: player 1 up
 * - bit 1: player 1 down
 * - bit 2: player 2 up
 * - bit 3: player 2 down
 *
 * AXI Pong control register mapping (slv_reg0 @ offset 0x00):
 * - bit 0: i_Switch_0 (P1 up)
 * - bit 1: i_Switch_1 (P1 down)
 * - bit 2: i_Switch_2 (P2 up)
 * - bit 3: i_Switch_3 (P2 down)
 * - bit 4: i_Switch_4 (spare / enable, kept high here)
 * - bit 9:8 seven_seg_enabler_port_out
 * - bit 7:4 and 3:0 drive two 7-seg data outputs in the wrapper
 *
 * IMPORTANT: Set PONG_AXI_BASE_ADDR to the address assigned in Vivado Address Editor.
 **************************************************************************/

#include <neorv32.h>
#include <stdint.h>

#define BAUD_RATE 19200

// Replace this with the real base address from Vivado Address Editor.
#define PONG_AXI_BASE_ADDR 0x40000000u
#define PONG_CTRL_REG_OFS  0x00u

static inline void pong_write_ctrl(uint32_t value) {
  volatile uint32_t *ctrl = (volatile uint32_t *)(uintptr_t)(PONG_AXI_BASE_ADDR + PONG_CTRL_REG_OFS);
  *ctrl = value;
}

int main(void) {

  neorv32_rte_setup();

  if (neorv32_uart0_available()) {
    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_puts("\nGPIO -> AXI Pong controller\n");
    neorv32_uart0_printf("PONG AXI base = 0x%x\n", (uint32_t)PONG_AXI_BASE_ADDR);
  }

  if (neorv32_gpio_available() == 0) {
    if (neorv32_uart0_available()) {
      neorv32_uart0_puts("[ERROR] GPIO is not available in this build.\n");
    }
    return 1;
  }

  // All GPIO pins as input so board buttons/switches can be sampled.
  neorv32_gpio_dir_set(0x00000000u);

  uint32_t last_ctrl = 0xffffffffu;

  while (1) {
    uint32_t gpio_in = neorv32_gpio_port_get();

    // Read four control bits for 2-player paddle movement.
    uint32_t p1_up   = (gpio_in >> 0) & 1u;
    uint32_t p1_down = (gpio_in >> 1) & 1u;
    uint32_t p2_up   = (gpio_in >> 2) & 1u;
    uint32_t p2_down = (gpio_in >> 3) & 1u;

    // If both directions are pressed for the same player, ignore both.
    if (p1_up && p1_down) {
      p1_up = 0u;
      p1_down = 0u;
    }
    if (p2_up && p2_down) {
      p2_up = 0u;
      p2_down = 0u;
    }

    uint32_t ctrl = 0u;
    ctrl |= (p1_up   << 0);
    ctrl |= (p1_down << 1);
    ctrl |= (p2_up   << 2);
    ctrl |= (p2_down << 3);
    ctrl |= (1u      << 4); // keep i_Switch_4 asserted

    // Mirror control nibble to both 7-seg data nibbles for quick visual debug.
    ctrl |= ((ctrl & 0x0fu) << 4);

    // Enable both seven-segment digits: en[1:0] = 2'b11.
    ctrl |= (0x3u << 8);

    pong_write_ctrl(ctrl);

    if ((ctrl != last_ctrl) && neorv32_uart0_available()) {
      neorv32_uart0_printf("GPIO_IN=0x%x -> PONG_CTRL=0x%x\n", gpio_in, ctrl);
      last_ctrl = ctrl;
    }

    neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), 5);
  }

  return 0;
}
