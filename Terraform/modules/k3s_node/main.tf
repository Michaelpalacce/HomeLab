# A lot of extra parameters passed, since we are configuring already existing vms :) If I ever redo my cluster, can be simplified!
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
    for_each = var.disks == null ? [] : var.disks
    content {
      type    = disk.value["type"] == null ? "scsi" : disk.value["type"]
      storage = disk.value["storage"] == null ? "local-lvm" : disk.value["storage"]
      size    = disk.value["size"] == null ? "64G" : disk.value["size"]
      volume  = disk.value["volume"]
    }
  }

  dynamic "network" {
    for_each = var.networks == null ? [] : var.networks
    content {
      model    = network.value["model"] == null ? "virtio" : network.value["model"]
      bridge   = network.value["bridge"] == null ? "vmbr0" : network.value["bridge"]
      firewall = network.value["firewall"] == null ? false : network.value["firewall"]
      macaddr  = network.value["macaddr"]
    }
  }

  lifecycle {
    ignore_changes = [
      network, desc
    ]
  }
}
