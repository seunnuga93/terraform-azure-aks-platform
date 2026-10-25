variable "name_prefix" {
  description = "Prefix used for all resource names, e.g. platform-dev."
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

variable "address_space" {
  description = "CIDR for the virtual network."
  type        = string
}

variable "aks_subnet_prefix" {
  description = "CIDR for the AKS node subnet. Must sit inside address_space."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
