variable "name_prefix" {
  description = "Prefix used for all resource names."
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

variable "subnet_id" {
  description = "Subnet the node pool is attached to."
  type        = string
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version. Null lets Azure pick the current default."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "Free for dev, Standard for production (uptime SLA)."
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier must be Free or Standard."
  }
}

variable "node_vm_size" {
  description = "VM size for the system node pool."
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "node_min_count" {
  description = "Minimum nodes for the autoscaler."
  type        = number
  default     = 1
}

variable "node_max_count" {
  description = "Maximum nodes for the autoscaler."
  type        = number
  default     = 3
}

variable "log_retention_days" {
  description = "Log Analytics retention."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "api_server_authorized_ip_ranges" {
  description = "CIDRs allowed to reach the Kubernetes API server (your office/VPN and CI runner IPs)."
  type        = list(string)
}
