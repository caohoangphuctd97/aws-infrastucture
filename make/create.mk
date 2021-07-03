tf_create_new: # Plan and apply Terraform resources, require: TF_ROOT, environment
	cd $(TF_ROOT)
	@echo "Creating $(environment) resources..."
	terraform plan -out=tfplan.out -var-file="$(TF_VARS_CONFIG)" -lock=false
	@echo "Appling ..."
	terraform apply -input=false tfplan.out
	rm -rf .terraform/terraform.tfstate>/dev/null 2>&1