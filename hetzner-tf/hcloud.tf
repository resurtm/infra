# https://opensource.org/license/mit/
#
# Copyright 2023 resurtm@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the “Software”), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

variable "hcloud_token" {}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "ssh_key_alpha" {
  name       = "ssh-key-alpha"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_network" "network_alpha" {
  name     = "network-alpha"
  ip_range = "10.98.0.0/16"
}
resource "hcloud_network_subnet" "network_subnet_alpha" {
  network_id   = hcloud_network.network_alpha.id
  type         = "server"
  network_zone = "eu-central"
  ip_range     = "10.98.0.0/16"
}

resource "hcloud_server" "server_alpha" {
  name        = "server-alpha"
  image       = "ubuntu-22.04"
  server_type = "cx11"
  location    = "nbg1"
  network {
    network_id = hcloud_network.network_alpha.id
  }
  ssh_keys = [hcloud_ssh_key.ssh_key_alpha.id]
  depends_on = [
    hcloud_network_subnet.network_subnet_alpha,
    hcloud_ssh_key.ssh_key_alpha
  ]
}
resource "hcloud_server" "server_beta" {
  name        = "server-beta"
  image       = "ubuntu-22.04"
  server_type = "cx21"
  location    = "nbg1"
  network {
    network_id = hcloud_network.network_alpha.id
  }
  ssh_keys = [hcloud_ssh_key.ssh_key_alpha.id]
  depends_on = [
    hcloud_network_subnet.network_subnet_alpha,
    hcloud_ssh_key.ssh_key_alpha
  ]
}
resource "hcloud_server" "server_gamma" {
  name        = "server-gamma"
  image       = "ubuntu-22.04"
  server_type = "cx21"
  location    = "nbg1"
  network {
    network_id = hcloud_network.network_alpha.id
  }
  ssh_keys = [hcloud_ssh_key.ssh_key_alpha.id]
  depends_on = [
    hcloud_network_subnet.network_subnet_alpha,
    hcloud_ssh_key.ssh_key_alpha
  ]
}

resource "hcloud_floating_ip" "hcloud_floating_alpha" {
  type          = "ipv4"
  home_location = "nbg1"
}
resource "hcloud_floating_ip" "hcloud_floating_beta" {
  type          = "ipv6"
  home_location = "nbg1"
}
resource "hcloud_floating_ip_assignment" "floating_ip_assignment_alpha" {
  floating_ip_id = hcloud_floating_ip.hcloud_floating_alpha.id
  server_id      = hcloud_server.server_alpha.id
}
resource "hcloud_floating_ip_assignment" "floating_ip_assignment_beta" {
  floating_ip_id = hcloud_floating_ip.hcloud_floating_beta.id
  server_id      = hcloud_server.server_alpha.id
}
