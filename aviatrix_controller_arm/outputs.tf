output "Application_Client_ID" {
  value = azuread_application.aviatrix_ad_app.application_id
}

output "Application_Key_Client_Secret" {
  value = azuread_application_password.aviatrix_app_password.value
}

output "Subscription_ID" {
  value = data.azurerm_subscription.main.subscription_id
}

output "Directory_Tenant_ID" {
  value = data.azurerm_subscription.main.tenant_id
}
