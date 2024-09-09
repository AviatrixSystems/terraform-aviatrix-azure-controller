data "http" "controller_login" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "login",
    "username" : "admin",
    "password" : var.avx_controller_private_ip,
  })
  retry {
    attempts     = 30
    min_delay_ms = 10000
  }
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to login to the controller: ${jsondecode(self.response_body)["reason"]}"
    }
  }
}

data "http" "set_admin_email" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "add_admin_email_addr",
    "CID" : jsondecode(data.http.controller_login.response_body)["CID"],
    "admin_email" : var.avx_controller_admin_email,
  })
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to set admin email address: ${jsondecode(self.response_body)["reason"]}"
    }
  }
}

data "http" "set_admin_password" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "edit_account_user",
    "CID" : jsondecode(data.http.controller_login.response_body)["CID"],
    "username" : "admin",
    "what" : "password",
    "old_password" : var.avx_controller_private_ip,
    "new_password" : var.avx_controller_admin_password,
  })
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to set admin password: ${jsondecode(self.response_body)["reason"]}"
    }
  }
}

data "http" "set_notification_email" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "add_notif_email_addr",
    "CID" : jsondecode(data.http.controller_login.response_body)["CID"],
    "notif_email_args" : jsonencode({
      "admin_alert" : { "address" : var.avx_controller_admin_email }
    }),
  })
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to set notification email: ${jsondecode(self.response_body)["reason"]}"
    }
  }
  depends_on = [data.http.set_admin_password]
}

data "http" "set_customer_id" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "setup_customer_id",
    "CID" : jsondecode(data.http.controller_login.response_body)["CID"],
    "customer_id" : var.aviatrix_customer_id,
  })
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to set customer id: ${jsondecode(self.response_body)["reason"]}"
    }
  }
}

data "http" "controller_initial_setup" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "initial_setup",
    "CID" : jsondecode(data.http.controller_login.response_body)["CID"],
    "subaction" : "run",
    "target_version" : var.controller_version,
  })
  depends_on = [
    data.http.set_admin_email,
    data.http.set_admin_password,
    data.http.set_notification_email,
    data.http.set_customer_id
  ]
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to do initial setup: ${jsondecode(self.response_body)["reason"]}"
    }
  }
}

resource "time_sleep" "wait_for_setup" {
  create_duration = var.wait_for_setup_duration

  depends_on = [data.http.controller_initial_setup]
}

data "http" "controller_login_2" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "login",
    "username" : "admin",
    "password" : var.avx_controller_admin_password,
  })
  retry {
    attempts     = 30
    min_delay_ms = 10000
  }
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to login to the controller after initial setup: ${jsondecode(self.response_body)["reason"]}"
    }
  }
  depends_on = [
    time_sleep.wait_for_setup,
  ]
}

data "http" "azure_access_account" {
  url      = "https://${var.avx_controller_public_ip}/v2/api"
  insecure = true
  method   = "POST"
  request_headers = {
    "Content-Type" = "application/json"
  }
  request_body = jsonencode({
    "action" : "setup_account_profile",
    "CID" : jsondecode(data.http.controller_login_2.response_body)["CID"],
    "account_name" : var.access_account_name,
    "cloud_type" : "8",
    "account_email" : var.account_email,
    "arm_subscription_id" : var.arm_subscription_id,
    "arm_application_endpoint" : var.directory_id,
    "arm_application_client_id" : var.arm_client_id,
    "arm_application_client_secret" : var.arm_application_key,
  })
  lifecycle {
    postcondition {
      condition     = jsondecode(self.response_body)["return"]
      error_message = "Failed to create access account: ${jsondecode(self.response_body)["reason"]}"
    }
  }
}
