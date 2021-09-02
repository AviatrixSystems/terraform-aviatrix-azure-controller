variable "app_name" {
  type        = string
  description = "Azure AD App Name for Aviatrix Controller Build Up"
  default     = "aviatrix_controller_app"
}

variable "terraform_module_path" {
  type        = string
  description = "terraform module absolute path"
  default     = ""
}
