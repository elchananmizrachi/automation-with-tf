terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
}

resource "docker_network" "private_network" {
  name = var.docker-network
}

resource "docker_image" "web" {
  name = var.docker-image_web
  keep_locally = false
}

resource "docker_image" "lb" {
  name = var.docker-image_lb
  keep_locally = false
}

resource "docker_container" "nginx_server" {
  image = docker_image.web.latest
  count = var.servers_count
  name  = "nginx-web-${count.index + 1}"
  networks = ["${docker_network.private_network.name}"]
  hostname = "nginx-web-${count.index + 1}"
  ports {
    internal = 80
    external = "800${count.index + 1}"
  }
  upload {
  source = "src/def.conf"
  file = "/etc/nginx/conf.d/default.conf"
  }
}


resource "docker_container" "nginx-lb" {
  image = docker_image.lb.latest
  name = "lb"
  networks = ["${docker_network.private_network.name}"]
  hostname = "lb"
  ports {
    internal = 80
    external = 80
  }
  upload {
  source = "src/nginx.conf"
  file = "/etc/nginx/conf.d/default.conf"
  }
}