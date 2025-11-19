SHELL := /bin/bash
.PHONY := help

help:	## displays help for Makefile
	@printf "\n\n################################\n\n"
	@printf "Eloquent AI Terraform Targets"
	@printf "\n\n################################\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: 	## initialize terraform
	@printf "\n\n++++++++++++++ STARTING init ++++++++++++++++++\n";
	terraform init
	@printf "++++++++++++++ DONE WITH init ++++++++++++++++++\n";

plan: init 	## plan terraform
	@printf "\n\n++++++++++++++ STARTING plan ++++++++++++++++++\n";
	terraform plan
	@printf "++++++++++++++ DONE WITH plan ++++++++++++++++++\n";

apply: init	## apply terraform
	@printf "\n\n++++++++++++++ STARTING apply ++++++++++++++++++\n";
	terraform apply -auto-approve
	@printf "++++++++++++++ DONE WITH apply ++++++++++++++++++\n";

destroy: init	## destroy terraform
	@printf "\n\n++++++++++++++ STARTING destroy ++++++++++++++++++\n";
	terraform destroy -auto-approve
	@printf "++++++++++++++ DONE WITH destroy ++++++++++++++++++\n";
