# Azure Aviatrix - Terraform Module

## Descriptions
This Terraform module allows you to launch the Aviatrix Controller and create the Aviatrix access account connecting to the existing Controller on Azure.

## Prerequisites
1. Azure command-line interface (Azure CLI) https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
2. Python https://www.python.org/downloads/

## Available Modules
 Module  | Description |
| ------- | ----------- |
|[aviatrix_controller_arm](./aviatrix_controller_arm) |Creates the Azure ARM such as Subscription ID, Directory ID, Application ID, and Application Key for Aviatrix access account setup |
|[aviatrix_controller_build](./aviatrix_controller_build) |Builds the Aviatrix Controller VM on Azure |
|[aviatrix_controller_initialize](./aviatrix_controller_initialize) | Initializes the Aviatrix Controller (setting admin email, setting admin password, upgrading controller version, and setting access account) |

## Basic Usage
```
module "<<module_name>>" {
  source = "github.com/AviatrixSystems/terraform-modules.git/<<module_name>>"
  //var1 is the input variable required in this module
  var1   = "<< var1 >>"
}
```
## Procedures for Building and Initializing a Controller in Azure
###1. Authenticating to Azure using the Azure CLI in terminal
``` shell
az login
```
This command will open the default browser and load Azure sign in page

###2. Create the Azure ARM (Service Principal)
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
*Excute*
```shell
cd aviatrix_controller_arm
terraform init
terraform apply
cd ..
```

###3. Build the Controller VM on Azure
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
*Excute*
```shell
cd aviatrix_controller_build
terraform init
terraform apply
cd ..
```
###4. Initialize the Controller
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
  arm_subscription_id           = "<< subscription id obtained in step 2 >>"
  arm_application_id            = "<< application id obtained in step 2 >>"
  arm_application_key           = "<< application key obtained in step 2 >>"
  directory_id                  = "<< directory id obtained in step 2 >>"
  account_email                 = "<< your email address for your access account >>"
  access_account_name           = "<< your account name mapping to your Azure account >>"
  aviatrix_customer_id          = "<< your customer license id> >"
  terraform_module_path         = "<< absolute path of this terraform module >>"
}
```
*Excute*
```shell
cd aviatrix_controller_initialize
terraform init
terraform apply
cd ..
```

###Putting it all together
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
*Excute*
```shell
terraform init
terraform apply
```