# Create a virtual network in the default resource group
resource "azurerm_virtual_network" "e2e_virtual_network" {
  name                = "e2e"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
}

resource "azurerm_subnet" "director" {
  name                 = "director"
  resource_group_name  = "${azurerm_resource_group.bosh_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.e2e_virtual_network.name}"
  address_prefix       = "${cidrsubnet(azurerm_virtual_network.e2e_virtual_network.address_space[0], 8, 0)}"
}

resource "azurerm_subnet" "e2e_subnets" {
  name                 = "subnet-${count.index + 1}"
  resource_group_name  = "${azurerm_resource_group.bosh_resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.e2e_virtual_network.name}"
  address_prefix       = "${cidrsubnet(azurerm_virtual_network.e2e_virtual_network.address_space[0], 8, count.index + 1)}"

  count = 10
}
