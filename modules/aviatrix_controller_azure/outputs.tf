output "client_id" {
  value = azuread_application.aviatrix_ad_app.client_id
}

output "application_key" {
  value = azuread_application_password.aviatrix_app_password.value
}

output "subscription_id" {
  value = data.azurerm_subscription.main.subscription_id
}

output "directory_id" {
  value = data.azurerm_subscription.main.tenant_id
}
