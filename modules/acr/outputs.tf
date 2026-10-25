output "id" {
  description = "ID of the container registry."
  value       = azurerm_container_registry.this.id
}

output "login_server" {
  description = "Login server, e.g. myregistry.azurecr.io."
  value       = azurerm_container_registry.this.login_server
}
