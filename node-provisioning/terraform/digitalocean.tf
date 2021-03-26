terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
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

resource "digitalocean_droplet" "barbabietola_master_node" {
  # count = 1
  size     = "s-2vcpu-2gb"
  region   = "fra1"
  image    = "debian-10-x64" # "72401866"
  name     = "barbabietola-master-node"
  ssh_keys = [data.digitalocean_ssh_key.digital_ocean_0.id]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.pvt_key)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = ["echo 'server reachable!'"]
  }

  # Run ansible
  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3 \
      ansible-playbook \
        --user root \
        --inventory '${self.ipv4_address},' \
        --tags master \
        --private-key ${var.pvt_key} \
        --extra-vars 'NODE_ID=0 JSON_KEY=${var.json_key} NODE_PUBLIC_IP=${self.ipv4_address}' \
        ../ansible/deploy.yml
      EOT
  }
}

resource "digitalocean_droplet" "barbabietola_slave_node" {
  count    = 1
  size     = "s-2vcpu-2gb"
  region   = "fra1"
  image    = "debian-10-x64" # "72401866"
  name     = "barbabietola-slave-node-${count.index}"
  ssh_keys = [data.digitalocean_ssh_key.digital_ocean_0.id]

  depends_on = [
    digitalocean_droplet.barbabietola_master_node
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.pvt_key)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = ["echo 'server reachable!'"]
  }

  # Run ansible
  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3 \
      ansible-playbook \
        --user root \
        --inventory '${self.ipv4_address},' \
        --tags slave \
        --private-key ${var.pvt_key} \
        --extra-vars 'NODE_ID=${count.index + 1} JSON_KEY=${var.json_key} NODE_PUBLIC_IP=${self.ipv4_address} MASTER_NODE_IP=${digitalocean_droplet.barbabietola_master_node.ipv4_address}' \
        ../ansible/deploy.yml
      EOT
  }
}

# output "master_ip_address" {
#   description = "Master node IP Address."
#   value = digitalocean_droplet.barbabietola_master_node.ipv4_address
# }
