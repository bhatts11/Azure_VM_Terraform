resource "azurerm_public_ip" "vm_pip" {
  name                = var.vm_pip
  resource_group_name = var.rg_Name
  location            = var.location
  allocation_method   = var.pip_allocation
}

resource "azurerm_network_interface" "vm_nic" {
  name                = var.vm_nic
  resource_group_name = var.rg_Name
  location            = var.location

  ip_configuration {
    name                          = var.ip_configuration
    subnet_id                     = var.vm_subnetid
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_network_security_group" "webserver" {
  name                = "tls_webserver"
  location            = var.location
  resource_group_name = var.rg_Name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_network_interface.vm_nic.private_ip_address
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}


resource "azurerm_windows_virtual_machine" "winvm" {
  name                = var.vm_name
  resource_group_name = var.rg_Name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  # disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  os_disk {
    storage_account_type = var.vm_os_disk_strg_type
    caching              = var.vm_os_disk_caching
  }
}