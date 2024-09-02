# Do things in edx-documentation
.PHONY: help release-note requirements upgrade clean test i18n install_transifex_client html

help: ## display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

requirements: ## install development environment requirements
	pip install -r requirements/dev.txt

COMMON_CONSTRAINTS_TXT=requirements/common_constraints.txt
.PHONY: $(COMMON_CONSTRAINTS_TXT)
$(COMMON_CONSTRAINTS_TXT):
	wget -O "$(@)" https://raw.githubusercontent.com/edx/edx-lint/master/edx_lint/files/common_constraints.txt || touch "$(@)"

# Define PIP_COMPILE_OPTS=-v to get more information during make upgrade.
PIP_COMPILE = cd requirements/; pip-compile --rebuild --upgrade $(PIP_COMPILE_OPTS)

upgrade: export CUSTOM_COMPILE_COMMAND=make upgrade
upgrade: $(COMMON_CONSTRAINTS_TXT)  ## update the requirements/.txt files with the latest packages satisfying requirements/.in
	pip install -qr requirements/pip-tools.txt
	# Make sure to compile files after any other files they include!
	$(PIP_COMPILE) --allow-unsafe -o pip.txt pip.in
	$(PIP_COMPILE) -o pip-tools.txt pip-tools.in
	pip install -qr requirements/pip.txt
	pip install -qr requirements/pip-tools.txt
	$(PIP_COMPILE) -o base.txt base.in
	$(PIP_COMPILE) -o dev.txt dev.in

clean: ## remove built HTML files
	rm -rf _build
	make -C en_us clean

test: ## build all the docs
	./run_tests.sh

i18n: ## Creates the .pot files and .tx/config file for uploading translation strings to Transifex
	./i18n.sh

install_transifex_client: ## Install the Transifex client
	curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash
	git checkout -- LICENSE README.md

html: ## build HTML documentation
	@echo "Building HTML documentation..."
	# Build HTML documentation for all relevant directories
	@cd en_us/course_authors && make html
	@cd en_us/data && make html
	@cd en_us/developers && make html
	@cd en_us/discovery_api && make html
	@cd en_us/edx_style_guide && make html
	@cd en_us/enterprise_api && make html
	@cd en_us/install_operations && make html
	@cd en_us/landing_page && make html
	@cd en_us/olx && make html
	@cd en_us/open_edx_course_authors && make html
	@cd en_us/open_edx_release_notes && make html
	@cd en_us/open_edx_students && make html
	@cd en_us/xblock-tutorial && make html
	@echo "HTML documentation built successfully."