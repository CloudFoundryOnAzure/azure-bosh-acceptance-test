resource "azurerm_public_ip" "vip" {
  name                         = "vip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh_resource_group.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

output "vip_address" {
  value = "${azurerm_public_ip.vip.ip_address}"
}
