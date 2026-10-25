variable "name" {
  description = "Registry name. Globally unique, alphanumeric only."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.name))
    error_message = "ACR name must be 5-50 alphanumeric characters."
  }
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into."
  type        = string
}

variable "sku" {
  description = "Basic, Standard or Premium."
  type        = string
  default     = "Basic"
}

variable "pull_principal_ids" {
  description = "Principal IDs granted AcrPull on the registry."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
