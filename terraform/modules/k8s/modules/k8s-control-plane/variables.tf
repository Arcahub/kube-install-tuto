variable "project_name" {
  description = "Name of the project to use."
  type        = string
  default     = "k8s"
}

variable "node_type" {
  description = "Type of control plane to create."
  type        = string
  default     = "PLAY2-MICRO"
}

variable "node_image" {
  description = "Image to use for control plane."
  type        = string
  default     = "ubuntu_jammy"
}

variable "node_private_network" {
  description = "Private network to use for control plane."
  type        = string
}