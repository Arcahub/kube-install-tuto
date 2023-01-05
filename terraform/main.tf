variable "project_id" {
  type    = string
  default = "eb3c5f4c-a3ef-47ce-8eb9-b449585479fe"
}

module "k8s" {
  source = "./modules/k8s"

  project_id = var.project_id
  zone       = "fr-par-1"
  region     = "fr-par"
}

output "public_gateway_ip" {
  value = module.k8s.public_gateway_ip
}

output "control_plane_ip" {
  value = module.k8s.control_plane_ip
}

output "worker_ips" {
  value = module.k8s.worker_ips
}