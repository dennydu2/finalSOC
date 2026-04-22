// AES-128 accelerated with RISC-V Zkne/Zknd scalar crypto ISA (RV32)
// Requires -march=...zkne_zknd in the toolchain
#ifndef AES_ISA_H
#define AES_ISA_H
#include <stdint.h>
#include <neorv32_intrinsics.h>

// ---- RISC-V Zk instruction encodings via .insn r ----
// aes32esmi rd,rs1,rs2,bs : 00|bs|10001|rs2|rs1|000|rd|0110011
#define AES32ESMI(rs1,rs2,bs) RISCV_INSTR_R_TYPE(0x33,0,((bs)<<5)|0x13,(rs1),(rs2))
// aes32esi rd,rs1,rs2,bs  : 00|bs|10000|rs2|rs1|000|rd|0110011
#define AES32ESI(rs1,rs2,bs)  RISCV_INSTR_R_TYPE(0x33,0,((bs)<<5)|0x11,(rs1),(rs2))
// aes32dsmi rd,rs1,rs2,bs : 00|bs|10111|rs2|rs1|000|rd|0110011
#define AES32DSMI(rs1,rs2,bs) RISCV_INSTR_R_TYPE(0x33,0,((bs)<<5)|0x17,(rs1),(rs2))
// aes32dsi rd,rs1,rs2,bs  : 00|bs|10110|rs2|rs1|000|rd|0110011
#define AES32DSI(rs1,rs2,bs)  RISCV_INSTR_R_TYPE(0x33,0,((bs)<<5)|0x15,(rs1),(rs2))

static inline uint32_t __attribute__((always_inline)) aes_load_le(const uint8_t src[4]) {
  return ((uint32_t)src[0])       |
         ((uint32_t)src[1] << 8)  |
         ((uint32_t)src[2] << 16) |
         ((uint32_t)src[3] << 24);
}

static inline void __attribute__((always_inline)) aes_store_le(uint8_t dst[4], uint32_t w) {
  dst[0] = (uint8_t)(w);
  dst[1] = (uint8_t)(w >> 8);
  dst[2] = (uint8_t)(w >> 16);
  dst[3] = (uint8_t)(w >> 24);
}

static inline uint8_t __attribute__((always_inline)) aes_xtime(uint8_t a) {
  return (uint8_t)((a << 1) ^ ((a & 0x80u) ? 0x1bu : 0u));
}

static inline uint8_t __attribute__((always_inline)) aes_gmul(uint8_t a, uint8_t b) {
  uint8_t r = 0;

  while (b) {
    if (b & 1u) {
      r ^= a;
    }
    a = aes_xtime(a);
    b >>= 1;
  }

  return r;
}

static inline uint32_t __attribute__((always_inline)) aes_invmix_column(uint32_t w) {
  uint8_t a0 = (uint8_t)(w);
  uint8_t a1 = (uint8_t)(w >> 8);
  uint8_t a2 = (uint8_t)(w >> 16);
  uint8_t a3 = (uint8_t)(w >> 24);

  return ((uint32_t)(aes_gmul(a0, 0x0e) ^ aes_gmul(a1, 0x0b) ^ aes_gmul(a2, 0x0d) ^ aes_gmul(a3, 0x09))) |
         ((uint32_t)(aes_gmul(a0, 0x09) ^ aes_gmul(a1, 0x0e) ^ aes_gmul(a2, 0x0b) ^ aes_gmul(a3, 0x0d)) << 8) |
         ((uint32_t)(aes_gmul(a0, 0x0d) ^ aes_gmul(a1, 0x09) ^ aes_gmul(a2, 0x0e) ^ aes_gmul(a3, 0x0b)) << 16) |
         ((uint32_t)(aes_gmul(a0, 0x0b) ^ aes_gmul(a1, 0x0d) ^ aes_gmul(a2, 0x09) ^ aes_gmul(a3, 0x0e)) << 24);
}

