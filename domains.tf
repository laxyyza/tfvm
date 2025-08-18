resource "libvirt_domain" "domains" {
  for_each = { for vm in local.vms : vm.name => vm } 

  name = each.value.name
  vcpu = each.value.vcpu
  memory = each.value.memory
  cloudinit = libvirt_cloudinit_disk.common[each.value.name].id

  cpu {
    mode = var.cpu_mode
  }

  disk {
    volume_id = libvirt_volume.root[each.value.name].id
  }

  dynamic "disk" {
    for_each = [ 
      for d in local.vm_disks : d if d.vm_name == each.key
    ]
    content {
      volume_id = libvirt_volume.extra["${each.key}-${disk.value.disk_idx}"].id
    }
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
