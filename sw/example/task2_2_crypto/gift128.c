// GIFT-128 block cipher
// Software round structure follows the official GIFT reference implementation.
#include "gift128.h"
#include <string.h>

#define GIFT128_ROUNDS 40

// Inverse of the official GIFT S-box [1,a,4,c,6,f,3,9,2,d,b,7,5,0,8,e]
static const uint8_t SBOX_INV[16] = {0xd,0x0,0x8,0x6,0x2,0xc,0x4,0xb,0xe,0x7,0x1,0xa,0x3,0x9,0xf,0x5};

static const uint8_t RCONST[40] = {
  0x01,0x03,0x07,0x0f,0x1f,0x3e,0x3d,0x3b,0x37,0x2f,
  0x1e,0x3c,0x39,0x33,0x27,0x0e,0x1d,0x3a,0x35,0x2b,
  0x16,0x2c,0x18,0x30,0x21,0x02,0x05,0x0b,0x17,0x2e,
  0x1c,0x38,0x31,0x23,0x06,0x0d,0x1b,0x36,0x2d,0x1a
};

static inline uint16_t ror16(uint16_t x, unsigned shift) {
  return (uint16_t)((x >> shift) | (x << (16u - shift)));
}

static inline uint32_t load_u32_be(const uint8_t src[4]) {
  return ((uint32_t)src[0] << 24) |
         ((uint32_t)src[1] << 16) |
         ((uint32_t)src[2] << 8)  |
         ((uint32_t)src[3]);
}

static inline void store_u32_be(uint8_t dst[4], uint32_t w) {
  dst[0] = (uint8_t)(w >> 24);
  dst[1] = (uint8_t)(w >> 16);
  dst[2] = (uint8_t)(w >> 8);
  dst[3] = (uint8_t)w;
}

static uint32_t rowperm(uint32_t s, int b0_pos, int b1_pos, int b2_pos, int b3_pos) {
  uint32_t t = 0;
  int b;

  for (b = 0; b < 8; b++) {
    t |= ((s >> (4 * b + 0)) & 1u) << (b + 8 * b0_pos);
    t |= ((s >> (4 * b + 1)) & 1u) << (b + 8 * b1_pos);
    t |= ((s >> (4 * b + 2)) & 1u) << (b + 8 * b2_pos);
    t |= ((s >> (4 * b + 3)) & 1u) << (b + 8 * b3_pos);
  }

  return t;
}

static uint32_t rowperm_inv(uint32_t s, int b0_pos, int b1_pos, int b2_pos, int b3_pos) {
  uint32_t t = 0;
  int b;

  for (b = 0; b < 8; b++) {
    t |= ((s >> (b + 8 * b0_pos)) & 1u) << (4 * b + 0);
    t |= ((s >> (b + 8 * b1_pos)) & 1u) << (4 * b + 1);
    t |= ((s >> (b + 8 * b2_pos)) & 1u) << (4 * b + 2);
    t |= ((s >> (b + 8 * b3_pos)) & 1u) << (4 * b + 3);
  }

  return t;
}

static void inv_subcells(uint32_t s[4]) {
  uint32_t next[4] = {0, 0, 0, 0};
  int i;

  for (i = 0; i < 32; i++) {
    uint8_t x = (uint8_t)(((s[0] >> i) & 1u) |
                          (((s[1] >> i) & 1u) << 1) |
                          (((s[2] >> i) & 1u) << 2) |
                          (((s[3] >> i) & 1u) << 3));
    uint8_t y = SBOX_INV[x];

    next[0] |= ((uint32_t)((y >> 0) & 1u)) << i;
    next[1] |= ((uint32_t)((y >> 1) & 1u)) << i;
    next[2] |= ((uint32_t)((y >> 2) & 1u)) << i;
    next[3] |= ((uint32_t)((y >> 3) & 1u)) << i;
  }

  s[0] = next[0];
  s[1] = next[1];
  s[2] = next[2];
  s[3] = next[3];
}

