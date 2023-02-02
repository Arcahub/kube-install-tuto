variable "project_id" {
  type    = string
  default = "2548c189-3774-46a1-8a18-e0ef516d5893"
}

variable "project_name" {
  type = string
  default = "k8s"
}

module "k8s" {
  source = "./modules/k8s"

  project_name = var.project_name
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