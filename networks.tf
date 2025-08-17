resource "libvirt_network" "network" {
  name = local.network.name
  domain = local.network.domain
  mode = local.network.mode
  addresses = local.network.addresses
  autostart = local.autostart

  dns {
    enabled = local.network.dns
  }
}

