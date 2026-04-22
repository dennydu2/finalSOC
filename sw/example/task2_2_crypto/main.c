// Task 2_2 - Cryptography Demo
// Demonstrates:
//   1. RISC-V Zkne/Zknd ISA-accelerated AES-128
//   2. CFS co-processor AES-128 and GIFT-128
//   3. TRNG for key generation
//   4. Software baseline AES-128 and GIFT-128 with benchmark comparison
#include <neorv32.h>
#include <string.h>
#include "aes128.h"
#include "gift128.h"
#include "aes_isa.h"
#include "cfs_crypto.h"

#define BAUD_RATE  19200
#define BENCH_ITERS 100

// ---- helpers ----------------------------------------------------------------

static void print_hex_byte(uint8_t value) {
  static const char hex_digits[] = "0123456789abcdef";
  neorv32_uart0_putc(hex_digits[(value >> 4) & 0x0f]);
  neorv32_uart0_putc(hex_digits[value & 0x0f]);
}

static void print_hex(const char *label, const uint8_t *buf, int len) {
  int i;
  neorv32_uart0_printf("%s: ", label);
  for (i = 0; i < len; i++) {
    print_hex_byte(buf[i]);
  }
  neorv32_uart0_puts("\n");
}

static int memcmp_bytes(const uint8_t *a, const uint8_t *b, int n) {
  int i;
  for (i = 0; i < n; i++) if (a[i] != b[i]) return 1;
  return 0;
}

static uint32_t get_cycles(void) { return neorv32_cpu_csr_read(CSR_CYCLE); }

static void print_speedup(const char *label, uint32_t accel_cycles, uint32_t sw_cycles) {
  uint32_t speedup_x10 = 0;

  if (accel_cycles != 0) {
    speedup_x10 = (uint32_t)((((uint64_t)sw_cycles) * 10ull + (accel_cycles / 2u)) / accel_cycles);
  }

  neorv32_uart0_printf("%s%u cycles  (%u.%ux speedup)\n",
                       label,
                       accel_cycles,
                       speedup_x10 / 10u,
                       speedup_x10 % 10u);
}

// ---- TRNG key generation ----------------------------------------------------

static void trng_get_bytes(uint8_t *buf, int n) {
  int i;
  for (i = 0; i < n; i++) {
    while (!neorv32_trng_data_avail());
    buf[i] = neorv32_trng_data_get();
  }
}

// ---- Known-answer test vectors (NIST FIPS-197 AES-128 example) -------------

static const uint8_t aes_key[16] = {
  0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c
};
static const uint8_t aes_pt[16] = {
  0x32,0x43,0xf6,0xa8,0x88,0x5a,0x30,0x8d,0x31,0x31,0x98,0xa2,0xe0,0x37,0x07,0x34
};
static const uint8_t aes_ct_ref[16] = {
  0x39,0x25,0x84,0x1d,0x02,0xdc,0x09,0xfb,0xdc,0x11,0x85,0x97,0x19,0x6a,0x0b,0x32
};

// GIFT-128 zero-key / zero-plaintext KAT aligned to the official reference code
static const uint8_t gift_key[16] = {
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};
static const uint8_t gift_pt[16] = {
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};
static const uint8_t gift_ct_ref[16] = {
  0x5e,0x8e,0x3a,0x2e,0x16,0x97,0xa7,0x7d,0xcc,0x0b,0x89,0xdc,0xd9,0x7a,0x64,0xee
};

// ---- Section 1: ISA-accelerated AES ----------------------------------------

static void demo_isa_aes(void) {
  uint8_t ct[16], dec[16];
  uint32_t t_enc, t_dec, c0;
  int i;

  neorv32_uart0_puts("\n=== 1. RISC-V Zkne/Zknd ISA-Accelerated AES-128 ===\n");

  // Functional test
  aes128_isa_enc(aes_key, aes_pt, ct);
  print_hex("  PT ", aes_pt, 16);
  print_hex("  Key", aes_key, 16);
  print_hex("  CT ", ct, 16);
  print_hex("  Ref", aes_ct_ref, 16);
  if (memcmp_bytes(ct, aes_ct_ref, 16) == 0)
    neorv32_uart0_puts("  KAT PASS\n");
  else
    neorv32_uart0_puts("  KAT FAIL\n");

  aes128_isa_dec(aes_key, ct, dec);
  if (memcmp_bytes(dec, aes_pt, 16) == 0)
    neorv32_uart0_puts("  Decrypt PASS\n");
  else
    neorv32_uart0_puts("  Decrypt FAIL\n");

  // Benchmark
  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) aes128_isa_enc(aes_key, aes_pt, ct);
  t_enc = (get_cycles() - c0) / BENCH_ITERS;

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) aes128_isa_dec(aes_key, ct, dec);
  t_dec = (get_cycles() - c0) / BENCH_ITERS;

  neorv32_uart0_printf("  Cycles/enc (ISA): %u\n", t_enc);
  neorv32_uart0_printf("  Cycles/dec (ISA): %u\n", t_dec);
}

