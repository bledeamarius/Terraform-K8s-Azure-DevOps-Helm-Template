# Get service principal details
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.usecase}-managed-resources"
  location = var.location
}


resource "azurerm_management_lock" "main" {
  name       = "DND"
  scope      = azurerm_resource_group.main.id
  lock_level = "CanNotDelete"
  notes      = "AKS and KV are here. DND"
}

resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.usecase}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id

    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "Create",
      "Delete",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
    ]

  }

  lifecycle {
    ignore_changes  = [access_policy]
    prevent_destroy = true
  }
}


## Container registry
resource "azurerm_container_registry" "main" {
  name                = replace("acr-${var.usecase}", "/[^a-zA-Z0-9]/", "") # Keep only alpha numeric chars
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true

  lifecycle {
    prevent_destroy = true
  }
}

# Store the acr secrets in KV
resource "azurerm_key_vault_secret" "acr_admin_username" {
  name         = "acr-admin-username"
  value        = azurerm_container_registry.main.admin_username
  key_vault_id = azurerm_key_vault.main.id
}
resource "azurerm_key_vault_secret" "acr_admin_password" {
  name         = "acr-admin-password"
  value        = azurerm_container_registry.main.admin_password
  key_vault_id = azurerm_key_vault.main.id
}
resource "azurerm_key_vault_secret" "acr_login_url" {
  name         = "acr-admin-loginrul"
  value        = azurerm_container_registry.main.login_server
  key_vault_id = azurerm_key_vault.main.id
}