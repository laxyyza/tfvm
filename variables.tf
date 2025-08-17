variable "libvirt_uri" {
  type = string
  default = "qemu:///system"
}

variable "config_file" {
  type = string
  default = "input/config.yaml"
}

variable "meta_data_path" {
  type = string
  default = "cloudinit/meta-data.tpl"
}

variable "user_data_path" {
  type = string
  default = "cloudinit/user-data.tpl"
}

variable "network_config_path" {
  type = string
  default = "cloudinit/network-config.tpl"
}

variable "password" {
  type = string
}

variable "username" {
  type = string
  default = "user"
}
