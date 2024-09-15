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

In simple cases you should be able to do:

```bash
az login
```

and store your subscription id in an environment variable:

```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
```

### 2. Applying Terraform configuration

Create a `terraform.tfvars` file with your settings:

```hcl
access_account_name = "azure"
account_email = "youremail@domain.com"
aviatrix_customer_id = "domain.com-abu-xxxx"
avx_controller_admin_email = "youremail@domain.com"
avx_controller_admin_password = "StrongPassword123"
controller_name = "avxtest"
controller_virtual_machine_size = "Standard_D4_v5"
incoming_ssl_cidr = ["<your ip>/32"]
```

*Execute*

```shell
terraform init
terraform apply
```
