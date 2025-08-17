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
    network_name = lookup(each.value, "network_name", "default")
    addresses = lookup(each.value, "addresses", [])
  }

  console {
    type = "pty"
    target_port = "0"
    target_type = "serial"
  }

  autostart = lookup(each.value, "autostart", false)
}