static void key_load_words(const uint8_t key[16], uint16_t w[8]) {
  int i;

  for (i = 0; i < 8; i++) {
    w[i] = (uint16_t)(((uint16_t)key[2 * i] << 8) | key[2 * i + 1]);
  }
}

static void key_update(uint16_t w[8]) {
  uint16_t t6 = ror16(w[6], 2);
  uint16_t t7 = ror16(w[7], 12);

  w[7] = w[5];
  w[6] = w[4];
  w[5] = w[3];
  w[4] = w[2];
  w[3] = w[1];
  w[2] = w[0];
  w[1] = t7;
  w[0] = t6;
}

static void round_keys_expand(const uint8_t key[16], uint32_t rk_s1[40], uint32_t rk_s2[40]) {
  uint16_t w[8];
  int r;

  key_load_words(key, w);

  for (r = 0; r < GIFT128_ROUNDS; r++) {
    rk_s2[r] = ((uint32_t)w[2] << 16) | w[3];
    rk_s1[r] = ((uint32_t)w[6] << 16) | w[7];
    key_update(w);
  }
}

void gift128_enc(const uint8_t key[16], const uint8_t pt[16], uint8_t ct[16]) {
  uint32_t s[4];
  uint16_t w[8];
  uint32_t t;
  int r;

  s[0] = load_u32_be(&pt[0]);
  s[1] = load_u32_be(&pt[4]);
  s[2] = load_u32_be(&pt[8]);
  s[3] = load_u32_be(&pt[12]);
  key_load_words(key, w);

  for (r = 0; r < GIFT128_ROUNDS; r++) {
    s[1] ^= s[0] & s[2];
    s[0] ^= s[1] & s[3];
    s[2] ^= s[0] | s[1];
    s[3] ^= s[2];
    s[1] ^= s[3];
    s[3] ^= 0xffffffffu;
    s[2] ^= s[0] & s[1];
    t = s[0];
    s[0] = s[3];
    s[3] = t;

    s[0] = rowperm(s[0], 0, 3, 2, 1);
    s[1] = rowperm(s[1], 1, 0, 3, 2);
    s[2] = rowperm(s[2], 2, 1, 0, 3);
    s[3] = rowperm(s[3], 3, 2, 1, 0);

    s[2] ^= ((uint32_t)w[2] << 16) | w[3];
    s[1] ^= ((uint32_t)w[6] << 16) | w[7];
    s[3] ^= 0x80000000u ^ (uint32_t)RCONST[r];

    key_update(w);
  }

  store_u32_be(&ct[0], s[0]);
  store_u32_be(&ct[4], s[1]);
  store_u32_be(&ct[8], s[2]);
  store_u32_be(&ct[12], s[3]);
}

void gift128_dec(const uint8_t key[16], const uint8_t ct[16], uint8_t pt[16]) {
  uint32_t s[4];
  uint32_t rk_s1[GIFT128_ROUNDS];
  uint32_t rk_s2[GIFT128_ROUNDS];
  int r;

  round_keys_expand(key, rk_s1, rk_s2);

  s[0] = load_u32_be(&ct[0]);
  s[1] = load_u32_be(&ct[4]);
  s[2] = load_u32_be(&ct[8]);
  s[3] = load_u32_be(&ct[12]);

  for (r = GIFT128_ROUNDS - 1; r >= 0; r--) {
    s[2] ^= rk_s2[r];
    s[1] ^= rk_s1[r];
    s[3] ^= 0x80000000u ^ (uint32_t)RCONST[r];

    s[0] = rowperm_inv(s[0], 0, 3, 2, 1);
    s[1] = rowperm_inv(s[1], 1, 0, 3, 2);
    s[2] = rowperm_inv(s[2], 2, 1, 0, 3);
    s[3] = rowperm_inv(s[3], 3, 2, 1, 0);

    inv_subcells(s);
  }

  store_u32_be(&pt[0], s[0]);
  store_u32_be(&pt[4], s[1]);
  store_u32_be(&pt[8], s[2]);
  store_u32_be(&pt[12], s[3]);
}
