terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone       = var.zone
  region     = var.region
  project_id = var.project_id
}

module "k8s-network" {
  source = "./modules/k8s-network"
}

module "k8s-node" {
  source               = "./modules/k8s-node"
  node_private_network = module.k8s-network.private_network_id
  node_count = 2
}

module "k8s-control-plane" {
  source               = "./modules/k8s-control-plane"
  node_private_network = module.k8s-network.private_network_id
}
