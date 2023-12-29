resource "azurerm_kubernetes_cluster" "aks-terraform" {
  name = "aks-terraform"
  location = "eastus"
  resource_group_name = "aks-terraform"
  dns_prefix = "aks-terraform"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_E2_v3"
  }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
  }

}