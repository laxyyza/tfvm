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

variable "password" {
  type = string
  default = ""
}

variable "username" {
  type = string
  default = "user"
}

variable "ssh_pub_key_path" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_prv_key_path" {
  type = string
  default = "~/.ssh/id_rsa"
}

variable "cpu_mode" {
  type = string
  default = "host-passthrough"
}
