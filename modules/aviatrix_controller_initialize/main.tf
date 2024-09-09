/**
 * # Aviatrix Controller Initialize
 *
 * This module executes the initialization script on the Aviatrix Controller.
 */

terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
    }
  }
}

output "controller_setup_result" {
  value = data.http.controller_initial_setup.response_body
}
