terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  backend "azurerm" {
    resource_group_name = var.BKSTRGRG
    storage_account_name = var.BKSTRG
    container_name = var.BKCONTAINER
    key = var.BKSTRGKEY
  }
}

provider "azurerm" {
  features {
  }
}

data "azurerm_kubernetes_cluster" "default" {
  depends_on          = [module.cluster] # refresh cluster state before reading
  name                = "aks-terraform"
  resource_group_name = "aks-terraform"
}


module "cluster" {
    source = "./modules/cluster"
}

module "k8s" {
  source = "./modules/k8s"
  host = data.azurerm_kubernetes_cluster.default.kube_config.0.host
  client_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_certificate)
  client_key = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.default.kube_config.0.cluster_ca_certificate)
  CARTS_IMG = var.CARTS_IMG
  CATALOGUE_DB_IMG = var.CATALOGUE_DB_IMG
  CATALOGUE_IMG = var.CATALOGUE_IMG
  ORDERS_IMG = var.ORDERS_IMG
  PAYMENT_IMG = var.PAYMENT_IMG
  QUEUE_MASTER_IMG = var.QUEUE_MASTER_IMG
  SHIPPING_IMG = var.SHIPPING_IMG
  USER_IMG = var.USER_IMG
  USER_DB_IMG = var.USER_DB_IMG
  FRONTEND_IMG = var.FRONTEND_IMG
}