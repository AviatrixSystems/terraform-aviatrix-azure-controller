// accept license of Aviatrix Controller
resource "null_resource" "accept_license" {
  provisioner "local-exec" {
    command = "python3 ${var.terraform_module_path}/aviatrix_controller_arm/accept_license.py"
  }
}


# 1.Create the Azure AD APP
resource "azuread_application" "aviatrix_ad_app" {
  name = var.app_name
}

# 2. Create the password for the created APP
// Generate a random string
resource "random_string" "password" {
  length  = 32
  special = false
}
resource "azuread_application_password" "aviatrix_app_password" {
  application_object_id = azuread_application.aviatrix_ad_app.id
  value                 = random_string.password.result
  end_date              = "2120-12-30T23:00:00Z"
}

# 3. Create SP associated with the APP
resource "azuread_service_principal" "aviatrix_sp" {
  application_id = azuread_application.aviatrix_ad_app.application_id
}

# 4. Create the password for the created SP
// Generate a random string
// Associate the random password with the created SP
resource "azuread_service_principal_password" "aviatrix_sp_password" {
  service_principal_id = azuread_service_principal.aviatrix_sp.id
  value                = random_string.password.result
  end_date             = "2120-12-30T23:00:00Z"
}

# 5. Create a role assignment for the created SP
data "azurerm_subscription" "main" {}

resource "azurerm_role_assignment" "aviatrix_sp_role" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aviatrix_sp.id
}
