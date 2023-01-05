variable "project_name" {
  description = "Name of the project to use."
  type        = string
  default     = "k8s"
}

variable "node_count" {
  description = "Number of nodes to create."
  type        = number
}

variable "node_type" {
  description = "Type of nodes to create."
  type        = string
  default = "PLAY2-MICRO"  
}

variable "node_image" {
  description = "Image to use for nodes."
  type        = string
  default     = "ubuntu_jammy"
}

variable "node_volume_size" {
  description = "Size of the root volume."
  type        = number
  default     = 20
}

variable "node_private_network" {
  description = "Private network to use for nodes."
  type        = string
}

