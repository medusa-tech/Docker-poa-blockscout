terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.5.1"
    }
  }
}

provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

resource "digitalocean_droplet" "tf-test" {
  size = "s-1vcpu-1gb"
  region = "fra1"
  image = "72401866"
  name = "tf-test"
  ssh_keys = [ "29745930" ]
}

resource "digitalocean_droplet" "tf1-test" {
  size = "s-1vcpu-1gb"
  region = "fra1"
  image = "72401866"
  name = "tf-test"
  ssh_keys = [ "29745930" ]
}
