terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // https://github.com/hashicorp/terraform-provider-azurerm/issues/24444
      version = "3.85.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "aviatrix_controller_azure" {
  source                    = "./modules/aviatrix_controller_azure"
  app_name                  = var.app_name
  create_custom_role        = var.create_custom_role
  use_existing_mp_agreement = var.use_existing_mp_agreement
}

module "aviatrix_controller_build" {
  source = "./modules/aviatrix_controller_build"
  // please do not use special characters such as `\/"[]:|<>+=;,?*@&~!#$%^()_{}'` in the controller_name
  controller_name                           = var.controller_name
  location                                  = var.location
  controller_vnet_cidr                      = var.controller_vnet_cidr
  controller_subnet_cidr                    = var.controller_subnet_cidr
  controller_virtual_machine_admin_username = var.controller_virtual_machine_admin_username
  controller_virtual_machine_admin_password = var.controller_virtual_machine_admin_password
  controller_virtual_machine_size           = var.controller_virtual_machine_size
  incoming_ssl_cidr                         = var.incoming_ssl_cidr
  use_existing_vnet                         = var.use_existing_vnet
  resource_group_name                       = var.resource_group_name
  vnet_name                                 = var.vnet_name
  subnet_name                               = var.subnet_name
  subnet_id                                 = var.subnet_id

  depends_on = [
    module.aviatrix_controller_azure
  ]
}

module "aviatrix_controller_initialize" {
  source                        = "./modules/aviatrix_controller_initialize"
  avx_controller_public_ip      = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
  avx_controller_private_ip     = module.aviatrix_controller_build.aviatrix_controller_private_ip_address
  avx_controller_admin_email    = var.avx_controller_admin_email
  avx_controller_admin_password = var.avx_controller_admin_password
  arm_subscription_id           = module.aviatrix_controller_azure.subscription_id
  arm_client_id                 = module.aviatrix_controller_azure.client_id
  arm_application_key           = module.aviatrix_controller_azure.application_key
  directory_id                  = module.aviatrix_controller_azure.directory_id
  account_email                 = var.account_email
  access_account_name           = var.access_account_name
  aviatrix_customer_id          = var.aviatrix_customer_id
  controller_version            = var.controller_version

  depends_on = [
    module.aviatrix_controller_azure
  ]
}
