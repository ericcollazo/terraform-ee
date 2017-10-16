provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name = "${var.do_key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "digitalocean_droplet" "manager-0" {
  name = "manager-0"
  region = "nyc3"
  size = "2gb"
  image = "ubuntu-16-04-x64"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true
  connection {
    user     = "root"
    agent    = true
  }

  provisioner "remote-exec" {
    script = "install-docker-ee.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${digitalocean_droplet.manager-0.ipv4_address_private}"
    ]
  }
  
}

resource "digitalocean_droplet" "managers" {
  count = 2
  name = "manager-${count.index + 1}"
  region = "nyc3"
  size = "2gb"
  image = "ubuntu-16-04-x64"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true
  connection {
    user     = "root"
    agent    = true
  }

  provisioner "remote-exec" {
    script = "install-docker-ee.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.swarm_join_token.result.manager} ${digitalocean_droplet.manager-0.ipv4_address_private}:2377"
    ]
  }  
}

resource "digitalocean_droplet" "workers" {
  count = 3
  name = "worker-${count.index}"
  region = "nyc3"
  size = "2gb"
  image = "ubuntu-16-04-x64"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true
  connection {
    user     = "root"
    agent    = true
  }

  provisioner "remote-exec" {
    script = "install-docker-ee.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.swarm_join_token.result.worker} ${digitalocean_droplet.manager-0.ipv4_address_private}:2377"
    ]
  }  
}

data "external" "swarm_join_token" {
  program = ["./get-join-tokens.sh"]
  query = {
    host = "${digitalocean_droplet.manager-0.ipv4_address}"
  }
}
