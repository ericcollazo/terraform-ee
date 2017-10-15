provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "manager-0" {
  name = "manager-0"
  region = "nyc3"
  size = "2gb"
  image = "centos-7-x64"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true

  provisioner "file" {
    source      = "install-docker-ee.sh"
    destination = "~/install-docker-ee.sh"
  }
}