// ---- Section 2: CFS co-processor -------------------------------------------

static void demo_cfs_aes(void) {
  uint8_t ct[16], dec[16];
  uint32_t t_enc, t_dec, c0;
  int i;

  neorv32_uart0_puts("\n=== 2a. CFS Co-Processor AES-128 ===\n");

  if (!neorv32_cfs_available()) {
    neorv32_uart0_puts("  CFS not available!\n");
    return;
  }

  cfs_aes128_enc(aes_key, aes_pt, ct);
  print_hex("  CT ", ct, 16);
  if (memcmp_bytes(ct, aes_ct_ref, 16) == 0)
    neorv32_uart0_puts("  KAT PASS\n");
  else
    neorv32_uart0_puts("  KAT FAIL\n");

  cfs_aes128_dec(aes_key, ct, dec);
  if (memcmp_bytes(dec, aes_pt, 16) == 0)
    neorv32_uart0_puts("  Decrypt PASS\n");
  else
    neorv32_uart0_puts("  Decrypt FAIL\n");

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) cfs_aes128_enc(aes_key, aes_pt, ct);
  t_enc = (get_cycles() - c0) / BENCH_ITERS;

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) cfs_aes128_dec(aes_key, ct, dec);
  t_dec = (get_cycles() - c0) / BENCH_ITERS;

  neorv32_uart0_printf("  Cycles/enc (CFS): %u\n", t_enc);
  neorv32_uart0_printf("  Cycles/dec (CFS): %u\n", t_dec);
}

static void demo_cfs_gift(void) {
  uint8_t ct[16], dec[16];
  uint32_t t_enc, t_dec, c0;
  int i;

  neorv32_uart0_puts("\n=== 2b. CFS Co-Processor GIFT-128 ===\n");

  if (!neorv32_cfs_available()) {
    neorv32_uart0_puts("  CFS not available!\n");
    return;
  }

  cfs_gift128_enc(gift_key, gift_pt, ct);
  print_hex("  PT ", gift_pt, 16);
  print_hex("  Key", gift_key, 16);
  print_hex("  CT ", ct, 16);
  print_hex("  Ref", gift_ct_ref, 16);
  if (memcmp_bytes(ct, gift_ct_ref, 16) == 0)
    neorv32_uart0_puts("  KAT PASS\n");
  else
    neorv32_uart0_puts("  KAT FAIL\n");

  cfs_gift128_dec(gift_key, ct, dec);
  if (memcmp_bytes(dec, gift_pt, 16) == 0)
    neorv32_uart0_puts("  Decrypt PASS\n");
  else
    neorv32_uart0_puts("  Decrypt FAIL\n");

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) cfs_gift128_enc(gift_key, gift_pt, ct);
  t_enc = (get_cycles() - c0) / BENCH_ITERS;

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) cfs_gift128_dec(gift_key, ct, dec);
  t_dec = (get_cycles() - c0) / BENCH_ITERS;

  neorv32_uart0_printf("  Cycles/enc (CFS): %u\n", t_enc);
  neorv32_uart0_printf("  Cycles/dec (CFS): %u\n", t_dec);
}

// ---- Section 3: TRNG --------------------------------------------------------

static void demo_trng(void) {
  uint8_t rnd_key[16], ct[16], dec[16];

  neorv32_uart0_puts("\n=== 3. TRNG Key Generation ===\n");

  if (!neorv32_trng_available()) {
    neorv32_uart0_puts("  TRNG not available!\n");
    return;
  }

  neorv32_trng_enable();
  neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), 10); // warm up
  neorv32_trng_fifo_clear();

  trng_get_bytes(rnd_key, 16);
  print_hex("  TRNG key", rnd_key, 16);

  // Encrypt/decrypt with TRNG-generated key (software AES)
  aes128_enc(rnd_key, aes_pt, ct);
  aes128_dec(rnd_key, ct, dec);
  if (memcmp_bytes(dec, aes_pt, 16) == 0)
    neorv32_uart0_puts("  AES with TRNG key: PASS\n");
  else
    neorv32_uart0_puts("  AES with TRNG key: FAIL\n");

  gift128_enc(rnd_key, gift_pt, ct);
  gift128_dec(rnd_key, ct, dec);
  if (memcmp_bytes(dec, gift_pt, 16) == 0)
    neorv32_uart0_puts("  GIFT with TRNG key: PASS\n");
  else
    neorv32_uart0_puts("  GIFT with TRNG key: FAIL\n");
}

// ---- Section 4: Software baseline + comparison table -----------------------

