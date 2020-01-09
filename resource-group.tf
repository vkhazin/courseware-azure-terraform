resource "azurerm_resource_group" "resource-group" {
  name     = "rg-tf-resource-group"
  location = var.azure_region
}