terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.13"
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

# A lot of extra parameters passed, since we are configuring already existing vms :) If I ever redo my cluster, can be simplified!
module "k3s-v1" {
  source      = "./modules/k3s_node"
  name        = "k3s-v1"
  vmid        = 100
  target_node = "prox-1"

  disks = [
    {
      type    = "scsi"
      storage = "local-lvm"
      size    = "64G"
      volume  = "local-lvm:vm-100-disk-0"
    }
  ]

  networks = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      firewall = true
      macaddr  = "22:F9:B7:37:2E:DE"
    }
  ]
}

module "k3s-v2" {
  source      = "./modules/k3s_node"
  name        = "k3s-v2"
  vmid        = 101
  target_node = "prox-1"

  disks = [
    {
      type    = "scsi"
      storage = "local-lvm"
      size    = "64G"
      volume  = "local-lvm:vm-101-disk-0"
    }
  ]

  networks = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      firewall = true
      macaddr  = "0E:D5:B3:62:30:01"
    }
  ]
}

module "k3s-v3" {
  source      = "./modules/k3s_node"
  name        = "k3s-v3"
  vmid        = 102
  target_node = "prox-2"

  disks = [
    {
      type    = "scsi"
      storage = "local-lvm"
      size    = "64G"
      volume  = "local-lvm:vm-102-disk-0"
    },
    {
      type    = "scsi"
      storage = "extra"
      size    = "220G"
      volume  = "extra:vm-102-disk-0"
    }
  ]

  networks = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      firewall = true
      macaddr  = "FE:20:33:30:62:9D"
    }
  ]
}

module "k3s-v4" {
  source      = "./modules/k3s_node"
  name        = "k3s-v4"
  vmid        = 103
  target_node = "prox-2"

  disks = [
    {
      type    = "scsi"
      storage = "local-lvm"
      size    = "64G"
      volume  = "local-lvm:vm-103-disk-0"
    },
    {
      type    = "scsi"
      storage = "extra"
      size    = "220G"
      volume  = "extra:vm-103-disk-0"
    }
  ]

  networks = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      firewall = true
      macaddr  = "92:CC:0F:7C:89:DA"
    }
  ]
}
