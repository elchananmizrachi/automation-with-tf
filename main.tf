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

resource "docker_image" "nginx" {
  name = var.docker-image
  keep_locally = false
}

resource "docker_container" "nginx-srv-1" {
  image = docker_image.nginx.name
  name = "web1"
 networks = ["${docker_network.private_network.name}"]
  hostname = "web1"
  ports {
    internal = 80
    external = 8000
  }
  upload {
    source = "src/web1.html"
    file = "/usr/share/nginx/html/index.html"
  }
  upload {
  source = "src/default.conf"
  file = "/etc/nginx/conf.d/default.conf"
  }
}

resource "docker_container" "nginx-srv-2" {
  image = docker_image.nginx.latest
  name = "web2"
  networks = ["${docker_network.private_network.name}"]
  hostname = "web2"
  ports {
    internal = 80
    external = 8080
  }
  upload {
    source = "src/web2.html"
    file = "/usr/share/nginx/html/index.html"
  }
  upload {
  source = "src/default.conf"
  file = "/etc/nginx/conf.d/default.conf"
  }
}

resource "docker_container" "nginx-lb" {
  image = docker_image.nginx.latest
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