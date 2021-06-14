# HELP
.PHONY: help

help: ## Makefile help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

dev-env: ## Setup local environment.
	@echo "Installing terraform"; \
		curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip; \
		sudo unzip -o /tmp/terraform.zip -d /usr/local/bin
	
	@sudo apt-get -y update && sudo apt-get -y install ansible

ansible-inventory: ## (Re)Build inventory file for ansible provisioning
	@terraform taint local_file.inventory || true
	@terraform apply -target=local_file.inventory -auto-approve -input=false -compact-warnings

provisioning: ## Install and configure required packages on VMs
	ansible-galaxy install -r requirements.yml
	ansible-playbook -u ubuntu -i .ansible/inventory --extra-vars "@vars.json" --private-key .ssh/rusk_ansible.pem playbook.yml

it-fly: ## Perform complete deploy (create/update infrastructure and provision)
	terraform apply
	@echo "Waiting for VMs to fully initialize..." && sleep 30
	@$(MAKE) -s ansible-inventory
	@$(MAKE) -s provisioning