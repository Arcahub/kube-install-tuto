terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

resource "scaleway_instance_server" "controlplane" {
  type  = var.node_type
  image = var.node_image
  name = "${var.project_name}-controlplane"

  private_network {
    pn_id = var.node_private_network
  }

  root_volume {
    size_in_gb = 20
  }
}
