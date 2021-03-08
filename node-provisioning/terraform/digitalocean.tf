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

data "digitalocean_ssh_key" "digital_ocean1" {
  name = "digital_ocean1"
}

resource "digitalocean_droplet" "barbabietola_node" {
  count = 1
  size = "s-1vcpu-1gb"
  region = "fra1"
  image = "72401866"
  name = "barbabietola-node-${count.index}"
  #ssh_keys = [ "29745930" ]
  ssh_keys = [ data.digitalocean_ssh_key.digital_ocean1.id ]

  # Copy docker compose
  provisioner "file" {
    source = "../../eth-node"
    destination = "/eth-node"

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file(var.pvt_key)
      host     = self.ipv4_address
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' apache-install.yml"    
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.barbabietola_node:
    droplet.name => droplet.ipv4_address
  }
}
