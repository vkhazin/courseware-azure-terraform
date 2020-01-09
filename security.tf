resource "azurerm_network_security_group" "sg-public" {
   location = var.azure_region
   name = "sg-public"
   resource_group_name = azurerm_resource_group.resource-group.name
 }

 resource "azurerm_network_security_rule" "sr-public" {
   access = "allow"
   direction = "Inbound"
   name = "ssh"
   network_security_group_name = azurerm_network_security_group.sg-public.name
   priority = 100
   protocol = "tcp"
   source_port_range = "*"
   destination_port_range = "22"
   source_address_prefix = "*"
   destination_address_prefix = "VirtualNetwork"
   resource_group_name = azurerm_resource_group.resource-group.name
 }

resource "azurerm_subnet_network_security_group_association" "sg-sb-association" {
   network_security_group_id = azurerm_network_security_group.sg-public.id
   subnet_id = azurerm_subnet.subnet.id
 }

provider "tls" {}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "local_file" "private_key" {
  filename = "ssh-private-key.pem"
  content = tls_private_key.key.private_key_pem
}