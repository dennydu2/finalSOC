# Task 2_2 Cryptography demo makefile
# Requires RISC-V GCC with scalar crypto extensions (Zkne, Zknd)

# Enable RISC-V scalar crypto ISA extensions
MARCH = rv32i_zicsr_zifencei_zkne_zknd

EFFORT = -Os

USER_FLAGS += -ggdb -gdwarf-3

# Memory sizes (adjust to match your Vivado block design)
USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=64k
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=32k

# Additional sources
APP_SRC += $(wildcard ./*.c)
APP_INC += -I .

NEORV32_HOME ?= ../../..

include $(NEORV32_HOME)/sw/common/common.mk
