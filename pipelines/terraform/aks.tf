resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.usecase}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2" #Standard_E4_v3

    temporary_name_for_rotation = "temprotation"

    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }


  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    prevent_destroy = true

  }
}


# Assign permissions on the ACR
resource "azurerm_role_assignment" "main" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.main.id
  skip_service_principal_aad_check = true
}