output "private_network_id" {
  value = scaleway_vpc_private_network.main.id
}

output "public_gateway_ip" {
  value = scaleway_vpc_public_gateway_ip.main.address
}