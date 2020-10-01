# Azure Aviatrix - Terraform Module

## Descriptions
This Terraform module allows you to launch the Aviatrix Controller and create the Aviatrix access account connecting to the existing Controller on Azure.

## Prerequisites
1. [Terraform 0.13](https://www.terraform.io/downloads.html) - execute terraform files
2. [Azure command-line interface (Azure CLI)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - Azure authentication
3. [Python3](https://www.python.org/downloads/) - execute `accept_license.py` and `aviatrix_controller_init.py` python scripts

## Available Modules
 Module  | Description |
| ------- | ----------- |
|[aviatrix_controller_arm](./aviatrix_controller_arm) |Creates the Azure ARM such as Subscription ID, Directory ID, Application ID, and Application Key for Aviatrix access account setup |
|[aviatrix_controller_build](./aviatrix_controller_build) |Builds the Aviatrix Controller VM on Azure |
|[aviatrix_controller_initialize](./aviatrix_controller_initialize) | Initializes the Aviatrix Controller (setting admin email, setting admin password, upgrading controller version, and setting access account) |


## Procedures for Building and Initializing a Controller in Azure
### 1. Create the Python virtual environment and install required dependencies in the terminal
``` shell
 python3 -m venv venv
```
This command will create the virtual environment. In order to use the virtual environment, it needs to be activated by the following command
``` shell
 source venv/bin/activate
```
In order to run these `accept_license.py` and `aviatrix_controller_init.py` python scripts, dependencies listed in `requirements.txt` need to be stalled by the following command
``` shell
 pip install -r requirements.txt
```

### 2. Authenticating to Azure using the Azure CLI in the terminal
``` shell
az login
```
This command will open the default browser and load Azure sign in page

### 3. Create the Azure ARM (Service Principal)
**create_arm.tf**
```
provider "azurerm" {
  version = "<< terraform version >>"
  features {}
}

module "aviatrix_controller_arm" {
  source                = "./aviatrix_controller_arm"
  terraform_module_path = "<< absolute path of this terraform module >>"
}

output "subscription_id" {
  value = module.aviatrix_controller_arm.subscription_id
}

output "directory_tenant_id" {
  value = module.aviatrix_controller_arm.directory_id
}

output "application_id" {
  value = module.aviatrix_controller_arm.application_id
}

output "application_key" {
  value = module.aviatrix_controller_arm.application_key
}
```
*Execute*
```shell
cd aviatrix_controller_arm
terraform init
terraform apply
cd ..
```

### 4. Build the Controller VM on Azure
**build_controller.tf**
```
provider "azurerm" {
  version = "<< terraform version >>"
  features {}
}

module "aviatrix_controller_build" {
  source          = "./aviatrix_controller_build"
  // please do not use special characters such as `\/"[]:|<>+=;,?*@&~!#$%^()_{}'` in the controller_name
  controller_name = "<< your Aviatroc Controller name >>"
}

output "avx_controller_public_ip" {
  value = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
}

output "avx_controller_private_ip" {
  value = module.aviatrix_controller_build.aviatrix_controller_private_ip_address
}
```
*Execute*
```shell
cd aviatrix_controller_build
terraform init
terraform apply
cd ..
```
### 5. Initialize the Controller
**controller_init.tf**
```
provider "azurerm" {
  version = "<< terraform version >>"
  features {}
}

module "aviatrix_controller_initialize" {
  source                        = "./aviatrix_controller_initialize"
  avx_controller_public_ip      = "<< public ip address of the Aviatrix Controller >>"
  avx_controller_private_ip     = "<< private ip address of the Aviatrix Controller >>"
  avx_controller_admin_email    = "<< your admin email address for the Aviatrix Controller >>"
  avx_controller_admin_password = "<< your admin password for the Aviatrix Controller >>"
  arm_subscription_id           = "<< subscription id obtained in step 3 >>"
  arm_application_id            = "<< application id obtained in step 3 >>"
  arm_application_key           = "<< application key obtained in step 3 >>"
  directory_id                  = "<< directory id obtained in step 3 >>"
  account_email                 = "<< your email address for your access account >>"
  access_account_name           = "<< your account name mapping to your Azure account >>"
  aviatrix_customer_id          = "<< your customer license id >>"
  terraform_module_path         = "<< absolute path of this terraform module >>"
}
```
*Execute*
```shell
cd aviatrix_controller_initialize
terraform init
terraform apply
cd ..
```

### Putting it all together
The controller buildup and initialization can be done using a single terraform file.
```
provider "azurerm" {
  version = "<< terraform version >>"
  features {}
}

module "aviatrix_controller_arm" {
  source                = "./aviatrix_controller_arm"
  terraform_module_path = "<< absolute path of this terraform module >>"
}

module "aviatrix_controller_build" {
  source          = "./aviatrix_controller_build"
  // please do not use special characters such as `\/"[]:|<>+=;,?*@&~!#$%^()_{}'` in the controller_name
  controller_name = "<< your Aviatrix Controller name >>"
  depends_on      = [module.aviatrix_controller_arm]
}

module "aviatrix_controller_initialize" {
  source                        = "./aviatrix_controller_initialize"
  avx_controller_public_ip      = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
  avx_controller_private_ip     = module.aviatrix_controller_build.aviatrix_controller_private_ip_address
  avx_controller_admin_email    = "<< your admin email address for the Aviatrix Controller >>"
  avx_controller_admin_password = "<< your admin password for the Aviatrix Controller >>"
  arm_subscription_id           = module.aviatrix_controller_arm.subscription_id
  arm_application_id            = module.aviatrix_controller_arm.application_id
  arm_application_key           = module.aviatrix_controller_arm.application_key
  directory_id                  = module.aviatrix_controller_arm.directory_id
  account_email                 = "<< your email address for your access account >>"
  access_account_name           = "<< your account name mapping to your Azure account >>"
  aviatrix_customer_id          = "<< your customer license id >>"
  terraform_module_path         = "<< absolute path of this terraform module >>"
  depends_on                    = [module.aviatrix_controller_arm]
}

output "subscription_id" {
  value = module.aviatrix_controller_arm.subscription_id
}

output "directory_tenant_id" {
  value = module.aviatrix_controller_arm.directory_id
}

output "application_id" {
  value = module.aviatrix_controller_arm.application_id
}

output "application_key" {
  value = module.aviatrix_controller_arm.application_key
}

output "avx_controller_public_ip" {
  value = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
}
```
*Execute*
```shell
terraform init
terraform apply
```