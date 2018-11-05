resource "azurerm_public_ip" "standard-lb-public-ip" {
  name                         = "standard-lb-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh_resource_group.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
}

resource "azurerm_lb" "standard-lb" {
  name                = "${var.env_name}-standard-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.standard-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "standard-lb-backend-pool" {
  name                = "standard-lb-backend-pool"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.standard-lb.id}"
}

resource "azurerm_lb_probe" "standard-lb-https-probe" {
  name                = "standard-lb-https-probe"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.standard-lb.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "standard-lb-https-rule" {
  name                = "standard-lb-https-rule"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.standard-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.standard-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.standard-lb-https-probe.id}"
}

resource "azurerm_lb_probe" "standard-lb-http-probe" {
  name                = "standard-lb-http-probe"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.standard-lb.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "standard-lb-http-rule" {
  name                = "standard-lb-http-rule"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.standard-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.standard-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.standard-lb-http-probe.id}"
}

resource "azurerm_lb_rule" "standard-lb-udp-rule" {
  name                = "standard-lb-udp-rule"
  resource_group_name = "${azurerm_resource_group.bosh_resource_group.name}"
  loadbalancer_id     = "${azurerm_lb.standard-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = 123
  backend_port                   = 123

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.standard-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.standard-lb-http-probe.id}"
}

output "standard_lb_name" {
  value = "${azurerm_lb.standard-lb.name}"
}
