// CFS-based AES-128 and GIFT-128 hardware co-processor driver
//
// CFS Register Map:
//   REG[0]  : Control (write) / Status (read)
//             Write commands: 0x01=AES enc, 0x02=AES dec, 0x03=GIFT enc, 0x04=GIFT dec
//             Read:  bit0=done, bit1=busy
//   REG[1..4] : Key words 0..3 (write before command)
//   REG[5..8] : Input data words 0..3 (write before command)
//   REG[9..12]: Output data words 0..3 (read after done)
#ifndef CFS_CRYPTO_H
#define CFS_CRYPTO_H
#include <neorv32.h>
#include <stdint.h>

#define CFS_CMD_AES_ENC  0x01
#define CFS_CMD_AES_DEC  0x02
#define CFS_CMD_GIFT_ENC 0x03
#define CFS_CMD_GIFT_DEC 0x04

#define CFS_STATUS_DONE  0x01
#define CFS_STATUS_BUSY  0x02

// Load 128-bit key into CFS (big-endian byte order)
static inline void cfs_crypto_set_key(const uint8_t key[16]) {
  int i;
  for (i = 0; i < 4; i++) {
    NEORV32_CFS->REG[1+i] = ((uint32_t)key[4*i]   << 24) | ((uint32_t)key[4*i+1] << 16) |
                             ((uint32_t)key[4*i+2] <<  8) |  (uint32_t)key[4*i+3];
  }
}

// Load 128-bit input block into CFS
static inline void cfs_crypto_set_input(const uint8_t data[16]) {
  int i;
  for (i = 0; i < 4; i++) {
    NEORV32_CFS->REG[5+i] = ((uint32_t)data[4*i]   << 24) | ((uint32_t)data[4*i+1] << 16) |
                             ((uint32_t)data[4*i+2] <<  8) |  (uint32_t)data[4*i+3];
  }
}

// Trigger operation and wait for completion
static inline void cfs_crypto_run(uint32_t cmd) {
  NEORV32_CFS->REG[0] = cmd;
  while (!(NEORV32_CFS->REG[0] & CFS_STATUS_DONE)); // poll until done
}

// Read 128-bit output block from CFS
static inline void cfs_crypto_get_output(uint8_t data[16]) {
  int i;
  uint32_t w;
  for (i = 0; i < 4; i++) {
    w = NEORV32_CFS->REG[9+i];
    data[4*i]   = (w >> 24) & 0xff;
    data[4*i+1] = (w >> 16) & 0xff;
    data[4*i+2] = (w >>  8) & 0xff;
    data[4*i+3] = (w      ) & 0xff;
  }
}

// High-level CFS AES-128 encrypt
static inline void cfs_aes128_enc(const uint8_t key[16], const uint8_t pt[16], uint8_t ct[16]) {
  cfs_crypto_set_key(key);
  cfs_crypto_set_input(pt);
  cfs_crypto_run(CFS_CMD_AES_ENC);
  cfs_crypto_get_output(ct);
}

// High-level CFS AES-128 decrypt
static inline void cfs_aes128_dec(const uint8_t key[16], const uint8_t ct[16], uint8_t pt[16]) {
  cfs_crypto_set_key(key);
  cfs_crypto_set_input(ct);
  cfs_crypto_run(CFS_CMD_AES_DEC);
  cfs_crypto_get_output(pt);
}

// High-level CFS GIFT-128 encrypt
static inline void cfs_gift128_enc(const uint8_t key[16], const uint8_t pt[16], uint8_t ct[16]) {
  cfs_crypto_set_key(key);
  cfs_crypto_set_input(pt);
  cfs_crypto_run(CFS_CMD_GIFT_ENC);
  cfs_crypto_get_output(ct);
}

// High-level CFS GIFT-128 decrypt
static inline void cfs_gift128_dec(const uint8_t key[16], const uint8_t ct[16], uint8_t pt[16]) {
  cfs_crypto_set_key(key);
  cfs_crypto_set_input(ct);
  cfs_crypto_run(CFS_CMD_GIFT_DEC);
  cfs_crypto_get_output(pt);
}

#endif // CFS_CRYPTO_H
