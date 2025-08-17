terraform {
  required_version = ">= v1.12.1"

  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}
