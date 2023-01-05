variable "project_id" {
  type    = string
}

variable "project_name" {
  description = "Name of the project to use."
  type        = string
  default     = "k8s"  
}

variable "zone" {
  description = "Zone to use."
  type        = string
  default     = "fr-par-1"
}

variable "region" {
  description = "Region to use."
  type        = string
  default     = "fr-par"
}