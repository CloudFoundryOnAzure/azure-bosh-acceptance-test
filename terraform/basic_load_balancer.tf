resource "azurerm_public_ip" "basic-lb-public-ip" {
  name                         = "basic-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh_resource_group.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "basic-lb" {
  name                = "${var.env_name}-basic-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.basic-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "basic-lb-backend-pool" {
  name                = "basic-lb-backend-pool"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.basic-lb.id}"
}

resource "azurerm_lb_probe" "basic-lb-https-probe" {
  name                = "basic-lb-https-probe"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.basic-lb.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "basic-lb-https-rule" {
  name                = "basic-lb-https-rule"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.basic-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.basic-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.basic-lb-https-probe.id}"
}

resource "azurerm_lb_probe" "basic-lb-http-probe" {
  name                = "basic-lb-http-probe"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.basic-lb.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "basic-lb-http-rule" {
  name                = "basic-lb-http-rule"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.basic-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.basic-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.basic-lb-http-probe.id}"
}

output "basic_lb_name" {
  value = "${azurerm_lb.basic-lb.name}"
}
