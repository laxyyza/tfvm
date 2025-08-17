resource "libvirt_pool" "storage" {
  count = local.custom_pool == true ? 1 : 0

  name = local.storage_pool.name
  type = "dir"
  target {
    path = local.storage_pool.path
  }
}
