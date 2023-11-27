# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "my_resource_group" {
  name     = "myResourceGroup"
  location = "West Europe"
}

# Create a storage account
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.my_resource_group.name
  location                 = azurerm_resource_group.my_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a virtual network
resource "azurerm_virtual_network" "my_virtual_network" {
  name                = "myVirtualNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
}

# Create a subnet
resource "azurerm_subnet" "my_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "my_aks_cluster" {
  name                = "myAKSCluster"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  dns_prefix          = "myaksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  service_principal {
    client_id     = "<your-service-principal-client-id>"
    client_secret = "<your-service-principal-client-secret>"
  }

  network_profile {
    network_plugin = "azure"
  }
}

