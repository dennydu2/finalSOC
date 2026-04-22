// AES-128 software implementation (FIPS 197)
#ifndef AES128_H
#define AES128_H
#include <stdint.h>

void aes128_enc(const uint8_t key[16], const uint8_t pt[16], uint8_t ct[16]);
void aes128_dec(const uint8_t key[16], const uint8_t ct[16], uint8_t pt[16]);

#endif
