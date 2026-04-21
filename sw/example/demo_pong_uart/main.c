// ================================================================================ //
// The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              //
// Copyright (c) NEORV32 contributors.                                              //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

/**********************************************************************//**
 * @file demo_pong_uart/main.c
 * @brief Minimal UART terminal Pong using optional GPIO buttons.
 *
 * Controls:
 * - GPIO bit0/bit1: left paddle up/down
 * - GPIO bit2/bit3: right paddle up/down
 * - UART keys: w/s for left paddle, o/l for right paddle, r to reset game
 **************************************************************************/

#include <neorv32.h>

#define BAUD_RATE      19200
#define FRAME_TIME_MS  40

#define FIELD_W        40
#define FIELD_H        16
#define PADDLE_LEN     4
#define WIN_SCORE      9

static int clampi(int v, int lo, int hi) {
  if (v < lo) return lo;
  if (v > hi) return hi;
  return v;
}

static void draw_frame(int lp_y, int rp_y, int ball_x, int ball_y, int score_l, int score_r) {
  neorv32_uart0_printf("\x1b[H");
  neorv32_uart0_printf("NEORV32 UART Pong  |  Score %u : %u  |  First to %u\n", (uint32_t)score_l, (uint32_t)score_r, (uint32_t)WIN_SCORE);

  for (int y = 0; y < FIELD_H; y++) {
    for (int x = 0; x < FIELD_W; x++) {
      char c = ' ';

      if ((y == 0) || (y == (FIELD_H - 1))) {
        c = '#';
      }
      else if (x == 0 || x == (FIELD_W - 1)) {
        c = '#';
      }
      else if ((x == 2) && (y >= lp_y) && (y < (lp_y + PADDLE_LEN))) {
        c = '|';
      }
      else if ((x == (FIELD_W - 3)) && (y >= rp_y) && (y < (rp_y + PADDLE_LEN))) {
        c = '|';
      }
      else if ((x == ball_x) && (y == ball_y)) {
        c = 'O';
      }

      neorv32_uart0_putc(c);
    }
    neorv32_uart0_putc('\n');
  }

  neorv32_uart0_puts("Controls: GPIO[0:3] or keyboard w/s/o/l, reset=r\n");
}

static void reset_ball(int *ball_x, int *ball_y, int *vx, int *vy, int dir_x) {
  *ball_x = FIELD_W / 2;
  *ball_y = FIELD_H / 2;
  *vx = dir_x;
  *vy = (neorv32_aux_xorshift32() & 1) ? 1 : -1;
}

int main() {

  int score_l = 0;
  int score_r = 0;

  int lp_y = (FIELD_H - PADDLE_LEN) / 2;
  int rp_y = (FIELD_H - PADDLE_LEN) / 2;

  int ball_x = FIELD_W / 2;
  int ball_y = FIELD_H / 2;
  int vx = 1;
  int vy = 1;

  neorv32_rte_setup();

  if (neorv32_uart0_available() == 0) {
    return 1;
  }
  neorv32_uart0_setup(BAUD_RATE, 0);

  neorv32_uart0_puts("\x1b[2J\x1b[H");
  neorv32_uart0_puts("Starting Pong...\n");

  if (neorv32_gpio_available()) {
    neorv32_gpio_port_set(0);
    neorv32_gpio_dir_set(0x000000FFu);
  }

  while (1) {

    int l_up = 0, l_down = 0, r_up = 0, r_down = 0;

    if (neorv32_gpio_available()) {
      uint32_t gp = neorv32_gpio_port_get();
      l_up   = (gp >> 0) & 1;
      l_down = (gp >> 1) & 1;
      r_up   = (gp >> 2) & 1;
      r_down = (gp >> 3) & 1;
    }

    if (neorv32_uart0_char_received()) {
      char c = neorv32_uart0_char_received_get();
      if (c == 'w' || c == 'W') l_up = 1;
      if (c == 's' || c == 'S') l_down = 1;
      if (c == 'o' || c == 'O') r_up = 1;
      if (c == 'l' || c == 'L') r_down = 1;
      if (c == 'r' || c == 'R') {
        score_l = 0;
        score_r = 0;
        lp_y = (FIELD_H - PADDLE_LEN) / 2;
        rp_y = (FIELD_H - PADDLE_LEN) / 2;
        reset_ball(&ball_x, &ball_y, &vx, &vy, 1);
      }
    }

    lp_y += l_down - l_up;
    rp_y += r_down - r_up;
    lp_y = clampi(lp_y, 1, FIELD_H - PADDLE_LEN - 1);
    rp_y = clampi(rp_y, 1, FIELD_H - PADDLE_LEN - 1);

    int nx = ball_x + vx;
    int ny = ball_y + vy;

    if (ny <= 1 || ny >= (FIELD_H - 2)) {
      vy = -vy;
      ny = ball_y + vy;
    }

    if ((nx == 3) && (ny >= lp_y) && (ny < (lp_y + PADDLE_LEN))) {
      vx = 1;
      ny += (ny - (lp_y + (PADDLE_LEN / 2)));
    }
    if ((nx == (FIELD_W - 4)) && (ny >= rp_y) && (ny < (rp_y + PADDLE_LEN))) {
      vx = -1;
      ny += (ny - (rp_y + (PADDLE_LEN / 2)));
    }

    ny = clampi(ny, 1, FIELD_H - 2);
    nx = ball_x + vx;

    if (nx <= 1) {
      score_r++;
      reset_ball(&ball_x, &ball_y, &vx, &vy, 1);
    }
    else if (nx >= (FIELD_W - 2)) {
      score_l++;
      reset_ball(&ball_x, &ball_y, &vx, &vy, -1);
    }
    else {
      ball_x = nx;
      ball_y = ny;
    }

    if (score_l >= WIN_SCORE || score_r >= WIN_SCORE) {
      draw_frame(lp_y, rp_y, ball_x, ball_y, score_l, score_r);
      neorv32_uart0_printf("\nWinner: %s player! Press 'r' to restart.\n", (score_l > score_r) ? "Left" : "Right");
      while (1) {
        if (neorv32_uart0_char_received()) {
          char c = neorv32_uart0_char_received_get();
          if (c == 'r' || c == 'R') {
            score_l = 0;
            score_r = 0;
            lp_y = (FIELD_H - PADDLE_LEN) / 2;
            rp_y = (FIELD_H - PADDLE_LEN) / 2;
            reset_ball(&ball_x, &ball_y, &vx, &vy, 1);
            break;
          }
        }
      }
    }

    if (neorv32_gpio_available()) {
      uint32_t leds = ((uint32_t)(score_r & 0x0F) << 4) | (uint32_t)(score_l & 0x0F);
      neorv32_gpio_port_set(leds);
    }

    draw_frame(lp_y, rp_y, ball_x, ball_y, score_l, score_r);
    neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), FRAME_TIME_MS);
  }

  return 0;
}
