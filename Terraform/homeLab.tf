terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

variable "pm_api_url" {
  type = string
}
variable "pm_api_token_id" {
  type = string
}
variable "pm_api_token_secret" {
  type = string
}

provider "proxmox" {
  # Configuration options
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

resource "proxmox_vm_qemu" "resource-name" {
  name        = "k3s-v1"
  vmid        = 100
  target_node = "prox-1"
#  iso         = "local:iso/ubuntu-22.04-live-server-amd64.iso"

  cores       = 2
  sockets     = 2
  memory      = 11500


  disk {
    // This disk will become scsi0
    type    = "scsi"
    storage = "local-lvm"
    size    = "64G"
    //<arguments omitted for brevity...>
  }

  network{
    model     = "virtio"
    bridge    = "vmbr0"
    firewall  = true
  }
}