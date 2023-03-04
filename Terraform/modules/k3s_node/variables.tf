# Location
variable "name" { type = string }
variable "target_node" { type = string }
variable "vmid" { type = number }

# Resources
variable "cores" {
  type    = optional(number)
  default = 2
}
variable "sockets" {
  type    = optional(number)
  default = 2
}
variable "memory" {
  type    = optional(number)
  default = 11500
}

# Disks
variable "disks" {
  type = list(object({
    type    = optional(string)
    storage = optional(string)
    size    = optional(string)
    volume  = optional(string)
  }))
  default = [
    {
      type    = "scsi"
      storage = "local-lvm"
      size    = "64G"
    }
  ]
}

# Networks
variable "networks" {
  type = list(object({
    model    = optional(string)
    bridge   = optional(string)
    firewall = optional(bool)
    macaddr  = optional(string)
  }))
  default = null
}