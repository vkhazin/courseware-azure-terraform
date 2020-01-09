resource "azurerm_virtual_network" "vnet" {
   address_space = ["10.0.0.0/16"]
   location = var.azure_region
   name = "vn-primary"
   resource_group_name = azurerm_resource_group.resource-group.name
 }
 
 resource "azurerm_subnet" "subnet" {
    address_prefix = "10.0.0.0/24"
    name = "sn-public"
    resource_group_name = azurerm_resource_group.resource-group.name
    virtual_network_name = azurerm_virtual_network.vnet.name
 }