// SubWord(RotWord(w)) used in key schedule
static inline uint32_t __attribute__((always_inline)) aes_subrotword(uint32_t w) {
  uint32_t r = (w >> 8) | (w << 24); // RotWord on little-endian word layout
  uint32_t sw = AES32ESI(0u, r, 0);
  sw = AES32ESI(sw, r, 1);
  sw = AES32ESI(sw, r, 2);
  sw = AES32ESI(sw, r, 3);
  return sw;
}

// Round constants
static const uint32_t aes_rcon_isa[10] = {
  0x00000001,0x00000002,0x00000004,0x00000008,0x00000010,
  0x00000020,0x00000040,0x00000080,0x0000001b,0x00000036
};

// AES-128 key schedule (column-major, little-endian words)
static inline void aes128_isa_key_schedule(const uint8_t key[16], uint32_t rk[44]) {
  int i;
  for (i = 0; i < 4; i++) {
    rk[i] = aes_load_le(&key[4 * i]);
  }
  for (i = 4; i < 44; i += 4) {
    uint32_t t = aes_subrotword(rk[i-1]) ^ aes_rcon_isa[i/4-1];
    rk[i+0] = rk[i-4] ^ t;
    rk[i+1] = rk[i-3] ^ rk[i+0];
    rk[i+2] = rk[i-2] ^ rk[i+1];
    rk[i+3] = rk[i-1] ^ rk[i+2];
  }
}

// AES-128 encrypt using Zkne
static inline void aes128_isa_enc(const uint8_t key[16], const uint8_t pt[16], uint8_t ct[16]) {
  uint32_t rk[44];
  uint32_t s0, s1, s2, s3, t0, t1, t2, t3;
  int r;

  aes128_isa_key_schedule(key, rk);

  s0 = aes_load_le(&pt[0]);
  s1 = aes_load_le(&pt[4]);
  s2 = aes_load_le(&pt[8]);
  s3 = aes_load_le(&pt[12]);

  // Initial AddRoundKey
  s0^=rk[0]; s1^=rk[1]; s2^=rk[2]; s3^=rk[3];

  // 9 middle rounds
  for (r = 1; r <= 9; r++) {
    t0 = rk[4*r+0];
    t0 = AES32ESMI(t0,s0,0); t0 = AES32ESMI(t0,s1,1);
    t0 = AES32ESMI(t0,s2,2); t0 = AES32ESMI(t0,s3,3);

    t1 = rk[4*r+1];
    t1 = AES32ESMI(t1,s1,0); t1 = AES32ESMI(t1,s2,1);
    t1 = AES32ESMI(t1,s3,2); t1 = AES32ESMI(t1,s0,3);

    t2 = rk[4*r+2];
    t2 = AES32ESMI(t2,s2,0); t2 = AES32ESMI(t2,s3,1);
    t2 = AES32ESMI(t2,s0,2); t2 = AES32ESMI(t2,s1,3);

    t3 = rk[4*r+3];
    t3 = AES32ESMI(t3,s3,0); t3 = AES32ESMI(t3,s0,1);
    t3 = AES32ESMI(t3,s1,2); t3 = AES32ESMI(t3,s2,3);

    s0=t0; s1=t1; s2=t2; s3=t3;
  }

  // Final round (no MixColumns)
  t0 = rk[40];
  t0 = AES32ESI(t0,s0,0); t0 = AES32ESI(t0,s1,1);
  t0 = AES32ESI(t0,s2,2); t0 = AES32ESI(t0,s3,3);

  t1 = rk[41];
  t1 = AES32ESI(t1,s1,0); t1 = AES32ESI(t1,s2,1);
  t1 = AES32ESI(t1,s3,2); t1 = AES32ESI(t1,s0,3);

  t2 = rk[42];
  t2 = AES32ESI(t2,s2,0); t2 = AES32ESI(t2,s3,1);
  t2 = AES32ESI(t2,s0,2); t2 = AES32ESI(t2,s1,3);

  t3 = rk[43];
  t3 = AES32ESI(t3,s3,0); t3 = AES32ESI(t3,s0,1);
  t3 = AES32ESI(t3,s1,2); t3 = AES32ESI(t3,s2,3);

  aes_store_le(&ct[0], t0);
  aes_store_le(&ct[4], t1);
  aes_store_le(&ct[8], t2);
  aes_store_le(&ct[12], t3);
}

