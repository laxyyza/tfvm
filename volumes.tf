resource "libvirt_volume" "base" {
  name = local.base_image.name
  source = local.base_image.source
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"
}

resource "libvirt_volume" "volumes" {
  for_each = { for vm in local.vms: vm.name => vm}

  name = "${each.value.name}.qcow2"
  base_volume_id = libvirt_volume.base.id
  size = each.value.disk * 1024 * 1024 * 1024
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"
}

