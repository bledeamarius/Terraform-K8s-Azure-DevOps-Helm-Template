
output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "acr_name" {
  value = azurerm_container_registry.main.name
}
output "aks_name" {
  value = azurerm_kubernetes_cluster.main.name
}