static void demo_sw_baseline(uint32_t *sw_aes_enc, uint32_t *sw_aes_dec,
                              uint32_t *sw_gift_enc, uint32_t *sw_gift_dec) {
  uint8_t ct[16], dec[16];
  uint32_t c0;
  int i;

  neorv32_uart0_puts("\n=== 4. Software Baseline ===\n");

  // AES software
  aes128_enc(aes_key, aes_pt, ct);
  if (memcmp_bytes(ct, aes_ct_ref, 16) == 0)
    neorv32_uart0_puts("  SW AES KAT: PASS\n");
  else
    neorv32_uart0_puts("  SW AES KAT: FAIL\n");

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) aes128_enc(aes_key, aes_pt, ct);
  *sw_aes_enc = (get_cycles() - c0) / BENCH_ITERS;

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) aes128_dec(aes_key, ct, dec);
  *sw_aes_dec = (get_cycles() - c0) / BENCH_ITERS;

  // GIFT software
  gift128_enc(gift_key, gift_pt, ct);
  if (memcmp_bytes(ct, gift_ct_ref, 16) == 0)
    neorv32_uart0_puts("  SW GIFT KAT: PASS\n");
  else
    neorv32_uart0_puts("  SW GIFT KAT: FAIL\n");

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) gift128_enc(gift_key, gift_pt, ct);
  *sw_gift_enc = (get_cycles() - c0) / BENCH_ITERS;

  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) gift128_dec(gift_key, ct, dec);
  *sw_gift_dec = (get_cycles() - c0) / BENCH_ITERS;

  neorv32_uart0_printf("  SW AES  cycles/enc: %u\n", *sw_aes_enc);
  neorv32_uart0_printf("  SW AES  cycles/dec: %u\n", *sw_aes_dec);
  neorv32_uart0_printf("  SW GIFT cycles/enc: %u\n", *sw_gift_enc);
  neorv32_uart0_printf("  SW GIFT cycles/dec: %u\n", *sw_gift_dec);
}

static void print_comparison(uint32_t sw_aes, uint32_t isa_aes, uint32_t cfs_aes,
                              uint32_t sw_gift, uint32_t cfs_gift) {
  neorv32_uart0_puts("\n=== Benchmark Summary (cycles per encrypt) ===\n");
  neorv32_uart0_printf("  AES-128  SW  only : %u cycles\n", sw_aes);
  print_speedup("  AES-128  ISA accel: ", isa_aes, sw_aes);
  print_speedup("  AES-128  CFS HW   : ", cfs_aes, sw_aes);
  neorv32_uart0_printf("  GIFT-128 SW  only : %u cycles\n", sw_gift);
  print_speedup("  GIFT-128 CFS HW   : ", cfs_gift, sw_gift);
}

// ---- main -------------------------------------------------------------------

int main(void) {
  uint32_t sw_aes_enc=0, sw_aes_dec=0, sw_gift_enc=0, sw_gift_dec=0;
  uint32_t isa_aes_enc=0, cfs_aes_enc=0, cfs_gift_enc=0;
  uint8_t ct[16], dec[16];
  uint32_t c0;
  int i;

  neorv32_rte_setup();
  neorv32_uart0_setup(BAUD_RATE, 0);

  neorv32_uart0_puts("\n\n");
  neorv32_uart0_puts("##############################################\n");
  neorv32_uart0_puts("# Task 2_2: Cryptography on NEORV32/RISC-V  #\n");
  neorv32_uart0_puts("##############################################\n");
  neorv32_uart0_printf("Clock: %u Hz\n", neorv32_sysinfo_get_clk());

  // Run all sections
  demo_sw_baseline(&sw_aes_enc, &sw_aes_dec, &sw_gift_enc, &sw_gift_dec);
  demo_isa_aes();

  // Capture ISA benchmark for comparison table
  c0 = get_cycles();
  for (i = 0; i < BENCH_ITERS; i++) aes128_isa_enc(aes_key, aes_pt, ct);
  isa_aes_enc = (get_cycles() - c0) / BENCH_ITERS;

  demo_cfs_aes();
  demo_cfs_gift();
  demo_trng();

  // Capture CFS benchmarks for comparison table
  if (neorv32_cfs_available()) {
    c0 = get_cycles();
    for (i = 0; i < BENCH_ITERS; i++) cfs_aes128_enc(aes_key, aes_pt, ct);
    cfs_aes_enc = (get_cycles() - c0) / BENCH_ITERS;

    c0 = get_cycles();
    for (i = 0; i < BENCH_ITERS; i++) cfs_gift128_enc(gift_key, gift_pt, ct);
    cfs_gift_enc = (get_cycles() - c0) / BENCH_ITERS;
  }

  print_comparison(sw_aes_enc, isa_aes_enc, cfs_aes_enc, sw_gift_enc, cfs_gift_enc);

  neorv32_uart0_puts("\nDone.\n");
  return 0;
}
