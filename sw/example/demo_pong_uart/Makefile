# Application makefile.
# UART Pong demo for NEORV32.

# Match baseline setup used by other small demos.
MARCH = rv32i_zicsr_zifencei
EFFORT = -Os

# Keep memory assumptions aligned with your current simple SoC config.
USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=16k
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=8k

# Set path to NEORV32 root directory
NEORV32_HOME ?= ../../..

# Include the main NEORV32 makefile
include $(NEORV32_HOME)/sw/common/common.mk
