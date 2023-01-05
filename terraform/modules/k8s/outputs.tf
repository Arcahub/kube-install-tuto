output "public_gateway_ip" {
  value = module.k8s-network.public_gateway_ip
}

output "control_plane_ip" {
  value = module.k8s-control-plane.control_plane_ip
}

output "worker_ips" {
  value = module.k8s-node.workers_ip
}