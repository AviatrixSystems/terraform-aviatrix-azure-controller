gen_module_docs: fmt
	terraform-docs markdown --hide requirements ./modules/aviatrix_controller_azure > ./modules/aviatrix_controller_azure/README.md
	terraform-docs markdown --hide requirements ./modules/aviatrix_controller_build > ./modules/aviatrix_controller_build/README.md
	terraform-docs markdown --hide requirements ./modules/aviatrix_controller_initialize > ./modules/aviatrix_controller_initialize/README.md

fmt:
	terraform fmt -recursive
