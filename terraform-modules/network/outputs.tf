output "vnet_Name" {
  value = azurerm_virtual_network.wec_vnet.name
}
output "vnet_Address" {
  value = azurerm_virtual_network.wec_vnet.address_space
}
output "vnet_Id" {
  value = azurerm_virtual_network.wec_vnet.id
}

output "subnet_Name" {
  value = azurerm_subnet.subnet.*.name
}
output "subnet_Id" {
  value = azurerm_subnet.subnet.*.id
}
output "subnet_CIDRAddress" {
  value = azurerm_subnet.subnet.*.address_prefixes
}
