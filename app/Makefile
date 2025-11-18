SHELL := /bin/bash
.PHONY := help


help:	## displays help for Makefile
	@printf "\n\n################################\n\n"
	@printf "Eloquent AI APP Targets"
	@printf "\n\n################################\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: 	## install dependencies
	@printf "\n\n++++++++++++++ STARTING install ++++++++++++++++++\n";
	pipenv install
	@printf "++++++++++++++ DONE WITH install ++++++++++++++++++\n";

run: 	## run application
	@printf "\n\n++++++++++++++ STARTING install ++++++++++++++++++\n";
	pipenv run python app.py
	@printf "++++++++++++++ DONE WITH install ++++++++++++++++++\n";

install-dev: 	## install production dependencies
	@printf "\n\n++++++++++++++ STARTING install dev ++++++++++++++++++\n";
	pipenv install --dev
	@printf "++++++++++++++ DONE WITH install dev ++++++++++++++++++\n";

pipenv: 	## starts pipenv
	@printf "\n\n++++++++++++++ STARTING pyenv ++++++++++++++++++\n";
	pipenv install --deploy
	@printf "++++++++++++++ DONE WITH pyenv ++++++++++++++++++\n";

pipenv-dev: 	## starts dev pipenv
	@printf "\n\n++++++++++++++ STARTING pyenv dev ++++++++++++++++++\n";
	pipenv install --dev --deploy
	@printf "++++++++++++++ DONE WITH pyenv dev ++++++++++++++++++\n";

lint: pipenv-dev 	## runs a lint
	@printf "\n\n++++++++++++++ STARTING flake8 linter ++++++++++++++++++\n";
	pipenv run flake8 .
	@printf "++++++++++++++ DONE WITH flake8 linter ++++++++++++++++++\n";

security: pipenv-dev 	## check for security issues on code
	@printf "\n\n++++++++++++++ STARTING security check ++++++++++++++++++\n";
	pipenv run bandit -r .
	@printf "++++++++++++++ DONE WITH security check ++++++++++++++++++\n";

docker-lint: ## runs docker lint for Dockerfile
	@printf "\n\n++++++++++++++ STARTING docker lint ++++++++++++++++++\n";
	docker run --rm --interactive hadolint/hadolint < Dockerfile
	@printf "\n\n++++++++++++++ DONE WITH docker lint ++++++++++++++++++\n";

pre-commit: lint security docker-lint	## run all checks and validations at once
