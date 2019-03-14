BLUE	= \033[0;34m
GREEN	= \033[0;32m
RED   = \033[0;31m
NC    = \033[0m

# run all
all: init validate plan apply run-tests destroy
	@echo "$(GREEN)✓ 'make all' has completed $(NC)\n"

# initial terraform setup
init: ; @echo "$(GREEN)✓ Initializing terraform $(NC)\n"
	@terraform init -input=false -lock=true \
			   -upgrade -force-copy -backend=true -get=true \
			   -get-plugins=true -verify-plugins=true \
			   tests/fixtures/tf_module
	@$(MAKE) -s post-action

update: ; @echo "$(GREEN)✓ Updating terraform $(NC)\n"
	@terraform get -update tests/fixtures/tf_module
	@$(MAKE) -s post-action

validate: ; @echo "$(GREEN)✓ Updating terraform $(NC)\n"
	@terraform validate -check-variables=true \
			   -var-file=tests/fixtures/tf_module/testing.tfvars \
			   tests/fixtures/tf_module
	@$(MAKE) -s post-action

# terraform plan
plan: ; @echo "$(GREEN)✓ Planning terraform $(NC)\n"
	@terraform plan -lock=true -input=false \
			   -parallelism=4 -refresh=true \
			   -var-file=tests/fixtures/tf_module/testing.tfvars \
			   tests/fixtures/tf_module
	@$(MAKE) -s post-action

# apply terraform
apply: ; @echo "$(GREEN)✓ Applying terraform $(NC)\n"
	@terraform apply -lock=true -input=false \
			   -auto-approve=true -parallelism=4 -refresh=true \
			   -var-file=tests/fixtures/tf_module/testing.tfvars \
			   tests/fixtures/tf_module
	@$(MAKE) -s post-action

run-tests: ; @echo "$(GREEN)✓ Running rspec tests $(NC)\n"
	@bundle exec rspec -c -f doc --default-path '.'  -P 'tests/scenarios/test_module.rb'
	@$(MAKE) -s post-action

# building a function
build: ; @echo "$(GREEN)✓ Building a function $(NC)\n"
	@cd tests/fixtures/tf_module/function && zip function.zip *.py
	@$(MAKE) -s post-action

# destroy all resources
destroy: ; @echo "$(RED)✓ Destroying terraform resources $(NC)\n"
	@terraform destroy -force -input=false -parallelism=4 -refresh=true \
			   -var-file=tests/fixtures/tf_module/testing.tfvars \
			   tests/fixtures/tf_module
	@rm terraform.tfstate*
	@$(MAKE) -s post-action

clean: ; @echo "$(RED)✓ Cleaning directory $(NC)\n"
	@rm -rf test/fixtures/tf_module/.terraform
	@rm -f terraform.tfstate*
	@rm -f test/fixtures/tf_module/function/function.zip
	@$(MAKE) -s post-action

tflint: ; @echo "$(RED)✓ Running tflint $(NC)\n"
	@cd module && tflint
	@$(MAKE) -s post-action

deps: ; @echo "$(RED)✓ Installing dependencies $(NC)\n"
	@gem install bundler
	@bundle check || bundle install
	@$(MAKE) -s post-action

post-action: ; @echo "$(BLUE)✓ Done. $(NC)\n"
.PHONY: post-action
