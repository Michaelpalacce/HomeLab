
resource "proxmox_vm_qemu" "k3s_node" {
  name        = var.name
  vmid        = var.vmid
  target_node = var.target_node
  qemu_os     = "l26"

  cores   = var.cores
  sockets = var.sockets
  memory  = var.memory
  scsihw  = "virtio-scsi-pci"

  dynamic "disk" {
    for_each = var.disks
    content {
      type    = disk.value["type"]
      storage = disk.value["storage"]
      size    = disk.value["size"]
      volume  = disk.value["volume"]
    }
  }

  dynamic "network" {
    for_each = var.networks
    content {
      model    = network.value["model"]
      bridge   = network.value["bridge"]
      firewall = network.value["firewall"]
      macaddr  = network.value["macaddr"]
    }
  }

  lifecycle {
    ignore_changes = [
      network, desc
    ]
  }
}
