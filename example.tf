provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

module "aviatrix_controller_arm" {
  source = "./aviatrix_controller_arm"
}

module "aviatrix_controller_build" {
  source = "./aviatrix_controller_build"
  // please do not use special characters such as `\/"[]:|<>+=;,?*@&~!#$%^()_{}'` in the controller_name
  controller_name = "<< your Aviatrix Controller name >>"
  depends_on = [
  module.aviatrix_controller_arm]
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
  depends_on = [
  module.aviatrix_controller_arm]
}

output "avx_controller_public_ip" {
  value = module.aviatrix_controller_build.aviatrix_controller_public_ip_address
}
