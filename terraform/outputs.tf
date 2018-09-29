output "environment" {
  value = "${var.azure_environment}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.bosh_resource_group.name}"
}

output "vnet_name" {
  value = "${azurerm_virtual_network.e2e_virtual_network.name}"
}

output "subnet_name" {
  value = "${azurerm_subnet.director.name}"
}

output "internal_cidr" {
  value = "${azurerm_subnet.director.address_prefix}"
}

output "internal_gw" {
  value = "${cidrhost(azurerm_subnet.director.address_prefix, 1)}"
}

output "internal_ip" {
  value = "${cidrhost(azurerm_subnet.director.address_prefix, 6)}"
}

output "external_ip" {
  value = "${azurerm_public_ip.director.ip_address}"
}

output "default_security_group" {
  value = "${azurerm_network_security_group.bosh_deployed_vms_security_group.name}"
}

output "storage_account_name" {
  value = "${azurerm_storage_account.default_storage_account.name}"
}
