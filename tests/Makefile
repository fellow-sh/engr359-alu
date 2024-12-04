SIM ?= icarus
TOPLEVEL_LANG ?= verilog
COMPILE_ARGS ?= -Wall -g2005-sv

VERILOG_SOURCES += $(PWD)/../src/*.sv

#TOPLEVEL = alu16
#MODULE = test_alu16

TOPLEVEL = ALU
MODULE = test_ALU

include $(shell cocotb-config --makefiles)/Makefile.sim
