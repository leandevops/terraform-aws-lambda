BLUE	= \033[0;34m
GREEN	= \033[0;32m
RED   = \033[0;31m
NC    = \033[0m

# run all
all: build
	@echo "$(GREEN)✓ 'make all' has completed $(NC)\n"

# building a function
build: ; @echo "$(GREEN)✓ Building a function $(NC)\n"
	@cd test/fixtures/tf_module/function && zip function.zip *.py
	@$(MAKE) -s post-action

# run post actions
post-action: ; @echo "$(BLUE)✓ Done. $(NC)\n"
.PHONY: post-action
