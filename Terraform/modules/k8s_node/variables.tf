# Location
variable "name" { type = string }
variable "target_node" { type = string }
variable "vmid" { type = number }

# Resources
variable "cores" { type = number }
variable "sockets" { type = number }
variable "memory" { type = number }

# Disks
variable "disks" {
  type = list(object({
    type    = string
    storage = string
    size    = string
    volume  = string
  }))
  default = [
    {
      type    = "scsi"
      storage = "local-lvm"
      size    = "64G"
      volume  = ""
    }
  ]
}

# Networks
variable "networks" {
  type = list(object({
    model    = string
    bridge   = string
    firewall = bool
    macaddr  = string
  }))
  default = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      firewall = false
      macaddr  = ""
    }
  ]
}