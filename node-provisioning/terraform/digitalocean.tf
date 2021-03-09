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

data "digitalocean_ssh_key" "digital_ocean_0" {
  name = "digital_ocean_0"
}

resource "digitalocean_droplet" "barbabietola_node" {
  count = 1
  size = "s-1vcpu-1gb"
  region = "fra1"
  image = "debian-10-x64"
  name = "barbabietola-node-${count.index}"
  #ssh_keys = [ "29745930" ]
  ssh_keys = [ data.digitalocean_ssh_key.digital_ocean_0.id ]

  connection {
    type     = "ssh"
    user     = "root"
    private_key = file(var.pvt_key)
    host     = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = ["echo 'server reachable!'"]
  }

  # Run ansible
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} --extra-vars 'NODE_ID=${var.node_id} JSON_KEY=${var.json_key} HTTP_PORT=8545 WS_PORT=8546' ../ansible/initial.yml"
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.barbabietola_node:
    droplet.name => droplet.ipv4_address
  }
}
