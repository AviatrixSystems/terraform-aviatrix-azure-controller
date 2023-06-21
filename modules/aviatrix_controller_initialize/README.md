# Aviatrix Controller Initialize

This module executes the initialization script on the Aviatrix Controller. The following actions are performed:
1. Wait until API server of Aviatrix Controller is up and running
2. Login Aviatrix Controller and get CID
3. Check if the controller has been initialized or not 
4. Set admin email 
5. Set admin password 
6. Login Aviatrix Controller as admin with new password and get CID 
7. Initial setup for Aviatrix Controller 
8. Wait until Apache server of Aviatrix Controller is up and running after initial setup 
9. Login Aviatrix Controller and get CID 
10. Set Aviatrix Customer ID
11. Create access account

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.run_script](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_account_name"></a> [access\_account\_name](#input\_access\_account\_name) | aviatrix controller access account name | `string` | n/a | yes |
| <a name="input_account_email"></a> [account\_email](#input\_account\_email) | aviatrix controller access account email | `string` | n/a | yes |
| <a name="input_arm_application_id"></a> [arm\_application\_id](#input\_arm\_application\_id) | Azure application client id | `string` | n/a | yes |
| <a name="input_arm_application_key"></a> [arm\_application\_key](#input\_arm\_application\_key) | Azure application client secret | `string` | n/a | yes |
| <a name="input_arm_subscription_id"></a> [arm\_subscription\_id](#input\_arm\_subscription\_id) | Azure subscription id | `string` | n/a | yes |
| <a name="input_aviatrix_customer_id"></a> [aviatrix\_customer\_id](#input\_aviatrix\_customer\_id) | aviatrix customer license id | `string` | n/a | yes |
| <a name="input_avx_controller_admin_email"></a> [avx\_controller\_admin\_email](#input\_avx\_controller\_admin\_email) | aviatrix controller admin email address | `string` | n/a | yes |
| <a name="input_avx_controller_admin_password"></a> [avx\_controller\_admin\_password](#input\_avx\_controller\_admin\_password) | aviatrix controller admin password | `string` | n/a | yes |
| <a name="input_avx_controller_private_ip"></a> [avx\_controller\_private\_ip](#input\_avx\_controller\_private\_ip) | aviatrix controller private ip address(required) | `string` | n/a | yes |
| <a name="input_avx_controller_public_ip"></a> [avx\_controller\_public\_ip](#input\_avx\_controller\_public\_ip) | aviatrix controller public ip address(required) | `string` | n/a | yes |
| <a name="input_controller_version"></a> [controller\_version](#input\_controller\_version) | Aviatrix Controller version | `string` | `"latest"` | no |
| <a name="input_directory_id"></a> [directory\_id](#input\_directory\_id) | Azure directory tenant id | `string` | n/a | yes |
| <a name="input_terraform_module_path"></a> [terraform\_module\_path](#input\_terraform\_module\_path) | terraform module absolute path | `string` | `""` | no |

## Outputs

No outputs.

## APIs Used

* `login`
* `initial_setup`
* `add_admin_email_addr`
* `edit_account_user`
* `setup_customer_id`
* `setup_account_profile`
