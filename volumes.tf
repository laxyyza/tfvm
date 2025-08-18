resource "libvirt_volume" "base" {
  name = local.base_image.name
  source = local.base_image.source
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"
}

resource "libvirt_volume" "root" {
  for_each = { for vm in local.vms: vm.name => vm}

  name = "${each.value.name}-root.qcow2"
  base_volume_id = libvirt_volume.base.id
  size = each.value.root_size * 1024 * 1024 * 1024
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"
}

resource "libvirt_volume" "extra" {
  for_each = { for d in local.vm_disks : "${d.vm_name}-${d.disk_idx}" => d }

  name = "${each.value.vm_name}-extra-${each.value.disk_idx}.qcow2"
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"
  size = each.value.size * 1024 * 1024 * 1024
}
