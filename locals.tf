locals {
  config = yamldecode(templatefile(var.config_file, {
    password = var.password
    username = var.username
  }))

  vms = local.config.vms
  base_image = local.config.base_image
  packages = local.config.packages
  cmds = local.config.cmds
  user = local.config.user
  network = local.config.network
  write_files = local.config.write_files
  storage_pool = local.config.storage_pool

  custom_pool = local.config.storage_pool == {} ? false : true

  ssh_pub_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

