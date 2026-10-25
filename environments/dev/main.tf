locals {
  name_prefix = "${var.project}-${var.environment}"
  tags = {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  tags                = local.tags
}

module "aks" {
  source = "../../modules/aks"

  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.network.aks_subnet_id
  sku_tier            = var.aks_sku_tier
  node_vm_size        = var.node_vm_size
  node_min_count      = var.node_min_count
  node_max_count      = var.node_max_count

  api_server_authorized_ip_ranges = var.allowed_ip_ranges
  tags                            = local.tags
}

module "acr" {
  source = "../../modules/acr"

  name                = replace("acr${var.project}${var.environment}", "-", "")
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.acr_sku
  pull_principal_ids  = [module.aks.kubelet_object_id]
  tags                = local.tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  name                     = "kv-${local.name_prefix}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.this.name
  purge_protection_enabled = var.environment == "prod"
  allowed_ip_ranges        = var.allowed_ip_ranges
  tags                     = local.tags
}
