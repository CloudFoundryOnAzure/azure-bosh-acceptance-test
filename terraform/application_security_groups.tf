resource "azurerm_application_security_group" "default_asg" {
  name                         = "default-asg"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh_resource_group.name}"
}
