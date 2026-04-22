// GIFT-128 block cipher (NIST LWC finalist)
// Nibble-serial reference implementation
#ifndef GIFT128_H
#define GIFT128_H
#include <stdint.h>

void gift128_enc(const uint8_t key[16], const uint8_t pt[16], uint8_t ct[16]);
void gift128_dec(const uint8_t key[16], const uint8_t ct[16], uint8_t pt[16]);

#endif
