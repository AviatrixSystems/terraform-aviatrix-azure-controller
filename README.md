# Launch an Aviatrix Controller in Azure

## Description

These Terraform modules launch an Aviatrix Controller in Azure and create an access account on the controller.

## Prerequisites

[Terraform v1.2+](https://www.terraform.io/downloads.html) - execute terraform files

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 2.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | \>= 2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | \>= 2.0 |


## Available Modules

Module  | Description |
| ------- | ----------- |
|[aviatrix_controller_azure](modules/aviatrix_controller_azure) |Creates Azure Active Directory Application and Service Principal for Aviatrix access account setup |
|[aviatrix_controller_build](modules/aviatrix_controller_build) |Builds the Aviatrix Controller VM on Azure |
|[aviatrix_controller_initialize](modules/aviatrix_controller_initialize) | Initializes the Aviatrix Controller (setting admin email, setting admin password, upgrading controller version, and setting up access account) |

## Procedures for Building and Initializing a Controller in Azure

### 1. Authenticating to Azure

Please refer to the documentation for
the [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
and [azuread](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs) Terraform providers to decide how
to authenticate to Azure.

### 2. Applying Terraform configuration

Build and initialize the Aviatrix Controller

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

module "aviatrix_controller_azure" {
   source                        = "AviatrixSystems/azure-controller/aviatrix"
   controller_name               = "<<< your Aviatrix Controller name >>>"
   // Example incoming_ssl_cidr list: ["1.1.1.1/32","10.10.0.0/16"]
   incoming_ssl_cidr             = ["<<trusted management cidrs>>"]
   avx_controller_admin_email    = "<<< your admin email address for the Aviatrix Controller>>>"
   avx_controller_admin_password = "<<< your admin password for the Aviatrix Controller>>>"
   account_email                 = "<< your email address for your access account >>"
   access_account_name           = "<< your account name mapping to your Azure account >>"
   aviatrix_customer_id          = "<< your customer license id >>"
}
```

*Execute*

```shell
terraform init
terraform apply
```
