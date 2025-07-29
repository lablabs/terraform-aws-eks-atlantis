# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
  nullable    = false
}

variable "atlantis_enable_aws_profiles" {
  type        = bool
  default     = false
  description = "Whether to enable AWS profiles"
}

variable "atlantis_aws_profiles" {
  type        = string
  default     = ""
  description = "Set AWS profiles in .aws/config file. If var.atlantis_override_default_aws_profile is false, appends to .aws/config, else overrides the config contents"
}

variable "atlantis_override_default_aws_profile" {
  type        = bool
  default     = false
  description = "Whether to override default atlantis profile in .aws/config with var.atlantis_aws_profiles"
}
