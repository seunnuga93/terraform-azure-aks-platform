variable "name" {
  description = "Key Vault name. Globally unique, 3-24 characters."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into."
  type        = string
}

variable "purge_protection_enabled" {
  description = "Enable in production. Once on, it cannot be turned off."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "allowed_ip_ranges" {
  description = "CIDRs allowed through the Key Vault firewall."
  type        = list(string)
}
