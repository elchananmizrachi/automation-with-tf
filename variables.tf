variable "docker-network" {
  type        = string
  description = "docker network for nginx"
  default     = "lb-network"
}

variable "docker-image" {
  type        = string
  description = "nginx image version"
  default     = "nginx:latest"
}


