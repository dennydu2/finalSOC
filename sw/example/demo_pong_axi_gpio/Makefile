# Application makefile.
# NEORV32 GPIO -> AXI Pong controller demo.

MARCH = rv32i_zicsr_zifencei
EFFORT = -Os

USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=16k
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=8k

NEORV32_HOME ?= ../../..

include $(NEORV32_HOME)/sw/common/common.mk
