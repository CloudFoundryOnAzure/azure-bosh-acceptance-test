resource "azurerm_storage_account" "default_storage_account" {
  name                     = "${replace(var.env_name, "-", "")}"
  resource_group_name      = "${azurerm_resource_group.bosh_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_table" "stemcells_storage_table" {
  name                  = "${data.template_file.stemcells_table.rendered}"
  resource_group_name   = "${azurerm_resource_group.bosh_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.default_storage_account.name}"
}

resource "azurerm_storage_account" "bosh_vms_storage_account" {
  name                     = "${replace(var.env_name, "-", "")}${data.template_file.base_storage_account_wildcard.rendered}${count.index}"
  resource_group_name      = "${azurerm_resource_group.bosh_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  count = 2
}
