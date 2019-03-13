BLUE	= \033[0;34m
GREEN	= \033[0;32m
RED   = \033[0;31m
NC    = \033[0m

# run all
all: build plan apply
	@echo "$(GREEN)✓ 'make all' has completed $(NC)\n"

# initial terraform setup
init: ; @echo "$(GREEN)✓ Initializing terraform $(NC)\n"
	@cd test/fixtures/tf_module/ && terraform get && terraform init
	@$(MAKE) -s post-action

# building a function
build: ; @echo "$(GREEN)✓ Building a function $(NC)\n"
	@cd test/fixtures/tf_module/function && zip function.zip *.py
	@$(MAKE) -s post-action

# plan terraform
plan: ; @echo "$(GREEN)✓ Planning terraform $(NC)\n"
	@cd test/fixtures/tf_module/ && terraform plan --out out.terraform
	@$(MAKE) -s post-action

# apply terraform
apply: ; @echo "$(GREEN)✓ Applying terraform $(NC)\n"
	@cd test/fixtures/tf_module/ && terraform apply out.terraform
	@$(MAKE) -s post-action

# destroy all resources and amivar.tf file
destroy: ; @echo "$(RED)✓ Destroying terraform resources $(NC)\n"
	@cd test/fixtures/tf_module/ && terraform destroy -force	
	@$(MAKE) -s post-action
.PHONY: destroy

# run post actions
post-action: ; @echo "$(BLUE)✓ Done. $(NC)\n"
.PHONY: post-action
