variable "app_name" {
  type        = string
  description = "Azure AD App Name for Aviatrix Controller Build Up"
  default     = "aviatrix_controller_app"
}

variable "create_custom_role" {
  type        = bool
  description = "Enable creation of custom role in stead of using contributor permissions"
  default     = false
}

variable "use_existing_mp_agreement" {
  type        = bool
  description = "Flag to indicate whether to use an existing marketplace agreement"
  default     = false
}
