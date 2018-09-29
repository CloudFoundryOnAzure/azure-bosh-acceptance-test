resource "azurerm_public_ip" "director" {
  name                         = "director"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh_resource_group.name}"
  public_ip_address_allocation = "static"
}