// AES-128 decrypt using Zknd (equivalent inverse cipher)
static inline void aes128_isa_dec(const uint8_t key[16], const uint8_t ct[16], uint8_t pt[16]) {
  uint32_t rk[44];
  uint32_t drk[44];
  uint32_t s0, s1, s2, s3, t0, t1, t2, t3;
  int r, c;

  aes128_isa_key_schedule(key, rk);

  for (c = 0; c < 4; c++) {
    drk[c] = rk[40 + c];
    drk[40 + c] = rk[c];
  }
  for (r = 1; r <= 9; r++) {
    for (c = 0; c < 4; c++) {
      drk[4 * r + c] = aes_invmix_column(rk[4 * (10 - r) + c]);
    }
  }

  s0 = aes_load_le(&ct[0]);
  s1 = aes_load_le(&ct[4]);
  s2 = aes_load_le(&ct[8]);
  s3 = aes_load_le(&ct[12]);

  s0^=drk[0]; s1^=drk[1]; s2^=drk[2]; s3^=drk[3];

  for (r = 1; r <= 9; r++) {
    t0 = drk[4*r+0];
    t0 = AES32DSMI(t0,s0,0); t0 = AES32DSMI(t0,s3,1);
    t0 = AES32DSMI(t0,s2,2); t0 = AES32DSMI(t0,s1,3);

    t1 = drk[4*r+1];
    t1 = AES32DSMI(t1,s1,0); t1 = AES32DSMI(t1,s0,1);
    t1 = AES32DSMI(t1,s3,2); t1 = AES32DSMI(t1,s2,3);

    t2 = drk[4*r+2];
    t2 = AES32DSMI(t2,s2,0); t2 = AES32DSMI(t2,s1,1);
    t2 = AES32DSMI(t2,s0,2); t2 = AES32DSMI(t2,s3,3);

    t3 = drk[4*r+3];
    t3 = AES32DSMI(t3,s3,0); t3 = AES32DSMI(t3,s2,1);
    t3 = AES32DSMI(t3,s1,2); t3 = AES32DSMI(t3,s0,3);

    s0=t0; s1=t1; s2=t2; s3=t3;
  }

  // Final inverse round
  t0 = drk[40];
  t0 = AES32DSI(t0,s0,0); t0 = AES32DSI(t0,s3,1);
  t0 = AES32DSI(t0,s2,2); t0 = AES32DSI(t0,s1,3);

  t1 = drk[41];
  t1 = AES32DSI(t1,s1,0); t1 = AES32DSI(t1,s0,1);
  t1 = AES32DSI(t1,s3,2); t1 = AES32DSI(t1,s2,3);

  t2 = drk[42];
  t2 = AES32DSI(t2,s2,0); t2 = AES32DSI(t2,s1,1);
  t2 = AES32DSI(t2,s0,2); t2 = AES32DSI(t2,s3,3);

  t3 = drk[43];
  t3 = AES32DSI(t3,s3,0); t3 = AES32DSI(t3,s2,1);
  t3 = AES32DSI(t3,s1,2); t3 = AES32DSI(t3,s0,3);

  aes_store_le(&pt[0], t0);
  aes_store_le(&pt[4], t1);
  aes_store_le(&pt[8], t2);
  aes_store_le(&pt[12], t3);
}

#endif // AES_ISA_H
