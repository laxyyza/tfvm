resource "libvirt_cloudinit_disk" "common" {
  for_each = { for vm in local.vms: vm.name => vm}

  name = "${each.value.name}-cloudinit.iso"
  pool = local.custom_pool ? libvirt_pool.storage[0].name : "default"

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
      for write_file_key in lookup(each.value, "write_files", []) : local.write_files[write_file_key]
    ])) > 0
  ) ? yamlencode(flatten([
        for write_file_key in lookup(each.value, "write_files", []) : local.write_files[write_file_key]
      ])) : ""
    user = local.user
    ssh_pub_key = local.ssh_pub_key

    shell = local.shell
  })

  meta_data = templatefile(var.meta_data_path, {
    vm_name = each.value.name
    domain = local.network.domain
  })
}

