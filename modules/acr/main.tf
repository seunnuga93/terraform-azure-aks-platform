resource "azurerm_container_registry" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = false
  tags                = var.tags
}

# Let the cluster pull images using its managed identity, no registry passwords needed.
resource "azurerm_role_assignment" "acr_pull" {
  for_each = toset(var.pull_principal_ids)

  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = each.value
}
