# Create a default resource group
resource "azurerm_resource_group" "bosh_resource_group" {
  name     = "${var.resource_group_prefix}-${var.env_name}-e2e"
  location = "${var.location}"
}
