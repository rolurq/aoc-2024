# Compiler settings
NIM = nim
NIM_FLAGS = -d:release

SRC_DIR = src
BIN_DIR = bin

NIM_FILES := $(wildcard $(SRC_DIR)/*.nim)

TARGETS := $(patsubst $(SRC_DIR)/%.nim,$(BIN_DIR)/%,$(NIM_FILES))

# Default target
all: $(BIN_DIR) $(TARGETS)

$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

# Rule to compile Nim files
$(BIN_DIR)/%: $(SRC_DIR)/%.nim
	@echo "Compiling $< ..."
	@$(NIM) c $(NIM_FLAGS) -o:$@ $<

# Clean target
clean:
	@echo "Cleaning up..."
	@rm -rf $(BIN_DIR)

.PHONY: all clean
