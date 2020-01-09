resource "azurerm_public_ip" "public_ip" {
  location = var.azure_region
  name = "ubuntu-ip"
  resource_group_name = azurerm_resource_group.resource-group.name
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  location = var.azure_region
  name = "nic-ubuntu"
  resource_group_name = azurerm_resource_group.resource-group.name
  ip_configuration {
    name = "ubuntu-vm-ip"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id = azurerm_subnet.subnet.id
  }
}

resource "azurerm_virtual_machine" "ubuntu-vm" {
  location = var.azure_region
  name = "ubuntu-vm"
  network_interface_ids = [
    "${azurerm_network_interface.nic.id}"
  ]
  resource_group_name = azurerm_resource_group.resource-group.name
  vm_size = "Standard_B1s"
  storage_os_disk {
    name              = "vmdist"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_profile {
    admin_username = "ubuntu"
    computer_name = "ubuntu"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.key.public_key_openssh
      path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}