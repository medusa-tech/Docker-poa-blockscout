terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.5.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
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
}

resource "digitalocean_droplet" "barbabietola_slave_node" {
  count    = 1
  size     = "s-2vcpu-2gb"
  region   = "fra1"
  image    = "debian-10-x64" # "72401866"
  name     = "barbabietola-slave-node-${count.index}"
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
}

resource "local_file" "inventory" {
  filename = "./hosts.ini"

  content = <<EOT
    [master]
    ${digitalocean_droplet.barbabietola_master_node.ipv4_address}
    [slaves]
    %{ for slave_node in digitalocean_droplet.barbabietola_slave_node }
    ${slave_node.ipv4_address}
    %{ endfor }
    EOT
}

resource "null_resource" "prepare_cluster" {
  depends_on = [
    local_file.inventory
  ]

  # Setup k8s
  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3 \
      ansible-playbook \
        --user root \
        --inventory 'hosts.ini' \
        --private-key ${var.pvt_key} \
        ../ansible/00-prepare-k8s/deploy.yml
      EOT
  }
}

resource "null_resource" "deploy_apps" {
  depends_on = [
    local_file.inventory,
    null_resource.prepare_cluster
  ]

  # Deploy apps
  provisioner "local-exec" {
    command = <<EOT
      ANSIBLE_HOST_KEY_CHECKING=False \
      ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3 \
      ansible-playbook \
        --user root \
        --inventory 'hosts.ini' \
        --private-key ${var.pvt_key} \
        --extra-vars 'JSON_KEY=${var.json_key}' \
        ../ansible/01-deploy-apps/deploy.yml
      EOT
  }
}
