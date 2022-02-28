variable "docker-network" {
  type        = string
  description = "docker network for nginx"
  default     = "lb-network"
}

variable "docker-image_web" {
  type        = string
  description = "nginx web server image version"
  default     = "nginx:latest"
}

variable "docker-image_lb" {
  type        = string
  description = "nginx lb image version"
  default     = "nginx:latest"
}

variable "servers_count" {
 default = "2" 
}


