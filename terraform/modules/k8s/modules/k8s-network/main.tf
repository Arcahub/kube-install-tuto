terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

resource "scaleway_vpc_private_network" "main" {
    name = "${var.project_name}-network"
}

resource "scaleway_vpc_gateway_network" "main" {
  gateway_id         = scaleway_vpc_public_gateway.main.id
  private_network_id = scaleway_vpc_private_network.main.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.main.id
  enable_dhcp        = true
  enable_masquerade  = true
}

resource "scaleway_vpc_public_gateway" "main" {
  type            = "VPC-GW-S"
  bastion_enabled = true
  ip_id = scaleway_vpc_public_gateway_ip.main.id
}

resource "scaleway_vpc_public_gateway_dhcp" "main" {
  subnet = "192.168.1.0/24"
}

resource "scaleway_vpc_public_gateway_ip" "main" {  
}