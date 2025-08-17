resource "libvirt_cloudinit_disk" "common" {
  for_each = { for vm in local.vms: vm.name => vm}

  name = "${each.value.name}-cloudinit.iso"
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"

  network_config = templatefile(var.network_config_path, {
    addresses = lookup(each.value, "addresses", [])
    nameservers = local.network.nameservers
    default_gateway = local.network.default_gateway
    dhcp = lookup(each.value, "dhcp", true)
  })

  user_data = templatefile(var.user_data_path, {
    cmds = yamlencode(
      flatten([
        for cmd_key in each.value.cmd_ids : local.cmds[cmd_key]
      ])
    )
    packages = join("\n - ", 
      flatten([
        for package_key in each.value.package_ids : local.packages[package_key]
      ])
    )
  write_files = (
    length(flatten([
      for write_file_key in lookup(each.value, "write_files", []) :
      lookup(local.write_files != null ? local.write_files : {}, write_file_key, {})
    ])) > 0
  ) ? yamlencode(flatten([
        for write_file_key in lookup(each.value, "write_files", []) :
        lookup(local.write_files != null ? local.write_files : {}, write_file_key, {})
      ])) : ""
    user = local.user
    ssh_pub_key = local.ssh_pub_key
  })

  meta_data = templatefile(var.meta_data_path, {
    hostname = each.value.name 
  })
}

