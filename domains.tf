resource "libvirt_domain" "domains" {
  for_each = { for vm in local.vms : vm.name => vm } 

  name = each.value.name
  vcpu = each.value.vcpu
  memory = each.value.memory

  cloudinit = libvirt_cloudinit_disk.common[each.value.name].id

  disk {
    volume_id = libvirt_volume.volumes[each.value.name].id
  }

  network_interface {
    network_id = libvirt_network.network.id
    hostname = each.value.name
    addresses = lookup(each.value, "addresses", [])
  }

  console {
    type = "pty"
    target_port = "0"
    target_type = "serial"
  }

  autostart = local.autostart
}
