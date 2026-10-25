variable "project" {
  description = "Short project name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment name: dev or prod."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "address_space" {
  description = "CIDR for the virtual network."
  type        = string
}

variable "aks_subnet_prefix" {
  description = "CIDR for the AKS subnet."
  type        = string
}

variable "aks_sku_tier" {
  description = "AKS SKU tier."
  type        = string
}

variable "node_vm_size" {
  description = "VM size for AKS nodes."
  type        = string
}

variable "node_min_count" {
  description = "Minimum AKS nodes."
  type        = number
}

variable "node_max_count" {
  description = "Maximum AKS nodes."
  type        = number
}

variable "acr_sku" {
  description = "Container registry SKU."
  type        = string
}

variable "allowed_ip_ranges" {
  description = "CIDRs allowed to reach the AKS API server and Key Vault."
  type        = list(string)
}
