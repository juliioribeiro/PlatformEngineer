terraform {
  # backend "azurerm" {
  #   resource_group_name = "LearningPlatformEngineer"
  #   storage_account_name = "learningplatformengineer"
  #   container_name = "tfstate"
  #   key = ""
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.11.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.resource_k8s.location
  resource_group_name = azurerm_resource_group.resource_k8s.name
  dns_prefix          = "labs"

  default_node_pool {
    name       = "default"
    node_count = var.default_node_pool_count
    vm_size    = var.default_node_pool_size
  }

  identity {
    type = "SystemAssigned"
  }

}

variable "resource_group_name" {
  default     = "labs-azure"
  description = "nome do resource group na azure"
}

variable "location" {
  default     = "Brazil South"
  description = "região utilizada na implantação da infraestrutura"
}

variable "cluster_name" {
  default     = "labs-aks"
  description = "nome do cluster aks"
}

variable "default_node_pool_count" {
  default = 2
}

variable "default_node_pool_size" {
  default = "Standard_D2_v2"
}

